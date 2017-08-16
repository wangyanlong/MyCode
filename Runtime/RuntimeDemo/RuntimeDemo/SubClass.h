//
//  SubClass.h
//  RuntimeDemo
//
//  Created by 王老师 on 2017/1/12.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SubClassProtocol <NSObject>

- (void)method5;

@end

@interface SubClass : NSObject<SubClassProtocol>{
    NSInteger one;
}

@property (nonatomic, strong) NSString  *two;

- (void)method1;
+ (void)method3;

@end
