//
//  ThreadRunloopObserver.m
//  Runloop与Observer
//
//  Created by 王老师 on 16/7/23.
//  Copyright © 2016年 wyl. All rights reserved.
//

#import "ThreadRunloopObserver.h"

@interface ThreadRunloopObserver ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ThreadRunloopObserver

void defaultModeRunloopCallBack2(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"RunLoop 开始了");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"RunLoop 准备处理定时器");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"RunLoop 准备处理输入源");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"RunLoop 进入睡眠");
            NSLog(@"我想做点事儿");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"RunLoop 被唤醒");
            break;
        case kCFRunLoopExit:
            NSLog(@"RunLoop 退出");
            break;
        default:
            break;
    }
    
}

- (void)main{
    
    @autoreleasepool {
#pragma mark - 添加观察者
        
        CFRunLoopObserverContext context = {
          
            0,
            (__bridge void*)(self),
            NULL,
            NULL,
            NULL
            
        };
        
        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(NULL, kCFRunLoopAllActivities, YES, 0, &defaultModeRunloopCallBack2, &context);
        
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
        
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(test) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
        
    }
    
}

static int i = 0;

- (void)test{

    i ++;
    
    NSLog(@"第%d次处理timer事件",i);
    
    if (i == 5){
        [_timer invalidate];
        _timer = nil;
        CFRunLoopStop(CFRunLoopGetCurrent());
    }
    
}

- (void)dealloc
{
    NSLog(@"%@--%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}

@end
