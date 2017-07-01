//
//  LockObj.m
//  LockDemo
//
//  Created by 王老师 on 2016/12/17.
//  Copyright © 2016年 wyl. All rights reserved.
//

#import "LockObj.h"

@implementation LockObj

- (void)method1{
    NSLog(@"%@--%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}

- (void)method2{
    NSLog(@"%@--%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}

@end
