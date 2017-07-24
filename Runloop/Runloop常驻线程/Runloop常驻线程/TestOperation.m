//
//  TestOperation.m
//  RunLoop异步线程常驻
//
//  Created by 王老师 on 16/6/17.
//  Copyright © 2016年 wyl. All rights reserved.
//

#import "TestOperation.h"

@implementation TestOperation

- (void)dealloc
{
    NSLog(@"%@--%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}

- (void)main{
    
    NSLog(@"开始%ld",self.tag);
    //addPort:添加端口(就是source)  forMode:设置模式
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    //启动RunLoop
    [[NSRunLoop currentRunLoop] run];
    
    NSLog(@"结束%ld",self.tag);
}



@end
