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

    
    
}

@end
