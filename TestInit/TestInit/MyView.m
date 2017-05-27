//
//  MyView.m
//  TestInit
//
//  Created by wyl on 2017/5/27.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "MyView.h"

@implementation MyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"%@--%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"%@--%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
