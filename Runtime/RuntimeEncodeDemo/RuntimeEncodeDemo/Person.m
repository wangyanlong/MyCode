//
//  Person.m
//  RuntimeEncodeDemo
//
//  Created by 王老师 on 2017/2/5.
//  Copyright © 2017年 wyl. All rights reserved.
//
#import <objc/runtime.h>
#import "Person.h"

@implementation Person

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        
        //1.获得person的成员变量
        //2.遍历成员变量
        //3.设置value
        
        unsigned int count = 0;
        
        Ivar *ivars = class_copyIvarList([self class], &count);
        
        for (int i = 0; i < count; i++) {
        
            Ivar ivar = ivars[i];
            
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];

            id value = [aDecoder decodeObjectForKey:key];
            
            [self setValue:value forKey:key];
            
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    //1.获得person的成员变量
    //2.遍历成员变量
    //3.encode相应的value
    
    unsigned int count = 0;
    
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        
        Ivar ivar = ivars[i];
        
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        id value = [self valueForKey:key];
        
        [aCoder encodeObject:value forKey:key];
        
    }
}

@end
