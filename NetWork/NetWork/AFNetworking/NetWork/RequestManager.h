//
//  RequestManager.h
//  NetWork
//
//  Created by wyl on 2017/7/5.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "MYNSError.h"
#import "NSString+HttpResponce.h"
#import "HttpResponceCache.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RequestCompletionHandler)(MYNSError *error, id result, BOOL isFromCache, AFHTTPRequestOperation *operation);

@interface RequestManager : NSObject

@property (nonatomic, strong)HttpResponceCache *cache;

+ (instancetype)sharedInstance;

/**
 *  默认POST 方法
 *
 *  @param method              GET／POST
 *  @param urlString           ULR
 *  @param parameters          参数
 *  @param startImmediately    YES 马上执行; NO不马上执行 直接返回AFHTTPRequestOperation对象
 *  @param ignoreCache         是否忽略缓存 YES忽略;  NO不忽略, 使用缓存
 *  @param resultCacheDuration 该请求在缓存中存在的时间 -1 表示永久存储  0 表示不存储, 其他表示存储的对应时间(单位秒)
 *  @param completionHandler   处理结果
 *
 *  @return 返回对应的请求
 */
- (AFHTTPRequestOperation *)httpRequestWithMethod:(NSString *)method urlString:(NSString *)urlString parameters:(NSDictionary *)parameters startImmediately:(BOOL)startImmediately ignoreCache:(BOOL)ignoreCache resultCacheDuration:(NSTimeInterval)resultCacheDuration completionHandler:(__nullable RequestCompletionHandler)completionHandler;


@end

NS_ASSUME_NONNULL_END
