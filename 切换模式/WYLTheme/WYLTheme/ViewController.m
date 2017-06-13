//
//  ViewController.m
//  WYLTheme
//
//  Created by wyl on 2017/6/9.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+Theme.h"
#import "WYLThemeManager.h"
#import "WYLColorTable.h"
#import "WYLColor.h"

@interface ViewController ()

@property (nonatomic, strong)UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setTitle:@"测试切换模式" forState:UIControlStateNormal];
    self.btn.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
    self.btn.wyl_titleColorPicker = WYLColorPickerWithKey(TINT);
    [self.btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.btn.frame = CGRectMake(50, 100, 300, 100);
    [self.view addSubview:self.btn];
    
}

- (void)click:(UIButton *)sender{
    
    self.btn.wyl_titleColorPicker = WYLColorPickerWithKey(BG);

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
