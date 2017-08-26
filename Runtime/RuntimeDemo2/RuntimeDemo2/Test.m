//
//  Test.m
//  RuntimeDemo2
//
//  Created by 王老师 on 2017/1/29.
//  Copyright © 2017年 wyl. All rights reserved.
//
#import <objc/runtime.h>
#import "Test.h"
#import "Test2.h"

@interface Test ()

@property (nonatomic, strong)Test2 *t;

@end

@implementation Test

void handleMethod(id self,SEL _cmd){
    NSLog(@"方法找到了");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _t = [[Test2 alloc]init];
    }
    return self;
}

//重定向方法
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    
    NSString *selStr = NSStringFromSelector(sel);
    
    if ([selStr isEqualToString:@"method1"]) {
        class_addMethod(self.class, @selector(method1), (IMP)handleMethod, "@:");
    }
    
    return [super resolveInstanceMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector{
    
    NSString *str = NSStringFromSelector(aSelector);
    
    if ([str isEqualToString:@"method2"]) {
        return _t;
    }
    
    return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    
    NSMethodSignature *sig = [super methodSignatureForSelector:aSelector];
    
    if (!sig) {
        if ([Test2 instancesRespondToSelector:aSelector]) {
            sig = [Test2 instanceMethodSignatureForSelector:aSelector];
        }
    }
    
    return sig;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    
    if ([Test2 instancesRespondToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_t];
    }
    
}

@end
