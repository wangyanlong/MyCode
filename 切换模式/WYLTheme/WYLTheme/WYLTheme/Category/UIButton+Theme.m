//
//  UIButton+Theme.m
//  WYLTheme
//
//  Created by wyl on 2017/6/12.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "UIButton+Theme.h"

@interface UIButton ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *pickers;

@end

@implementation UIButton (Theme)

- (void)wyl_setTitleColorPicker:(WYLColorPicker)picker forState:(UIControlState)state {
    
    [self setTitleColor:picker([WYLThemeManager shareManager].themeVersion) forState:state];
    NSString *key = [NSString stringWithFormat:@"%@", @(state)];
    NSMutableDictionary *dictionary = [self.pickers valueForKey:key];
    if (!dictionary) {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    [dictionary setValue:[picker copy] forKey:NSStringFromSelector(@selector(setTitleColor:forState:))];
    
    [self.pickers setValue:dictionary forKey:key];
}

- (void)night_updateColor {
    
    [self.pickers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary<NSString *, WYLColorPicker> *dictionary = (NSDictionary *)obj;
            [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selector, WYLColorPicker  _Nonnull picker, BOOL * _Nonnull stop) {
                UIControlState state = [key integerValue];
                [UIView animateWithDuration:0.4
                                 animations:^{
                                     if ([selector isEqualToString:NSStringFromSelector(@selector(setTitleColor:forState:))]) {
                                         UIColor *resultColor = picker([WYLThemeManager shareManager].themeVersion);
                                         [self setTitleColor:resultColor forState:state];
                                     }
                                 }];
            }];
        } else {
            SEL sel = NSSelectorFromString(key);
            WYLColorPicker picker = (WYLColorPicker)obj;
            UIColor *resultColor = picker([WYLThemeManager shareManager].themeVersion);
            [UIView animateWithDuration:0.4
                             animations:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                                 [self performSelector:sel withObject:resultColor];
#pragma clang diagnostic pop
                             }];
            
        }
    }];
}
@end
