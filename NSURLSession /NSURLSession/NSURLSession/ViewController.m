//
//  ViewController.m
//  NSURLSession
//
//  Created by wyl on 2017/6/24.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

//get
- (void)method1{

    //确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=520&pwd=520&type=JSON"];
    //创建 NSURLSession 对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    /**
     根据对象创建 Task 请求
     
     url  方法内部会自动将 URL 包装成一个请求对象（默认是 GET 请求）
     completionHandler  完成之后的回调（成功或失败）
     
     param data     返回的数据（响应体）
     param response 响应头
     param error    错误信息
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:
                                      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                          
                                          //解析服务器返回的数据
                                          NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                          //默认在子线程中解析数据
                                          NSLog(@"%@", [NSThread currentThread]);
                                      }];
    //发送请求（执行Task）
    [dataTask resume];
    
}

//post
- (void)method2{
    
    //确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
    //创建可变请求对象
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    //修改请求方法
    requestM.HTTPMethod = @"POST";
    //设置请求体
    requestM.HTTPBody = [@"username=520&pwd=520&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    //创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //创建请求 Task
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:requestM completionHandler:
                                      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                          
                                          //解析返回的数据
                                          NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                      }];
    //发送请求
    [dataTask resume];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self method2];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
