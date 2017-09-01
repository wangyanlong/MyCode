//
//  ViewController.m
//  RuntimeEncodeDemo
//
//  Created by 王老师 on 2017/2/5.
//  Copyright © 2017年 wyl. All rights reserved.
//
#import "Person.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Person *p = [[Person alloc]init];
    p.name = @"wyl";
    p.age = 30;
    
    NSString *homePath = NSHomeDirectory();
    NSString *path = [homePath stringByAppendingPathComponent:@"wyl.archiver"];
    
    [NSKeyedArchiver archiveRootObject:p toFile:path];
    
    Person *p2 = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    NSLog(@"%@--%d",p2.name,p2.age);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
