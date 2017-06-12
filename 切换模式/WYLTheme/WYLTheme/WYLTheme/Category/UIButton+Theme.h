//
//  UIButton+Theme.h
//  WYLTheme
//
//  Created by wyl on 2017/6/12.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYLThemeManager.h"
#import <objc/runtime.h>

@interface UIButton (Theme)

@property (nonatomic, copy, setter = wyl_setTitleColorPicker:) WYLColorPicker wyl_titleColorPicker;


@end
