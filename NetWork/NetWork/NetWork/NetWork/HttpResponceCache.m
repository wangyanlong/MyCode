//
//  HttpResponceCache.m
//  NetWork
//
//  Created by wyl on 2017/7/5.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "HttpResponceCache.h"

@implementation HttpResponceCache

+ (instancetype)sharedCache{
    static HttpResponceCache *sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[HttpResponceCache alloc] init];
    });
    return sharedCache;
}

@end
