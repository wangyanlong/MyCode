//
//  ViewController.m
//  LockDemo
//
//  Created by 王老师 on 2016/12/17.
//  Copyright © 2016年 wyl. All rights reserved.
//
#import <os/lock.h>
#import <libkern/OSAtomic.h>
#include "pthread.h"
#import "ViewController.h"
#import "LockObj.h"

@interface ViewController ()

//递归锁
@property (nonatomic, strong)NSRecursiveLock *theLock;

@end

@implementation ViewController

//最常用,好理解
- (void)nslock {
    // Do any additional setup after loading the view, typically from a nib.

      NSLock *lock = [[NSLock alloc]init];
    LockObj *obj = [[LockObj alloc]init];
    
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [lock lock];
        [obj method1];
        [lock unlock];
        
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        sleep(1);
        [lock lock];
        [obj method2];
        [lock unlock];
        
    });
    
    //线程3
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        sleep(2);
        [lock lock];
        [obj method1];
        [lock unlock];
        
    });
}

- (void)synchronized {
  LockObj *obj = [[LockObj alloc]init];
    
    //简洁,包含语句块内,可以设定锁对象,注意锁的对象
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        @synchronized (obj) {
            [obj method1];
        }
        
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized (obj) {
            [obj method2];
        }
    });
}

//C语言锁
- (void)pthread {
  LockObj *obj = [[LockObj alloc]init];
    
    __block pthread_mutex_t mutex;
    pthread_mutex_init(&mutex, NULL);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        pthread_mutex_lock(&mutex);
        [obj method1];
        pthread_mutex_unlock(&mutex);
        
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        sleep(1);
        pthread_mutex_lock(&mutex);
        [obj method2];
        pthread_mutex_unlock(&mutex);
        pthread_mutex_destroy(&mutex);
        
    });
}

//递归锁
- (void)recursiveLock {
  self.theLock = [[NSRecursiveLock alloc]init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self lockMethod:5];
    });
}

- (void)condition {
    //条件锁
    //1.在线程中设置解锁条件
    //2.在另一线程中,得到解锁条件,并接收上锁请求,上锁
    NSConditionLock *lock = [[NSConditionLock alloc]init];
    
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        for (int i = 0; i <= 2 ; i++){
            [lock lock];
            NSLog(@"%d",i);
            sleep(2);
            [lock unlockWithCondition:i];
        }
        
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [lock lockWhenCondition:2];
        NSLog(@"线程2");
        [lock unlock];
        
    });
}

- (void)spinlock {
  
    LockObj *obj = [[LockObj alloc]init];
    
    //较快,但不安全,会大量占用CPU
    OSSpinLock lock = OS_SPINLOCK_INIT;
    
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        OSSpinLockLock(&lock);
        [obj method1];
        OSSpinLockUnlock(&lock);
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        sleep(1);
        OSSpinLockLock(&lock);
        [obj method2];
        OSSpinLockUnlock(&lock);
        
    });
}

- (void)os_unfair_lock {
  
    LockObj *obj = [[LockObj alloc]init];

    __block os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;

    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        os_unfair_lock_lock(&lock);
        [obj method1];
        os_unfair_lock_unlock(&lock);
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        os_unfair_lock_lock(&lock);
        [obj method2];
        os_unfair_lock_unlock(&lock);
    });
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    NSInteger totle = INT16_MAX;
    double then,now;
    
    @autoreleasepool {
        
        NSLock *lock = [[NSLock alloc]init];
        then = CFAbsoluteTimeGetCurrent();
        for (NSInteger i = 0; i < totle; i++) {
            [lock lock];
            [lock unlock];
        }
        now = CFAbsoluteTimeGetCurrent();
        NSLog(@"NSLock %f",now-then);
        
        id obj = [[NSObject alloc]init];
        then = CFAbsoluteTimeGetCurrent();
        for (NSInteger i = 0; i < totle; i++) {
            @synchronized (obj) {
                
            }
        }
        now = CFAbsoluteTimeGetCurrent();
        NSLog(@"synchronized %f",now-then);
        
        dispatch_semaphore_t sem = dispatch_semaphore_create(1);
        then = CFAbsoluteTimeGetCurrent();
        for (NSInteger i = 0; i < totle; i++) {
            dispatch_semaphore_wait(sem, 1);
            dispatch_semaphore_signal(sem);
        }
        now = CFAbsoluteTimeGetCurrent();
        NSLog(@"dispatch_semaphore %f",now-then);
        
        pthread_mutex_t mutext = PTHREAD_MUTEX_INITIALIZER;
        then = CFAbsoluteTimeGetCurrent();
        for (NSInteger i = 0; i < totle; i++) {
            pthread_mutex_lock(&mutext);
            pthread_mutex_unlock(&mutext);
        }
        now = CFAbsoluteTimeGetCurrent();
        NSLog(@"pthread %f",now-then);
        
        os_unfair_lock unfair = OS_UNFAIR_LOCK_INIT;
        then = CFAbsoluteTimeGetCurrent();
        for (NSInteger i = 0; i < totle; i++) {
            os_unfair_lock_lock(&unfair);
            os_unfair_lock_unlock(&unfair);
        }
        now = CFAbsoluteTimeGetCurrent();
        NSLog(@"os_unfair_lock %f",now-then);
    }
    
    //1.dispatch_semaphore 2.os_unfair_lock 3.pthread 4.NSLock 5.synchronized
    //1.os_unfair_lock 2.dispatch_semaphore 3.pthread 4.NSLock 5.synchronized
    
}

- (void)lockMethod:(NSInteger)num{
    
    [self.theLock lock];
    if (num > 0) {
        sleep(3);
        NSLog(@"%ld",num);
        [self lockMethod:num - 1];
    }
    [self.theLock unlock];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
