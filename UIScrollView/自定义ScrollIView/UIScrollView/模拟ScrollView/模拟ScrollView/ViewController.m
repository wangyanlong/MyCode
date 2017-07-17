//
//  ViewController.m
//  模拟ScrollView
//
//  Created by 王老师 on 2017/3/30.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "ViewController.h"
#import "CustomScrollView.h"
#import "CustomView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
     UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 200, 100)];
     view1.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
     
     //子view的frame是相对于父类的bounds确定的,改变bounds,view不会变frame,子view会改变
     CGRect bounds = view1.bounds;
     bounds.origin.x -= 50;
     view1.bounds = bounds;
     
     [self.view addSubview:view1];
     
     UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(30, 30, 100, 50)];
     view2.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
     [view1 addSubview:view2];

     */

//    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
//    scrollView.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
////    scrollView.customContentSize = CGSizeMake(2*self.view.frame.size.width, 200);
//    scrollView.contentSize = CGSizeMake(2*self.view.frame.size.width, 200);
//    [self.view addSubview:scrollView];
//    
//    for (int i = 0; i < 5; i++) {
//        CustomView *view = [[CustomView alloc]initWithFrame:CGRectMake(120*i+50.0f, 50.0f, 100.0f, 100.0f)];
//        view.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
//        [scrollView addSubview:view];
//    }
    
    CustomScrollView *sv = [[CustomScrollView alloc] initWithFrame:self.view.bounds];
    sv.customContentSize = CGSizeMake(self.view.frame.size.width * 10, self.view.frame.size.height);
    sv.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
    [self.view addSubview:sv];
    
    for (int i = 0; i < 5; i++) {
        CustomView *view = [[CustomView alloc]initWithFrame:CGRectMake(120*i+50.0f, 50.0f, 100.0f, 100.0f)];
        view.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
        [sv addSubview:view];
    }


}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
