//
//  ViewController.m
//  ScrollVIewZoom&View
//
//  Created by wyl on 2017/8/14.
//  Copyright © 2017年 wyl. All rights reserved.
//
#import "MyScrollView.h"
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) MyScrollView    *sv;

@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.sv = [[MyScrollView alloc] initWithFrame:self.view.bounds];
    self.sv.showsVerticalScrollIndicator = YES;
    self.sv.showsHorizontalScrollIndicator = YES;
    self.sv.contentSize = CGSizeMake(self.view.frame.size.width, 2000);
    self.sv.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
    [self.view addSubview:self.sv];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
    [self.view addSubview:btn];

}

- (void)add:(UIButton *)btn{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    view.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
    [self.sv.contentView addSubview:view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
