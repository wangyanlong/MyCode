//
//  RequestManager.m
//  NetWork
//
//  Created by wyl on 2017/7/5.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "HttpResponceCache.h"
#import "RequestManager.h"

@interface RequestManager ()

@property (nonatomic, strong)AFHTTPRequestOperationManager *requestManager;
@property (nonatomic,strong) NSMutableArray *batchGroups;//批处理
@property (nonatomic,strong) NSMutableDictionary *chainedOperations;
@property (nonatomic,strong) NSMapTable *operationMethodParameters; //保存opeation参数

@end

@implementation RequestManager

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        self.cache = [HttpResponceCache sharedCache];
        self.operationMethodParameters = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableStrongMemory];
    }
    
    return self;

}

+ (instancetype)sharedInstance{
    
    static RequestManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RequestManager alloc] init];
    });
    
    return instance;
    
}

- (AFHTTPRequestOperation *)httpRequestWithMethod:(NSString *)method urlString:(NSString *)urlString parameters:(NSDictionary *)parameters startImmediately:(BOOL)startImmediately ignoreCache:(BOOL)ignoreCache resultCacheDuration:(NSTimeInterval)resultCacheDuration completionHandler:(RequestCompletionHandler)completionHandler{
    
    if (![method isEqualToString:@"GET"]) {
        method = @"POST";
    }
    
#warning 为什么这么写?
    if (parameters) {
        parameters = parameters.mutableCopy;
    }
    
    NSMutableURLRequest *request;
    
//    request = [self.]
    
    return nil;
    
}

@end
