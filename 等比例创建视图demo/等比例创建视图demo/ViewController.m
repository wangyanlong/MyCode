//
//  ViewController.m
//  等比例创建视图demo
//
//  Created by 王颜龙 on 13-6-29.
//  Copyright (c) 2013年 longyan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	int totalNumber = 30;  //总共要创建的个数
    
    int buttonWidth = 30;    //按钮宽
    
    int buttonHeight = 30;    //按钮高
    
    int buttonRowPadding = 5;    //横向按钮间隔
    
    int buttonColumnPadding = 5;    //纵向按钮间隔
    
    int buttonStartX = 0;                //按钮组起始坐标x
    
    int buttonStartY = 0;                //按钮组起始坐标Y
    
    for (int i = 0; i < totalNumber; i ++)
    {
        
        CGRect buttonFrame = CGRectMake(buttonStartX + (buttonWidth + buttonRowPadding) * (i % 3), buttonStartY + (buttonHeight + buttonColumnPadding) * (i /3), buttonWidth, buttonHeight);  //button frame
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = buttonFrame;
        [self.view addSubview:btn];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
