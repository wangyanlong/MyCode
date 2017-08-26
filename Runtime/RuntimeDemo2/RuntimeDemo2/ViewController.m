//
//  ViewController.m
//  RuntimeDemo2
//
//  Created by 王老师 on 2017/1/29.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "ViewController.h"
#import "Test.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Test *t = [[Test alloc]init];
    //[t performSelector:@selector(method1)];
    //[t performSelector:@selector(method2)];
    [t performSelector:@selector(method3)];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
