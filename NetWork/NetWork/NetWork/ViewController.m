//
//  ViewController.m
//  NetWork
//
//  Created by wyl on 2017/7/4.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
