//
//  ViewController+Swizzling.m
//  Swizzling
//
//  Created by 王老师 on 2017/2/1.
//  Copyright © 2017年 wyl. All rights reserved.
//
//#import <objc/runtime.h>
#import "ViewController+Swizzling.h"
#import "JRSwizzle.h"

@implementation ViewController (Swizzling)

+(void)load{
    
//    Method fromMethod = class_getInstanceMethod([self class], @selector(viewDidLoad));
//    Method toMethod = class_getInstanceMethod([self class], @selector(swizzlingViewDidLoad));
//
    
    [ViewController jr_swizzleMethod:@selector(viewDidLoad) withMethod:@selector(swizzlingViewDidLoad) error:nil];
    
//    //判断,如果self没有实现被交换的方法,会导致失败(如果父类有方法的话,会调用父类方法,也是达不到效果的)
//    //通过class_addMethod进行验证,如果self实现了这个方法,class_addMethod会返回NO
//    if (!class_addMethod([self class], @selector(swizzlingViewDidLoad), method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
//        method_exchangeImplementations(fromMethod, toMethod);
//    }
    
}

- (void)swizzlingViewDidLoad{

    NSLog(@"我们自己的方法");
    
    //这里调用的是viewDidLoad(因为已经交换了)
    [self swizzlingViewDidLoad];
    
}

@end
