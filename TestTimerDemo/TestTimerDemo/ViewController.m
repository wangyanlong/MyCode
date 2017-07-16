//
//  ViewController.m
//  TestTimerDemo
//
//  Created by 王老师 on 16/1/31.
//  Copyright © 2016年 wyl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) CADisplayLink *displayLink;

// 没有指针,但是dispatch_source_t本身是个类,内部其实已经包含指针了
@property (nonatomic, strong) dispatch_source_t GCD_TIMER;

@end

@implementation ViewController

- (IBAction)stop:(id)sender {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)NSTimer_method {
    // Do any additional setup after loading the view, typically from a nib.
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
}

- (void)displaylink_method {
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerMethod)];
    self.displayLink.frameInterval = 60;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self displaylink_method];
    
    __block int num = 0;
    
    //1.获取队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 2. 创建定时器
    self.GCD_TIMER = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

    // 3. 设置启动时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW,(int64_t)(5.0 * NSEC_PER_SEC));
    
    // 4. 设置时间间隔
    uint64_t interval = (uint64_t)(3.0 * NSEC_PER_SEC);
    
    dispatch_source_set_timer(self.GCD_TIMER, start, interval, 0);
    
    // 5. 设置回调
    dispatch_source_set_event_handler(self.GCD_TIMER, ^{
       
        NSLog(@"%d",[NSThread isMainThread]);
        
        num ++;
        
        if (num == 5) {
            dispatch_cancel(self.GCD_TIMER);
            self.GCD_TIMER = nil;
        }
        
    });
    
    // 6. 启动
    dispatch_resume(self.GCD_TIMER);
    
}

- (void)timerMethod{
    
    NSLog(@"%d",[NSThread isMainThread]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
