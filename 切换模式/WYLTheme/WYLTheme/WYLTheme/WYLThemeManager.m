//
//  WYLThemeManager.m
//  WYLTheme
//
//  Created by wyl on 2017/6/12.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "WYLThemeManager.h"

NSString * const WYLThemeVersionNormal = @"NORMAL";
NSString * const WYLThemeVersionNight = @"NIGHT";

NSString * const WYLVersionCurrentThemeVersionKey = @"1";

@implementation WYLThemeManager

+ (WYLThemeManager *)shareManager{
    
    static dispatch_once_t onceToken;
    static WYLThemeManager *manager;

    dispatch_once(&onceToken, ^{
        manager = [[WYLThemeManager alloc] init];
        WYLThemeVersion *themeVersion = [[NSUserDefaults standardUserDefaults] valueForKey:WYLVersionCurrentThemeVersionKey];
        themeVersion = themeVersion ?: WYLThemeVersionNormal;
        manager.themeVersion = themeVersion;
    });
    
    return manager;
}

- (void)setThemeVersion:(WYLThemeVersion *)themeVersion {
    
    if ([_themeVersion isEqualToString:themeVersion]) {
        // if type does not change, don't execute code below to enhance performance.
        return;
    }
    _themeVersion = themeVersion;
    
    // Save current theme version to user default
    [[NSUserDefaults standardUserDefaults] setValue:themeVersion forKey:WYLVersionCurrentThemeVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WYLVersionThemeChangingNotificaiton
                                                        object:nil];
    
    if (self.shouldChangeStatusBar) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ([themeVersion isEqualToString:WYLThemeVersionNight]) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
#pragma clang diagnostic pop
    }
}

@end
