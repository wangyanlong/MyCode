//
//  ViewController.m
//  scrollview_lianxi
//
//  Created by qianfeng on 13-1-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize myPage;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    myScrollView.contentSize=CGSizeMake(320*5, 460);
    myScrollView.pagingEnabled=YES;
    myScrollView.showsHorizontalScrollIndicator=NO;
    myScrollView.showsVerticalScrollIndicator=NO;
    myScrollView.delegate=self;
    for (int i=1; i<6; i++) {
        UIImageView * imageView0i=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 400)];
        imageView0i.image=[UIImage imageNamed:[NSString stringWithFormat:@"IMG_000%d.JPG",i]];
        imageView0i.contentMode=UIViewContentModeScaleAspectFit;
        UIScrollView *pinchViewi=[[UIScrollView alloc]initWithFrame:CGRectMake(0+(320*(i-1)), 0, 320, 400)];
        pinchViewi.delegate=self;
        pinchViewi.minimumZoomScale=0.5;
        pinchViewi.maximumZoomScale=2.5;
        pinchViewi.tag=i;
        [pinchViewi addSubview:imageView0i];
        [myScrollView addSubview:pinchViewi];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showScrollMe) userInfo:nil repeats:YES];
    [self.view addSubview:myScrollView];
    
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    myPage.currentPage=myScrollView.contentOffset.x/320;

}
//确定方大谁的视图
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView.tag) {
        UIView * oneView=[scrollView.subviews objectAtIndex:0];
        return oneView;
    }
    return nil;
}

//当放大和缩小完进行的操作
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if (scale<1.0) {
        [scrollView setZoomScale:1.0 animated:YES];
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    myPage.currentPage=scrollView.contentOffset.x/320;
    
    if (scrollView==myScrollView) {
        for (UIScrollView * pinchScroll in scrollView.subviews) {
            if ([pinchScroll isKindOfClass:[UIScrollView class]]) {
                pinchScroll.zoomScale=1.0;
            }
            
        }
    }


}
-(void)showScrollMe
{
    static int i;
    i++;
    if (i>4) {
        i=0;
    }
    CGRect rect=[[myScrollView.subviews objectAtIndex:i]frame];
    [myScrollView scrollRectToVisible:rect animated:YES];

}
- (void)viewDidUnload
{
    [self setMyPage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [myPage release];
    [super dealloc];
}
@end
