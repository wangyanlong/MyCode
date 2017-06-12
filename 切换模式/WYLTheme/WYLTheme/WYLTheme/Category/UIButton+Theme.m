//
//  UIButton+Theme.m
//  WYLTheme
//
//  Created by wyl on 2017/6/12.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "UIButton+Theme.h"

@interface UIButton()

@property (nonatomic, strong) NSMutableDictionary<NSString *, WYLColorPicker> *pickers;

@end

@implementation UIButton (Theme)

- (WYLColorPicker)wyl_titleColorPicker {
    return objc_getAssociatedObject(self, @selector(wyl_titleColorPicker));
}

- (void)wyl_setTitleColorPicker:(WYLColorPicker)wyl_titleColorPicker{
    
    objc_setAssociatedObject(self, @selector(wyl_titleColorPicker), wyl_titleColorPicker, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setTitleColor:wyl_titleColorPicker([WYLThemeManager shareManager].themeVersion) forState:UIControlStateNormal];
    [self.pickers setValue:[wyl_titleColorPicker copy] forKey:@"setTitleColor:"];

}

@end
