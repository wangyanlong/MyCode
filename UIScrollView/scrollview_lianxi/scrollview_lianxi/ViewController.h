//
//  ViewController.h
//  scrollview_lianxi
//
//  Created by qianfeng on 13-1-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIScrollViewDelegate >
{
    UIScrollView * myScrollView;

}
@property (retain, nonatomic) IBOutlet UIPageControl *myPage;
@end
