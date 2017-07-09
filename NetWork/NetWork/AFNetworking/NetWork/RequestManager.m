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
    
    request = [self.requestManager.requestSerializer requestWithMethod:method URLString:urlString parameters:parameters error:nil];
    
    AFHTTPRequestOperation *operation = [self createOperationWithRequest:request];
    
    if (!startImmediately) {//不开启任务
        
        NSMutableDictionary *methodParameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:method,@"method" ,nil];
        if (urlString) {
            [methodParameters setObject:urlString forKey:@"URLString"];
        }
        if (parameters) {
            [methodParameters setObject:parameters forKey:@"parameters"];
        }
        
        if (resultCacheDuration) {
            [methodParameters setObject:@(resultCacheDuration) forKey:@"resultCacheDuration"];
        }
        
        if (ignoreCache) {
            [methodParameters setObject:@(ignoreCache) forKey:@"ignoreCache"];
        }
        
        if (completionHandler) {
            [methodParameters setObject:completionHandler forKey:@"completionHandler"];
        }
        
        //NSMapTable可以弱引用
        [self.operationMethodParameters setObject:methodParameters forKey:operation];
        
        return operation;
    }
    
    NSString *urlKey = [NSString cacheFileKeyNameWithUrlstring:urlString method:method parameters:parameters];
    
    if ([self checkIfShouldSkipCacheFileWithCacheDuration:resultCacheDuration cacheKey:urlKey] || ignoreCache) {
    configOperation:
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
           
            //[self hand]
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
        }];
    }
    
    return nil;
    
}

- (AFHTTPRequestOperation *)createOperationWithRequest:(NSURLRequest *)request{
    
    return [[AFHTTPRequestOperation alloc] initWithRequest:request];

}

//判断是不是需要跳过缓存数据
-(BOOL)checkIfShouldSkipCacheFileWithCacheDuration:(NSTimeInterval)resultCacheDuration cacheKey:(NSString*)urlkey{
    
    if (resultCacheDuration == 0) {//如果不需要缓存
        return YES;
    }
    
    
    
    return YES;
}

- (AFHTTPRequestOperationManager *)requestManager{
    
    if (!_requestManager) {
        
        _requestManager = [AFHTTPRequestOperationManager manager];
        _requestManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];
        _requestManager.requestSerializer.timeoutInterval = 30;
        
    }
    
    return _requestManager;
}

@end
