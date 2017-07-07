//
//  HttpResponceCache.m
//  NetWork
//
//  Created by wyl on 2017/7/5.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "HttpResponceCache.h"

static NSString *CacheFileProcessingQueue = @"com.WYL.Class"; // 文件IO处理队列
static NSString *CacheDirectory = @"ClassCache"; // 缓存文件夹
static const NSInteger kHNDefaultCacheMaxCacheAge = 60 * 60 * 24 * 7; // 1 周

@interface AutoPurgeCache : NSCache

@end

@implementation AutoPurgeCache

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (void)removeAllObjects{
    
    [super removeAllObjects];
    
}

@end

@interface HttpResponceCache ()

//用来保护受保护的 缓存文件
@property (strong, nonatomic) NSMutableSet *protectCaches;

@end

@implementation HttpResponceCache{
    
    AutoPurgeCache *_memoryCache;//cache 用来解决频繁从文件系统中 读取文件的 系能问题
    NSString *_cachePaht;
    NSFileManager *_fileManager;
    dispatch_queue_t    _IOQueue;
    
}


+ (instancetype)sharedCache{
    static HttpResponceCache *sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[HttpResponceCache alloc] init];
    });
    return sharedCache;
}

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        _memoryCache = [[AutoPurgeCache alloc] init];
        
        _IOQueue = dispatch_queue_create([CacheFileProcessingQueue UTF8String], DISPATCH_QUEUE_CONCURRENT);
        
        _maxCacheAge = kHNDefaultCacheMaxCacheAge;
        
        dispatch_async(_IOQueue, ^{
           
            _fileManager = [NSFileManager new];
            // 要判断是否有文件EOCClassCache存在，如果存在，干掉，创建EOCClassCache文件夹
            [self checkDirectory];
            
        });
        
        // 缓存清除操作放到退出后台操作
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgroundCleanDisk) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clearCacheOnDisk {
    [self clearCacheOnDisk:nil];
}

- (void)clearCacheOnDisk:(void (^)(void))completion{
    
    dispatch_async(_IOQueue, ^{
        [_fileManager removeItemAtPath:_cachePaht error:nil];
        [_fileManager createDirectoryAtPath:_cachePaht
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:NULL];
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
    
}

//删除指定到哪一天的缓存
- (void)deleteCacheToDate:(NSDate *)date{
    
    __autoreleasing NSError *error = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL URLWithString:_cachePaht] includingPropertiesForKeys:@[NSURLContentModificationDateKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    
    if (error) {
        NSLog(@"获取缓存列表失败:%@", error);
    }
    
    dispatch_async(_IOQueue, ^{
       
        for (NSURL *fileUrl in files) {
            
            NSDictionary *dictionary = [fileUrl resourceValuesForKeys:@[NSURLContentModificationDateKey] error:nil];
            NSDate *modificationDate = [dictionary objectForKey:NSURLContentModificationDateKey];
            if (modificationDate.timeIntervalSince1970 - date.timeIntervalSince1970 < 0) {
                [[NSFileManager defaultManager]  removeItemAtPath:fileUrl.absoluteString error:nil];
            }
            
        }
        
    });
    
}

- (void)removeObjectForKey:(NSString *)key{
    
    [_memoryCache removeObjectForKey:key];
    NSString *filePath = [_cachePaht stringByAppendingPathComponent:key];
    if ([_fileManager fileExistsAtPath:filePath]) {
        __autoreleasing NSError *error = nil;
        BOOL removed = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (!removed) {
            NSLog(@"删除缓存失败:%@", error);
        }
    }
    
}

//判断一个文件是不是过期
- (BOOL)expiredWithCacheKey:(NSString *)cacheFileNameKey cacheDuration:(NSTimeInterval)expirationDuration{
    
    NSString *filePath = [_cachePaht stringByAppendingPathComponent:cacheFileNameKey];
    BOOL fileExist = [_fileManager fileExistsAtPath:filePath];
    if (fileExist) {
        NSTimeInterval fileDuration = [self cacheFileDuration:filePath];
        return fileDuration > expirationDuration;
    }else{
        return YES;//如果文件不存在 则设置为  过期文件
    }
    
}

// 获取文件的修改日期
- (NSTimeInterval)cacheFileDuration:(NSString *)path {
    
    NSError *attributesRetrievalError = nil;
    NSDictionary *attributes = [_fileManager attributesOfItemAtPath:path error:&attributesRetrievalError];
    
    if (!attributes) {
        NSLog(@"获取文件属性失败 %@: %@", path, attributesRetrievalError);
        return -1;
    }
    
    //文件的修改时间
    NSTimeInterval seconds = -[[attributes fileModificationDate] timeIntervalSinceNow];
    
    return seconds;
    
}

//检查缓存文件夹 如果没有就创建缓存文件夹文件夹
- (void)checkDirectory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);

    _cachePaht = [[paths objectAtIndex:0] stringByAppendingPathComponent:CacheDirectory];
    
    BOOL isDir;
    
    if (![_fileManager fileExistsAtPath:_cachePaht isDirectory:&isDir]) {
        
        [self createBaseDirectoryAtPath];
    
    }else{
        
        if (!isDir) { // 如果不是文件夹
            
            NSError *error = nil;
            [_fileManager removeItemAtPath:_cachePaht error:&error];
            [self createBaseDirectoryAtPath];
            
        }
        
    }
    
}

