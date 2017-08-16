//
//  SubClass.m
//  RuntimeDemo
//
//  Created by 王老师 on 2017/1/12.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "SubClass.h"

@interface SubClass (){
    NSArray *three;
}

@property (nonatomic, strong)NSDictionary *four;

- (void)method2;
+ (void)method4;

@end

@implementation SubClass

- (void)method1{
    NSLog(@"method1");
}

- (void)method2{
    NSLog(@"method2");
}

+ (void)method3{
    NSLog(@"method3");
}

+ (void)method4{
    NSLog(@"method4");
}

@end
