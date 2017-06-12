//
//  WYLThemeManager.h
//  WYLTheme
//
//  Created by wyl on 2017/6/12.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYLColor.h"

typedef NSString WYLThemeVersion;

extern WYLThemeVersion * const DKThemeVersionNight;
extern NSString * const WYLVersionThemeChangingNotificaiton;

@interface WYLThemeManager : NSObject

@property (nonatomic, strong) WYLThemeVersion *themeVersion;
@property (nonatomic, assign, getter=shouldChangeStatusBar) BOOL changeStatusBar;

+ (WYLThemeManager *)shareManager;

@end
