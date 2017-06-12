//
//  WYLDeallocBlockExecutor.h
//  WYLTheme
//
//  Created by wyl on 2017/6/13.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYLDeallocBlockExecutor : NSObject

+ (instancetype)executorWithDeallocBlock:(void (^)())deallocBlock;

@property (nonatomic, copy) void (^deallocBlock)();

@end
