//
//  ViewController.m
//  NetWork
//
//  Created by wyl on 2017/7/4.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "RequestManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self net];
    
}

- (void)net{
    
    NSString *urlStr = @"http://svr.tuliu.com/center/front/app/util/updateVersions";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"1" forKey:@"versions_id"];
    [parameters setObject:@"1" forKey:@"system_type"];
    
    [[RequestManager sharedInstance]httpRequestWithMethod:@"POST" urlString:urlStr parameters:parameters startImmediately:YES ignoreCache:NO resultCacheDuration:3 completionHandler:^(MYNSError * _Nonnull error, id  _Nonnull result, BOOL isFromCache, AFHTTPRequestOperation * _Nonnull operation) {
       
        if (error) {
            NSLog(@"%@", error);
        }else{
            
            NSLog(@"%@", result);
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
