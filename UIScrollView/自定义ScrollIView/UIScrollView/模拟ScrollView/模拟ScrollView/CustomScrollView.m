//
//  CustomScrollView.m
//  模拟ScrollView
//
//  Created by 王老师 on 2017/3/30.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "CustomScrollView.h"

@implementation CustomScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.customPanGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:self.customPanGesture];
    
    }
    
    return self;
}

- (void)setNeedsDisplay{
    [super setNeedsDisplay];
}

- (void)setNeedsLayout{
    [super setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)panAction:(UIPanGestureRecognizer *)gesture{
    
    CGPoint transitionPoint = [gesture translationInView:self];

    CGFloat tmpOffset = self.bounds.origin.x - transitionPoint.x;
    
    CGFloat minimumOffset = 0.f;
    CGFloat maximumOffset = self.customContentSize.width - self.frame.size.width;
    
    CGFloat actualOffset = fmax(minimumOffset, fmin(tmpOffset, maximumOffset));
    
//    self.bounds = ({
//        
//        CGRect bounds = self.bounds;
//        bounds.origin.x = actualOffset;
//        bounds;
//        
//    });
    
    CGRect bounds = self.bounds;
    bounds.origin.x = actualOffset;
    self.bounds = bounds;
    
    
    [gesture setTranslation:CGPointZero inView:self];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
