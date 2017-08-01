//
//  ViewController.m
//  Runloop与Observer
//
//  Created by 王老师 on 16/7/23.
//  Copyright © 2016年 wyl. All rights reserved.
//

#import "ViewController.h"
#import "MainRunloopObserver.h"
#import "ThreadRunloopObserver.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) ThreadRunloopObserver *thread;
@property (nonatomic, strong) UITableView *exampleTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"111" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(t) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(10, 10, 50, 50);
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
    
    self.exampleTableView = [UITableView new];
    self.exampleTableView.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100);
    self.exampleTableView.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
    self.exampleTableView.delegate = self;
    self.exampleTableView.dataSource = self;
    [self.view addSubview:self.exampleTableView];
    
    [self.exampleTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
//    MainRunloopObserver *m = [[MainRunloopObserver alloc]init];
    
    ThreadRunloopObserver *thread2 = [[ThreadRunloopObserver alloc]init];
    [thread2 start];
    
//    CFRunLoopRef runloop = CFRunLoopGetCurrent();
//    
//    CFStringRef runLoopMode = kCFRunLoopDefaultMode;
//    
//    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(NULL, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
//        
//        switch (activity) {
//            case kCFRunLoopEntry:
//                NSLog(@"RunLoop 开始了");
//                break;
//            case kCFRunLoopBeforeTimers:
//                NSLog(@"RunLoop 准备处理定时器");
//                break;
//            case kCFRunLoopBeforeSources:
//                NSLog(@"RunLoop 准备处理输入源");
//                break;
//            case kCFRunLoopBeforeWaiting:
//                NSLog(@"RunLoop 进入睡眠");
//                NSLog(@"我想做点事儿");
//                break;
//            case kCFRunLoopAfterWaiting:
//                NSLog(@"RunLoop 被唤醒");
//                break;
//            case kCFRunLoopExit:
//                NSLog(@"RunLoop 退出");
//                break;
//            default:
//                break;
//        }
//
//        
//    });
//
//    CFRunLoopAddObserver(runloop, observer, runLoopMode);
}

- (void)t{
    
    NSLog(@"1234");
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
