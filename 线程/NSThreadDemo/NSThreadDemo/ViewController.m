//
//  ViewController.m
//  NSThreadDemo
//
//  Created by 王老师 on 2016/11/30.
//  Copyright © 2016年 wyl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    //NSObject 分类
    [self performSelectorInBackground:@selector(downloadImage) withObject:nil];
    
    //NSThread类方法
//    [NSThread detachNewThreadWithBlock:^{
//        [self downloadImage];
//    }];
//    [NSThread detachNewThreadSelector:@selector(downloadImage) toTarget:self withObject:nil];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, 300, 300)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tag = 10000;
    [self.view addSubview:imageView];

    //NSThread对象方法
//    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(downloadImage) object:nil];
//    [thread start];
    
}

- (void)downloadImage{
    
    NSURL *url = [NSURL URLWithString:@"http://photocdn.sohu.com/20161130/Img474494782.jpg"];
    
    //睡3秒
    [NSThread sleepForTimeInterval:3.0f];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    //是否在主线程
    NSLog(@"1---%d",[NSThread isMainThread]);
    
    UIImage *img = [UIImage imageWithData:data];
    
    [self performSelectorOnMainThread:@selector(updateImg:) withObject:img waitUntilDone:YES];
}

- (void)updateImg:(UIImage *)img{

    UIImageView *imageView = [self.view viewWithTag:10000];
    imageView.image = img;

    //是否在主线程
    NSLog(@"2---%d",[NSThread isMainThread]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
