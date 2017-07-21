//
//  ViewController.m
//  KVCDemo
//
//  Created by 王老师 on 2017/3/28.
//  Copyright © 2017年 wyl. All rights reserved.
//
#import "MyObject.h"
#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    MyObject *m = [[MyObject alloc]init];
    [m setValue:@"134" forKey:@"name"];
    NSLog(@"%@",[m valueForKey:@"name"]);
    
    unsigned int count = 0;
    
    Class cls = self.textField.class;
    
    Ivar *ivars = class_copyIvarList(cls, &count);
    
    for (int i = 0; i < count; i++) {
        
        Ivar ivar = ivars[i];
        
        NSLog(@"%s",ivar_getName(ivar));
        
    }
    
    free(ivars);
    
    [self.textField setValue:[UIColor redColor] forKeyPath:@"placeholderLabel.textColor"];

    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (int i = 1; i <=10; i++) {
        MyObject *mo = [[MyObject alloc]init];
        mo.price = i;
        [arr addObject:mo];
    }
    
    for (int i = 5; i <=15; i++) {
        MyObject *mo = [[MyObject alloc]init];
        mo.price = i;
        [arr addObject:mo];
    }
    
    NSNumber *sum = [arr valueForKeyPath:@"@sum.price"];
    NSLog(@"%@",sum);
    NSNumber *max = [arr valueForKeyPath:@"@max.price"];
    NSLog(@"%@",max);
    
    NSArray *array = [arr valueForKeyPath:@"@distinctUnionOfObjects.price"];
    NSLog(@"%@--%ld",array,array.count);
    NSArray *array2 = [arr valueForKeyPath:@"@unionOfObjects.price"];
    NSLog(@"%@--%ld",array2,array2.count);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
