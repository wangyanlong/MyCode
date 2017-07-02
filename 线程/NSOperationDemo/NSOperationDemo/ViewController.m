//
//  ViewController.m
//  NSOperationDemo
//
//  Created by 王老师 on 2016/12/13.
//  Copyright © 2016年 wyl. All rights reserved.
//
#import "TestOperation.h"
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong)NSOperationQueue *globalQueue;

@end

@implementation ViewController

- (void)invocationOperation {
  
    NSInvocationOperation *op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(run) object:nil];
    
    op.completionBlock = ^(void){
        NSLog(@"over");
        NSLog(@"%@",[NSThread currentThread]);
    };
    
    [op start];
}

- (void)blockOperation {
    //addExecutionBlock可以为operation添加额外的操作,当任务等于1的时候,是在主线程上执行,当任务数量大于1的时候,才会有可能开启异步去执行.
      NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"no.1 --- %@",[NSThread currentThread]);
    }];
    
    for (int i = 2; i < 10; i++) {
        [op addExecutionBlock:^{
            NSLog(@"no.%d---%@",i,[NSThread currentThread]);
        }];
    }
    
    [op start];
}

- (void)queue {
  NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount = 1;//1:为串行队列 如果是n,那就是以n为并发的最大值,如果是-1的话,那么系统设定并发最大值
    
    //只要放在queue里面的操作,全部是在异步执行,最合理的操作方式
    //NSOperation,NSBlockOperation,NSInvocationOperation
    for (int i = 0; i < 5; i++) {
        TestOperation *op = [[TestOperation alloc]init];
        
        [queue addOperation:op];
    }
    
    [queue addOperationWithBlock:^{
        NSLog(@"block %@",[NSThread currentThread]);
    }];
}

- (void)queuePriority {
    //[self queue];
    
      NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount = 1;
    
    for (NSInteger i = 0; i < 50; i++) {
        
        TestOperation *op = [[TestOperation alloc]init];
        op.i = i;
        
        if (i < 10 && i >= 0) {
            op.queuePriority = NSOperationQueuePriorityVeryLow;
        }else if (i < 20 && i >= 10){
            op.queuePriority = NSOperationQueuePriorityLow;
        }else if (i < 30 && i >= 20){
            op.queuePriority = NSOperationQueuePriorityNormal;
        }else if (i < 40 && i >= 30){
            op.queuePriority = NSOperationQueuePriorityHigh;
        }else if (i < 50 && i >= 40){
            op.queuePriority = NSOperationQueuePriorityVeryHigh;
        }
        
        //op.threadPriority = 1.0f;//0-1之间
        
        [queue addOperation:op];
    }
}

- (void)dependency {
//    a->operation -> b->operation
    
      NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount = 1;
    
    TestOperation *op1 = [[TestOperation alloc]init];
    op1.i = 1;

    TestOperation *op2 = [[TestOperation alloc]init];
    op2.i = 2;
    
//    op2.queuePriority = NSOperationQueuePriorityVeryHigh;
//    op1.queuePriority = NSOperationQueuePriorityVeryLow;

    [op1 addDependency:op2];
    [op1 removeDependency:op2];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
}

- (void)viewDidLoad {

    [super viewDidLoad];

    self.globalQueue = [[NSOperationQueue alloc]init];
    self.globalQueue.maxConcurrentOperationCount = 1;
    
    for (int i = 0; i < 50; i++) {
        TestOperation *op1 = [[TestOperation alloc]init];
        op1.i = i;
        [self.globalQueue addOperation:op1];
    }
}

- (void)run{
    NSLog(@"%@",[NSThread currentThread]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//取消所有的操作
- (IBAction)cancel:(id)sender {
    //取消操作是等待当前operation任务完成后,才会执行取消操作
    [self.globalQueue cancelAllOperations];
}

//恢复队列操作
- (IBAction)recovery:(id)sender {
    
    if (self.globalQueue.operationCount == 0) {
        NSLog(@"已经没有任务了");
    }
    
    [self.globalQueue setSuspended:NO];
}

//暂停队列操作
- (IBAction)suspended:(id)sender {
    //暂停操作是等待当前operation任务完成后,才会执行暂停操作
    [self.globalQueue setSuspended:YES];
}

@end
