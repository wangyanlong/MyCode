//
//  ViewController.m
//  Runloop与timer
//
//  Created by 王老师 on 16/7/23.
//  Copyright © 2016年 wyl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong)NSTimer *timer;

@end

@implementation ViewController

static int i = 0;

- (void)test{
    
    NSLog(@"%d",arc4random()%100);
    
    i++;
    
    if (i > 5) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /**
     *  主线程runloop的会默认开启,子线程的runloop默认不开启
     *  如果不停掉runloop,会阻塞,停掉了timer,等于runloop里没有任何东西,runloop会停止,线程也会结束
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        @autoreleasepool {
            
//            self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(test) userInfo:nil repeats:YES];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(test) userInfo:nil repeats:YES];

//            [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            [[NSRunLoop currentRunLoop]run];
            
            NSLog(@"-------------");
        
        }
        
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
