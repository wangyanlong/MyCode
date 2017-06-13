//
//  WYLColorTable.m
//  WYLTheme
//
//  Created by wyl on 2017/6/13.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "WYLColorTable.h"

@interface WYLColorTable ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, UIColor *> *> *table;

@property (nonatomic, strong, readwrite) NSArray<WYLThemeVersion *> *themes;

@end

@implementation WYLColorTable

UIColor *DKColorFromRGB(NSUInteger hex) {
    return [UIColor colorWithRed:((CGFloat)((hex >> 16) & 0xFF)/255.0) green:((CGFloat)((hex >> 8) & 0xFF)/255.0) blue:((CGFloat)(hex & 0xFF)/255.0) alpha:1.0];
}

UIColor *DKColorFromRGBA(NSUInteger hex) {
    return [UIColor colorWithRed:((CGFloat)((hex >> 24) & 0xFF)/255.0) green:((CGFloat)((hex >> 16) & 0xFF)/255.0) blue:((CGFloat)((hex >> 8) & 0xFF)/255.0) alpha:((CGFloat)(hex & 0xFF)/255.0)];
}

+ (instancetype)shareColorTable{

    static dispatch_once_t onceToken;
    static WYLColorTable *shareColorTable = nil;
    
    dispatch_once(&onceToken, ^{
        
        shareColorTable = [[WYLColorTable alloc] init];
        shareColorTable.themes = @[@"NORMAL",@"NIGHT",@"RED"];
        shareColorTable.file = @"DKColorTable.plist";
        
    });

    return shareColorTable;

}

- (NSMutableDictionary *)table {
    if (!_table) {
        _table = [[NSMutableDictionary alloc] init];
    }
    return _table;
}

- (void)reloadColorTable {
    // Clear previos color table
    self.table = nil;
    
    NSString *pathExtension = self.file.pathExtension;
    
    if ([pathExtension isEqualToString:@"plist"]) {
        [self loadFromPlist];
    } else if ([pathExtension isEqualToString:@"txt"] || [pathExtension isEqualToString:@""]) {
        //[self loadFromPlainText];
    } else {
        NSAssert(NO, @"Unknown path extension %@ for file %@", pathExtension, self.file);
    }
}

- (void)loadFromPlist {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:self.file.stringByDeletingPathExtension ofType:self.file.pathExtension];
    NSDictionary *infos = [NSDictionary dictionaryWithContentsOfFile:filepath];
    NSSet *configThemes = [NSSet setWithArray:@[@"NORMAL",@"NIGHT",@"RED"]];
    for (NSString *key in infos) {
        NSMutableDictionary *themeToColorDictionary = [infos[key] mutableCopy];
        NSSet *themesInFile = [NSSet setWithArray:themeToColorDictionary.allKeys];
        NSAssert([themesInFile isEqualToSet:configThemes], @"Invalid theme to themes to color dictionary %@ for key %@", themeToColorDictionary, key);
        [themeToColorDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            UIColor *color = [self colorFromString:obj];
            themeToColorDictionary[key] = color;
        }];
        [self.table setValue:themeToColorDictionary forKey:key];
    }
}

- (UIColor *)colorFromString:(NSString *)hexStr {
    hexStr = [hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([hexStr hasPrefix:@"0x"]) {
        hexStr = [hexStr substringFromIndex:2];
    }
    if([hexStr hasPrefix:@"#"]) {
        hexStr = [hexStr substringFromIndex:1];
    }
    
    NSUInteger hex = [self intFromHexString:hexStr];
    if(hexStr.length > 6) {
        return DKColorFromRGBA(hex);
    }
    
    return DKColorFromRGB(hex);
}

- (NSUInteger)intFromHexString:(NSString *)hexStr {
    unsigned int hexInt = 0;
    
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}

- (void)setFile:(NSString *)file {
    _file = file;
    [self reloadColorTable];
}

- (WYLColorPicker)pickerWithKey:(NSString *)key {
    NSParameterAssert(key);
    
    NSDictionary *themeToColorDictionary = [self.table valueForKey:key];
    WYLColorPicker picker = ^(WYLThemeVersion *themeVersion) {
        return [themeToColorDictionary valueForKey:themeVersion];
    };
    return picker;
    
}

@end
