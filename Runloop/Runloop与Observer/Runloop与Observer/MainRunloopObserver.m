//
//  MainRunloopObserver.m
//  Runloop与Observer
//
//  Created by 王老师 on 16/7/23.
//  Copyright © 2016年 wyl. All rights reserved.
//

#import "MainRunloopObserver.h"

@implementation MainRunloopObserver

void defaultModeRunloopCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    
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

- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册一个主线程的runloop
        [self registerRunloopWithMainRunloopControl:(__bridge void*)self withActivities:kCFRunLoopAllActivities withOrder:0 withMode:kCFRunLoopDefaultMode withCallback:&defaultModeRunloopCallBack];
    }
    return self;
}

- (void)registerRunloopWithMainRunloopControl:(void *)info withActivities:(CFOptionFlags)activities withOrder:(CFIndex)order withMode:(CFStringRef)mode withCallback:(CFRunLoopObserverCallBack)callback{
    
    CFRunLoopObserverRef observer;
    
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    
    //观察者上下文
    CFRunLoopObserverContext context = {
        0,
        info,
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    /**
     *  创建RunLoopObserver对象
     *
     *  @param NULL       第一个参数用于分配observer对象的内存
     *  @param activities 第二个参数用于设置observer所要关注的事件
     *  @param YES        第三个参数用于表示该observer是在第一次进入runloop是执行还是每次进入runloop处理时,均执行
     *  @param order      第四个参数是处理该observer的优先级
     *  @param callback   第五个参数是处理该observer的回调函数
     *  @param context    第六个参数是该observer的运行环境
     *
     *  @return observer对象
     */
    observer = CFRunLoopObserverCreate(NULL, activities, YES, order, callback, &context);
    
    CFRunLoopAddObserver(runloop, observer, mode);
    
    CFRelease(observer);
}

@end
