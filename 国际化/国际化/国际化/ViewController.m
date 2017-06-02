//
//  ViewController.m
//  国际化
//
//  Created by wyl on 2017/6/2.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

//1.command+n 选择string文件生成Localizable.strings文件
//2.project中language选择添加的语言
//3.选择Localizable.strings里的Localizaion添加语言
//4.注意格式"labelText" = "中文"; 要加";"号
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    label.text = NSLocalizedString(@"labelText", nil);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
