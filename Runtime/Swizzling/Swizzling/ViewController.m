//
//  ViewController.m
//  Swizzling
//
//  Created by 王老师 on 2017/2/1.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "ViewController.h"
#import "ViewController+Swizzling.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"viewDidLoad");
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
