//
//  TestOperation.m
//  NSOperationDemo
//
//  Created by 王老师 on 2016/12/13.
//  Copyright © 2016年 wyl. All rights reserved.
//

#import "TestOperation.h"

@implementation TestOperation

- (void)main{
    
    if (self.isExecuting) {
        NSLog(@"正在执行 %ld",self.i);
    }
    
    [NSThread sleepForTimeInterval:1.0f];
    
    //isCancelled 这个属性,要在你的任务体的任何一个重要的环节都要进行判断
    if (self.isCancelled) {
        NSLog(@"cancel %ld",self.i);
        return;
    }
    
    NSLog(@"%ld---%@",self.i,[NSThread currentThread]);
    
}

@end
