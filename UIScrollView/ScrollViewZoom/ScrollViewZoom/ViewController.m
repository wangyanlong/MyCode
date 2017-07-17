//
//  ViewController.m
//  ScrollViewZoom
//
//  Created by wyl on 2017/7/17.
//  Copyright © 2017年 wyl. All rights reserved.
//
#import "MyScrollView.h"
#import "ViewController.h"


@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *sc1;
@property (nonatomic, strong)UIView *contentView;
    
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sc1 = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.sc1.delegate = self;
    self.sc1.contentSize = CGSizeMake(self.view.frame.size.width * 10,self.view.frame.size.height);
    self.sc1.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
    self.sc1.pagingEnabled = YES;
    self.sc1.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:self.sc1];
    
    for (int i = 0; i < 10; i++) {
        
        MyScrollView *sc = [[MyScrollView alloc]initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
        sc.delegate = self;
        sc.maximumZoomScale = 1.4;
        sc.minimumZoomScale = 1.0f;

        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i+1]];
        imageView.tag = 100;
        [sc addSubview:imageView];
        
        [self.sc1 addSubview:sc];
    }
    
}
    
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
    {
    
    if ([scrollView isKindOfClass:[MyScrollView class]]) {

        UIImageView *img = (UIImageView *)[scrollView viewWithTag:100];
        return img;
    }
    
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view{

}
    
    
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
