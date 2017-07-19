//
//  InvocationClass.m
//  NSInvocation与PerfromSelector
//
//  Created by 王老师 on 15/8/19.
//  Copyright (c) 2015年 wyl. All rights reserved.
//

#import "InvocationClass.h"

@implementation InvocationClass

- (NSString *)appendStringWithInvocationClass:(NSString *)str{

    return [NSString stringWithFormat:@"invocation --- %@",str];
    
}

@end
