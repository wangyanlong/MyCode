//
//  ViewController.m
//  KVODemo
//
//  Created by 王老师 on 2017/2/7.
//  Copyright © 2017年 wyl. All rights reserved.
//
#import "Person.h"
#import "ViewController.h"
#import "NSObject+KVO.h"
@interface ViewController ()

@property (nonatomic, strong) Person *person;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.person = [[Person alloc]init];
    self.person.name = @"wyl";
    [self.person addObserver:self forKeyPath:NSStringFromSelector(@selector(name)) withBackBlock:^(id observer, NSString *key, id oldValue, id newValue) {
        NSLog(@"%@,%@",oldValue,newValue);
    }];
    self.person.name = @"wyl1";

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
