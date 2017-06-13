//
//  WYLColorTable.h
//  WYLTheme
//
//  Created by wyl on 2017/6/13.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "WYLThemeManager.h"
#import <Foundation/Foundation.h>

#define WYLColorPickerWithKey(key) [[WYLColorTable shareColorTable] pickerWithKey:@#key]

@interface WYLColorTable : NSObject

@property (nonatomic, strong) NSString *file;

@property (nonatomic, strong, readonly) NSArray<WYLThemeVersion *> *themes;

+ (instancetype)shareColorTable;

- (WYLColorPicker)pickerWithKey:(NSString *)key;

@end
