//
//  MyURLProtocol.m
//  NSURLProtocol
//
//  Created by wyl on 2017/6/28.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "MyURLProtocol.h"

@implementation MyURLProtocol

//1 确认是否截获http请求
+ (BOOL)canInitWithRequest:(NSURLRequest *)request{

    NSString *urlStr = request.URL.path;
    // 只处理图片
    if ([urlStr hasSuffix:@".png"] || [urlStr hasSuffix:@".jpg"] || [urlStr hasSuffix:@".gif"]) {

        return YES;
    }
    
    return NO;
    
}

// 2 修改
+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest *)request{
    
    NSLog(@"%s", __func__);
    
    NSMutableURLRequest *mutableRequrest = request.mutableCopy;
    
    /*
     这里可以做你想做的事，更改地址，
     body拿不到的，返回的是nil（但修改可以）
     */
    NSURL *url = [mutableRequrest.URL copy];
    NSString *urlHost = url.host;
    if ([urlHost isEqualToString:@"www.baidu.com"]) {
        
        NSString *urlStr = [url absoluteString];
        
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"www.baidu.com" withString:@"svr.tuliu.com"];
        mutableRequrest.URL = [NSURL URLWithString:urlStr];
    }
    
    return mutableRequrest;
}

- (void)startLoading{
    
    NSLog(@"%s", __func__);
    
    
    NSMutableURLRequest *mutableRequest = [self.request mutableCopy];
    
    //可以根据此方法,做拦截判断
    //[NSURLProtocol setProperty:@(YES) forKey:@"Test" inRequest:mutableRequest];
    
    BOOL isDebug = YES;
    if (isDebug) {
        
        NSString *content = @"myTest";
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:mutableRequest.URL MIMEType:@"text" expectedContentLength:content.length textEncodingName:nil];
        
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
//        [self.client URLProtocol:self didLoadData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        
        UIImage *tmpImage = [UIImage imageNamed:@"1.png"];
        [self.client URLProtocol:self didLoadData:UIImagePNGRepresentation(tmpImage)];
        
        [self.client URLProtocolDidFinishLoading:self];
        
        
    }else {
        
        // 开启一个网络
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        NSURLSessionTask *task = [self.session dataTaskWithRequest:mutableRequest];
        
        [task resume];
        
    }
    
}

#pragma mark - Net delegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSLog(@"protocol response");
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSLog(@"protocol didReceiveData");
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"protocol Finish");
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading{
    
    NSLog(@"%s", __func__);
    [self.session invalidateAndCancel];
    self.session = nil;
    
}

@end
