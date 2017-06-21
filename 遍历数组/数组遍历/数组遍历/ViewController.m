//
//  ViewController.m
//  数组遍历
//
//  Created by 王老师 on 16/7/14.
//  Copyright © 2016年 wyl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    //结论:如果想遍历数组,同时代码健壮性强的话,enumerateObjects,forin,遍历数组同时操作数组的话,最好是用倒叙的方法
    
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
    [arr addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5"]];
    
    for (NSString *str in arr.reverseObjectEnumerator){
        
        
        if ([str isEqualToString:@"2"] || [str isEqualToString:@"3"]) {
            
            [arr removeObject:str];
        }

        
    }
    
//    for (NSInteger i = arr.count - 1; i >= 0; i--) {
//        NSLog(@"%ld",i);
//        
//        if (i < 3) {
//            
//            NSString *str = [arr objectAtIndex:i];
//            
//            [arr removeObject:str];
//        }
//
//    }
    
//    [arr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//       
//        if (idx < 3) {
//            
//            NSString *str = [arr objectAtIndex:idx];
//            
//            [arr removeObject:str];
//        }
//
//        
//    }];
    
//    for (NSInteger i = 0; i < arr.count; i++) {
//        
//        NSLog(@"%ld",i);
//        
//        if (i < 3) {
//            
//            NSString *str = [arr objectAtIndex:i];
//            
//            [arr removeObject:str];
//        }
//
//    }
    
//    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//       
//        if ([obj isEqualToString:@"2"] || [obj isEqualToString:@"3"]) {
//            [arr removeObject:obj];
//        }
//        
//    }];
    
//    for (NSString *str in arr) {
//        if ([str isEqualToString:@"1"]) {
//            [arr removeObject:str];
//        }
//    }
//    
//    NSInteger count = arr.count;
//    
//    for (NSInteger i = 0; i < count; i++) {
//        //adafdf
//    }
    
//    for (int i = 0; i < 5; i++) {
//        
//        NSString *str = [arr objectAtIndex:i];
//        if ([str isEqualToString:@"1"]) {
//            [arr removeObject:str];
//        }
//        
//    }
    
    NSLog(@"%@",arr);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
