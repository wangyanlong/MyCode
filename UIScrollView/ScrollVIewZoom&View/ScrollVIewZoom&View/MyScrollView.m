//
//  MyScrollView.m
//  ScrollVIewZoom&View
//
//  Created by wyl on 2017/8/14.
//  Copyright © 2017年 wyl. All rights reserved.
//

/*
缩放相关的话,contentOffSet.y会跟着缩放改变,但是add的view的frame不需要跟着缩放的尺寸改变,按照原有的frame添加,会自动缩放到指定缩放view的尺寸
 */

#import "MyScrollView.h"

@interface MyScrollView ()<UIScrollViewDelegate>

@end

@implementation MyScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 2000)];
        self.contentView.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
        [self addSubview:self.contentView];
        
        self.maximumZoomScale = 1.4f;
        self.minimumZoomScale = 1.0f;
        
        self.delegate = self;
        
    }
    
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%@",NSStringFromCGRect(self.contentView.frame));
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.contentView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    NSLog(@"%@",NSStringFromCGSize(self.contentView.frame.size));

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
