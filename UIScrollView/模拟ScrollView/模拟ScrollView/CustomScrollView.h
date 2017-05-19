//
//  CustomScrollView.h
//  模拟ScrollView
//
//  Created by 王老师 on 2017/3/30.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomScrollView : UIView

@property (nonatomic, assign)CGSize customContentSize;
@property (nonatomic, strong)UIPanGestureRecognizer *customPanGesture;

@end
