//
//  ViewController.m
//  RuntimeAssociated
//
//  Created by 王老师 on 2017/1/26.
//  Copyright © 2017年 wyl. All rights reserved.
//
#import "ViewController+RunTime.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.log = @"1234567eeee";
    
    [self logString];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
