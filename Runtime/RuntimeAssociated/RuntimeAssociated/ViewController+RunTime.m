//
//  ViewController+RunTime.m
//  RuntimeAssociated
//
//  Created by 王老师 on 2017/1/26.
//  Copyright © 2017年 wyl. All rights reserved.
//
#import <objc/runtime.h>
#import "ViewController+RunTime.h"

static const char *key = "log";

@implementation ViewController (RunTime)

- (NSString *)log{
    return objc_getAssociatedObject(self, key);
}

- (void)setLog:(NSString *)log{
    objc_setAssociatedObject(self, key, log, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)logString{
    
    NSLog(@"%@",self.log);
    
}

@end
