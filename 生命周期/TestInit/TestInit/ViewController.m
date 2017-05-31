//
//  ViewController.m
//  TestInit
//
//  Created by wyl on 2017/5/27.
//  Copyright © 2017年 wyl. All rights reserved.
//
#import "MyView.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    MyView *myView = [[MyView alloc] initWithFrame:self.view.bounds];
//    myView.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
//    [self.view addSubview:myView];
    
    //由此可以得出结论,调用init方法会先调用initWithFrame
    MyView *myView2 = [[MyView alloc] init];
    myView2.frame = self.view.bounds;
    myView2.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
    [self.view addSubview:myView2];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
