//
//  ViewController.m
//  NSURLProtocol
//
//  Created by wyl on 2017/6/28.
//  Copyright © 2017年 wyl. All rights reserved.
//
#import "MyURLProtocol.h"
#import "ViewController.h"

@interface ViewController ()<NSURLSessionDelegate>

@property (nonatomic, strong)NSInputStream *inputStream;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@", docPath);
    
    // versions_id=1
    NSString *bodyStr = @"versions_id=1&system_type=1";
    self.inputStream = [[NSInputStream alloc] initWithData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com/center/front/app/util/updateVersions"];
    
    //请求体
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"POST"]; //
    [request setHTTPBodyStream:self.inputStream];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.protocolClasses = [NSArray arrayWithObjects:[MyURLProtocol class], nil];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request];
    [task resume];

}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    // 进度，在这里处理逻辑 UI 操作在主线程
    NSDictionary *infoDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    if (infoDict) {
        NSLog(@"%@", infoDict);
    }else{
        
        UIImage *img = [UIImage imageWithData:data];
        NSLog(@"%@",img);
        NSLog(@"%s", [data bytes]);
        
    }
    
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"==%@", error);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
