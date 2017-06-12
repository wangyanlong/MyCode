//
//  WYLColor.h
//  WYLTheme
//
//  Created by wyl on 2017/6/12.
//  Copyright © 2017年 wyl. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NSString WYLThemeVersion;//定义一个别名

typedef UIColor *(^WYLColorPicker)(WYLThemeVersion *themeVersion);

@interface WYLColor : NSObject

@end
