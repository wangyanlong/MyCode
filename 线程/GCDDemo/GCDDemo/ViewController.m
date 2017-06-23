//
//  ViewController.m
//  GCDDemo
//
//  Created by 王老师 on 2016/12/8.
//  Copyright © 2016年 wyl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong)dispatch_source_t source;
@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation ViewController

#pragma mark - 同步/异步

- (void)async {
  dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@"%@",[NSThread currentThread]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
    
    dispatch_sync_f(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), nil, test);
}

#pragma mark - 队列

/**
 1.同步的串行队列
 2.异步的串行队列
 3.异步的并行队列
 4.自定义级别的队列
 5.根据任意级别设定队列级别
 6.取消队列任务
 */

//同步的串行队列
- (void)queue1 {
    
    dispatch_queue_t queue = dispatch_queue_create("wyl", DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i < 10 ; i++) {
        dispatch_sync(queue, ^{
            NSLog(@"%@---%d",[NSThread currentThread],i);
        });
    }
}

//异步的串行队列
- (void)queue2 {
    //[self async];
    
    dispatch_queue_t queue = dispatch_queue_create("wyl", DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i < 10 ; i++) {
        dispatch_async(queue, ^{
            NSLog(@"%@---%d",[NSThread currentThread],i);
        });
    }
}

//异步的并行队列
- (void)queue3 {
  dispatch_queue_t queue = dispatch_queue_create("wyl", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 10 ; i++) {
        dispatch_async(queue, ^{
            NSLog(@"%@---%d",[NSThread currentThread],i);
        });
    }
}

//自定义级别的队列
- (void)queue4 {
    /*
     #define DISPATCH_QUEUE_PRIORITY_HIGH 2
     #define DISPATCH_QUEUE_PRIORITY_DEFAULT 0
     #define DISPATCH_QUEUE_PRIORITY_LOW (-2)
     #define DISPATCH_QUEUE_PRIORITY_BACKGROUND
     
     QOS_CLASS_USER_INITIATED
     QOS_CLASS_DEFAULT
     QOS_CLASS_UTILITY
     QOS_CLASS_BACKGROUND
     */
    
    
      dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_DEFAULT, -1);
    
    dispatch_queue_t queue = dispatch_queue_create("wyl", attr);
    
    for (int i = 0; i < 10 ; i++) {
        dispatch_async(queue, ^{
            NSLog(@"%@---%d",[NSThread currentThread],i);
        });
    }
}

//根据任意级别设定队列级别
- (void)queue5 {
    dispatch_queue_t queue = dispatch_queue_create("wyl", NULL);
    dispatch_queue_t queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    
    dispatch_set_target_queue(queue,queue2);//设置queue的优先级和queue2的优先级一样
}

//取消队列任务
- (void)queue6 {
    
    dispatch_queue_t queue = dispatch_queue_create("wyl", NULL);
    
    dispatch_block_t first = dispatch_block_create(0, ^{
        NSLog(@"u17");
        [NSThread sleepForTimeInterval:3.0f];
        NSLog(@"u17--ok");
    });
    
    dispatch_block_t second = dispatch_block_create(0, ^{
        NSLog(@"cancel");
    });
    
    dispatch_async(queue, first);
    dispatch_async(queue, second);
    
    dispatch_block_cancel(second);
}

- (void)group {
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_group_t group = dispatch_group_create();
//
//    dispatch_group_async(group, queue, ^{
//        NSLog(@"%@",[NSThread currentThread]);
//    });
//    
//    dispatch_group_async(group, queue, ^{
//        NSLog(@"%@",[NSThread currentThread]);
//    });
//    
//    dispatch_group_async(group, queue, ^{
//        NSLog(@"%@",[NSThread currentThread]);
//    });
//    
//    dispatch_group_notify(group, queue, ^{
//        NSLog(@"已经执行完了");
//    });
    
      dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();

    for (int i = 0; i < 6; i++) {
        dispatch_group_enter(group);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"%@",[NSThread currentThread]);
            dispatch_group_leave(group);
        });
    }
    
    long result = dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    if (result == 0) {
        NSLog(@"已经结束了");
    }
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"已经执行完了");
    });
}

- (void)barrier {
  dispatch_queue_t queue = dispatch_queue_create("wyl", DISPATCH_QUEUE_CONCURRENT);
    
    void(^blk1_r)(void)=^{
        NSLog(@"读数据");
    };
    
    void(^blk2_r)(void)=^{
        NSLog(@"读数据");
    };
    
    void(^blk3_w)(void)=^{
        NSLog(@"写数据");
    };
    
    void(^blk4_r)(void)=^{
        NSLog(@"读数据");
    };

    dispatch_async(queue, blk1_r);
    dispatch_async(queue, blk2_r);
    //添加追加操作,会等待1,2执行结束,才会执行3的操作
    dispatch_barrier_async(queue, blk3_w);
    dispatch_async(queue, blk4_r);
}

- (void)semaphore1 {
    //停车场有10个车位
      __block int num = 10;

    _semaphore = dispatch_semaphore_create(num);
    
    for (int i = 1; i < 100; i++) {
        
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"消耗车位了,还有%d个车位,第%d次操作,%@",--num,i,[NSThread currentThread]);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
            if (num == 0) {
                NSLog(@"增加车位,还有%d",++num);
                dispatch_semaphore_signal(_semaphore);
            }
            
        });
    }
}

- (void)apply {
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(100, queue, ^(size_t i) {
        NSLog(@"global - %zu-%@",i,[NSThread currentThread]);
    });
    
    for (int i = 0; i < 10; i++) {
        NSLog(@"main - %d-%@",i,[NSThread currentThread]);
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //dispatch source 分派源
    _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    
    __block NSInteger i = 0;
    
    dispatch_source_set_event_handler(_source, ^{
       
        NSUInteger value = dispatch_source_get_data(_source);
        i += value;
        NSLog(@"进度%ld",i);
        
    });
    dispatch_resume(_source);
    
//    dispatch_source_merge_data(<#dispatch_source_t  _Nonnull source#>, <#unsigned long value#>)
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int ii = 0; ii < 100 ; ii++) {
        dispatch_async(queue, ^{
            dispatch_source_merge_data(_source, 1);
            usleep(20000);//0.02s
        });
    }
   
    
    
}

void test(){
    NSLog(@"%@",[NSThread currentThread]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
