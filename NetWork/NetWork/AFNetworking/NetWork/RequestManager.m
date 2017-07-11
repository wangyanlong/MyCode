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
           
            [self handleResponseWithOperation:operation result:responseObject isCache:NO completionHandler:completionHandler];
            
            if (resultCacheDuration > 0) {// 如果使用缓存，就把结果放到缓存中方便下次使用
                
                NSString *urlKey = [NSString cacheFileKeyNameWithUrlstring:urlString method:method parameters:parameters];
                [self.cache setObject:responseObject forKey:urlKey];
                
            }
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
            if (error.code != NSURLErrorCancelled) {
                [self handleResponseWithOperation:operation result:error isCache:NO completionHandler:completionHandler];
            }
            
        }];
        
        [self.requestManager.operationQueue addOperation:operation];
    }else
    { // AF
        id result = [self.cache objectForKey:urlKey];
        if (result) {//如果需要使用缓存则判断缓存是不是存在，不存在的话这继续获取新的数据
            [self handleResponseWithOperation:operation result:result isCache:YES completionHandler:completionHandler];
        }
        else
        {
            goto configOperation;
        }
    }
    
    return nil;
    
}

//对request的 响应 进行一些处理
- (void)handleResponseWithOperation:(AFHTTPRequestOperation*)operation
                             result:(id)responseObject//有错误把错误的实例作为参数，没有错误就把返回数据作为参数
                            isCache:(BOOL)isCache
                  completionHandler:(RequestCompletionHandler)completionHandler{
    
    MYNSError *error = nil;
    id result = nil;
    
    if ([responseObject isKindOfClass:[NSError class]]) {
        
        error = [MYNSError new];
        error.errorCode = @"404";
        error.errorDescription = @"网络异常";
        error.sysError = responseObject;
        
    }else{
        
        result = [self decodeResponseObject:responseObject error:&error];
        if (result == [NSNull null]) {
            result = nil;
        }
        
    }
    
    if (completionHandler) {
        
        if ([result isKindOfClass:[NSDictionary class]])
        {
            int temp = [[result objectForKey:@"code"] intValue];
            // 统一处理特定的错误
            if (temp == 999 || temp == 998 || temp == 209)
            {
                if (!error)
                    error = [MYNSError new];
                error.errorCode = [result objectForKey:@"code"];
                error.errorDescription = [result objectForKey:@"msg"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutNotification" object:nil];
            }
        }
        else
        {
            if (!error)
                error = [MYNSError new];
            error.errorCode = @"404";
            error.errorDescription = @"网络连接失败,请检查网络";
        }
        completionHandler(error,result,isCache,operation);
        
    }
    
}

// 对响应结果做处理 格式
- (id)decodeResponseObject:(id)responseObject error:(MYNSError **)error
{
    if ([responseObject isKindOfClass:[NSData class]])
    {
        return [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
    }
    else if([responseObject isKindOfClass:[NSDictionary class]])
    {
        return responseObject;
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
