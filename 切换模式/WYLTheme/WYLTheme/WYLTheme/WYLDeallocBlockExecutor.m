//
//  WYLDeallocBlockExecutor.m
//  WYLTheme
//
//  Created by wyl on 2017/6/13.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "WYLDeallocBlockExecutor.h"

@implementation WYLDeallocBlockExecutor

+ (instancetype)executorWithDeallocBlock:(void (^)())deallocBlock {
    WYLDeallocBlockExecutor *o = [WYLDeallocBlockExecutor new];
    o.deallocBlock = deallocBlock;
    return o;
}

- (void)dealloc {
    
    if (self.deallocBlock) {
        self.deallocBlock();
        self.deallocBlock = nil;
    }
}

@end
