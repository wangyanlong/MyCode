//
//  ViewController.m
//  crash
//
//  Created by 王老师 on 16/6/1.
//  Copyright © 2016年 wyl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setTitle:@"test" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(t:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(100, 300, 100, 100);
    [btn2 setTitle:@"test" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(t2) forControlEvents:UIControlEventTouchUpInside];
    btn2.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
    [self.view addSubview:btn2];
    
    
}

- (void)t2{
    NSLog(@"123");
}

- (void)t{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
