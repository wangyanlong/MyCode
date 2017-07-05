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

@end
