//
//  HttpResponceCache.h
//  NetWork
//
//  Created by wyl on 2017/7/5.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HttpResponceCache : NSObject
{
    NSString *_string;
}
/**
 缓存存在的最大时间默认, 单位秒
 */
@property (nonatomic, assign) NSInteger maxCacheAge;

/**
 缓存最大的存储空间, 单位bytes.
 */
@property (nonatomic, assign) NSUInteger maxCacheSize;

+ (instancetype)sharedCache;

-(void)addProtectCacheKey:(NSString*)key;

//缓存数据
- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key;

//获取缓存
- (id <NSCoding>)objectForKey:(NSString *)key;

//删除指定的缓存
- (void)removeObjectForKey:(NSString *)key;

//删除到指定日期的缓存
- (void)deleteCacheToDate:(NSDate *)date;

//删除所有缓存缓存
- (void)clearCacheOnDisk;

//文件存在的时间
-(NSTimeInterval)cacheFileDuration:(NSString *)path;

/**
 *  判断一个文件是不是过期
 *
 *  @param cacheFileNamekey 文件名
 *  @param duration         有效时间
 */
-(BOOL)expiredWithCacheKey:(NSString*)cacheFileNamekey
             cacheDuration:(NSTimeInterval)duration;

@end
