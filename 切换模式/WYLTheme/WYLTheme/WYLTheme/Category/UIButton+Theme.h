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

- (void)wyl_setTitleColorPicker:(WYLColorPicker)picker forState:(UIControlState)state;


@end
