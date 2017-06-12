//
//  NSObject+Theme.h
//  WYLTheme
//
//  Created by wyl on 2017/6/12.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYLThemeManager.h"

@interface NSObject (Theme)

@property (nonatomic, strong, readonly) WYLThemeManager *wylThemeManager;

@end
