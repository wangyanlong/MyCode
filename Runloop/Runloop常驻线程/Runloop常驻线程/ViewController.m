//
//  ViewController.m
//  Runloop常驻线程
//
//  Created by 王老师 on 16/7/19.
//  Copyright © 2016年 wyl. All rights reserved.
//
#import "TestOperation.h"
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    self.queue = [[NSOperationQueue alloc]init];
    self.queue.maxConcurrentOperationCount = 1;
    
    for (int i = 0 ; i < 10; i++) {
        TestOperation *t = [[TestOperation alloc]init];
        t.tag = i;
        [self.queue addOperation:t];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