//创建 缓存文件夹
- (void)createBaseDirectoryAtPath{

    __autoreleasing NSError *error = nil;
    
    BOOL created = [_fileManager createDirectoryAtPath:_cachePaht withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!created) {
        
        NSLog(@"创建 缓存文件夹失败:%@",error );

    }else{
    
        NSURL *url = [NSURL fileURLWithPath:_cachePaht];
        
        NSError *error = nil;
        
        [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
        
        if (error) {
            NSLog(@"没有成功的设置 ‘应用不能备份的属性’, error = %@", error);
        }
    
    }
    
}

//清除过期的内存
- (void)backgroundCleanDisk{
    
    UIApplication *application = [UIApplication sharedApplication];
    
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
       
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
        
    }];
    
    [self cleanDiskWithCompletionBlock:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
}

- (void)cleanDiskWithCompletionBlock:(void (^)(void))completionBlock{

    dispatch_async(_IOQueue, ^{
       
        NSURL *diskCacheUrl = [NSURL fileURLWithPath:_cachePaht isDirectory:YES];
        NSArray *resourceKeys = @[NSURLLocalizedNameKey,NSURLNameKey,NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
        
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:diskCacheUrl includingPropertiesForKeys:resourceKeys options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:NULL];
        
        //过期时间
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-self.maxCacheAge];
        
        NSMutableDictionary *cacheFiles = [NSMutableDictionary dictionary];
        NSUInteger currentCacheSize = 0;
        
        NSMutableArray *urlsToDelete = [[NSMutableArray alloc] init];
        
        //删除过期文件
        for (NSURL *fileUrl in fileEnumerator) {
            
            NSDictionary *resourceValues = [fileUrl resourceValuesForKeys:resourceKeys error:NULL];
            
            //跳过文件夹
            if ([resourceValues[NSURLIsDirectoryKey] boolValue]){
                continue;
            }
            
            //跳过指定不能删除的文件
            if ([self.protectCaches containsObject:fileUrl.lastPathComponent]) {
                continue;
            }
            
            NSDate *modificationDate = resourceValues[NSURLContentModificationDateKey];
            if ([[modificationDate laterDate:expirationDate] isEqualToDate:expirationDate]) {
                [urlsToDelete addObject:fileUrl];
                continue;
            }
            
            NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
            currentCacheSize += [totalAllocatedSize unsignedIntegerValue];
            [cacheFiles setObject:resourceValues forKey:fileUrl];
            
        }
        
        for (NSURL *fileUrl in urlsToDelete) {
            [_fileManager removeItemAtURL:fileUrl error:nil];
        }
        
        // 如果删除过期的文件后，缓存的总大小还大于maxsize 的话则删除比较快老的缓存文件
        if (self.maxCacheSize > 0 && currentCacheSize > self.maxCacheSize) {
            
            // 这个过程主要清除到最大缓存的一半大小
            const NSUInteger desiredCacheSize = self.maxCacheSize / 2;
            
            NSArray *sortedFiles = [cacheFiles keysSortedByValueWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
               
                return [obj1[NSURLContentModificationDateKey] compare:obj2[NSURLContentModificationDateKey]];
                
            }];
            
            for (NSURL *fileUrl in sortedFiles) {
                
                if ([_fileManager removeItemAtURL:fileUrl error:nil]) {
                    
                    NSDictionary *resourceValues = cacheFiles[fileUrl];
                    NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
                    currentCacheSize -= [totalAllocatedSize unsignedIntegerValue];
                    if (currentCacheSize < desiredCacheSize) {
                        break;
                    }
                    
                }
                
            }
        }
        
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock();
            });
        }
        
    });
    
}

#pragma -mark 读写

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key{
    
    if (!object) {
        return;
    }
    
    [_memoryCache setObject:object forKey:key];
    
    dispatch_async(_IOQueue, ^{
       
        NSString *filePath = [_cachePaht stringByAppendingPathComponent:key];
        BOOL written = [NSKeyedArchiver archiveRootObject:object toFile:filePath];
        if (!written) {
            NSLog(@"写入缓存失败");
        }
        
    });
    
}

/*
 先读NSCache， 然后读文件,如果读了文件,把对象放入cache中
 */
- (id<NSCoding>)objectForKey:(NSString *)key{
    
    id<NSCoding>object = [_memoryCache objectForKey:key];
    if (!object) {
        NSString *filePath = [_cachePaht stringByAppendingPathComponent:key];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            
            object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            
            [_memoryCache setObject:object forKey:key];
        }
    }
    return object;
}

@end
