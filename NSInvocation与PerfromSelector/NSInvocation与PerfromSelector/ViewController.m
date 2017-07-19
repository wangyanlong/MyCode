//
//  ViewController.m
//  NSInvocation与PerfromSelector
//
//  Created by 王老师 on 15/8/19.
//  Copyright (c) 2015年 wyl. All rights reserved.
//

#import "ViewController.h"
#import "InvocationClass.h"

#define kStr1 @"no.1"
#define kStr2 @"no.2"
#define kStr3 @"no.3"

@interface ViewController ()

@end

@implementation ViewController

- (NSString *)appendDict:(NSDictionary *)dict{

    return [NSString stringWithFormat:@"%@-%@-%@",[dict objectForKey:@"key1"],[dict objectForKey:@"key2"],[dict objectForKey:@"key3"]];

}

- (void)appendStr:(NSString *)str{
    NSLog(@"%@",str);
}

- (NSNumber *)appendStr1:(NSString *)str1 appendStr2:(NSString *)str2{
    NSLog(@"%@--%@",str1,str2);
    return [NSNumber numberWithInteger:10000];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    [self appendStr:kStr1];
    
    [self performSelector:@selector(appendStr:) withObject:kStr1];
    
    [self performSelector:@selector(appendStr:) withObject:kStr1 afterDelay:5.0f];
    
    [self performSelectorInBackground:@selector(appendStr:) withObject:kStr2];
    
    NSNumber *num = [self performSelector:@selector(appendStr1:appendStr2:) withObject:kStr1 withObject:kStr2];
    NSLog(@"%ld",[num integerValue]);
    
    NSDictionary *dict = @{@"key1":kStr1,@"key2":kStr2,@"key3":kStr3};
    NSString *str = [self performSelector:@selector(appendDict:) withObject:dict];
    NSLog(@"str=====%@",str);
    
    InvocationClass *ivc = [[InvocationClass alloc]init];
    
    //方法类签名,需要被调用消息所属InvocationClass,被调用的消息为appendStringWithInvocationClass:
    NSMethodSignature *sig = [[InvocationClass class] instanceMethodSignatureForSelector:@selector(appendStringWithInvocationClass:)];
    
    //根据方法签名创建一个NSInvocation
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:ivc];//0
    
    //设置被调用的消息
    [invocation setSelector:@selector(appendStringWithInvocationClass:)];//1
    
    NSString *string1 = kStr1;
    
    //参数从2开始
    [invocation setArgument:&string1 atIndex:2];
    
    [invocation retainArguments];
    
    //消息被调用
    [invocation invoke];
    
    NSString *result = nil;
    [invocation getReturnValue:&result];
    
    NSLog(@"%@",result);
}

- (IBAction)method:(UIButton *)sender {
    
    SEL orientationMethod = @selector(setOrientation:);
    
//    [[UIDevice currentDevice] performSelector:orientationMethod withObject:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight]];
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        
        NSMethodSignature *sig = [UIDevice instanceMethodSignatureForSelector:orientationMethod];
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        
        [invocation setTarget:[UIDevice currentDevice]];
        
        [invocation setSelector:orientationMethod];
        
        int val = UIInterfaceOrientationLandscapeRight;
        
        [invocation setArgument:&val atIndex:2];
        
        [invocation retainArguments];
        
        [invocation invoke];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
