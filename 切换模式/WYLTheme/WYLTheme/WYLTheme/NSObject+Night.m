//
//  NSObject+Night.m
//  DKNightVersion
//
//  Created by Draveness on 15/11/7.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import "NSObject+Night.h"
#import "NSObject+DeallocBlock.h"
#import <objc/runtime.h>
#import "WYLColor.h"

static void *WYLViewDeallocHelperKey;

@interface NSObject ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, WYLColorPicker> *pickers;

@end

@implementation NSObject (Night)

//一个对象，它注册了一个通知，ios9之前，如果我对象dealloc，不移除通知 ，observer野指针 ， 野指针内存 移除observer

- (NSMutableDictionary<NSString *, WYLColorPicker> *)pickers {
    NSMutableDictionary<NSString *, WYLColorPicker> *pickers = objc_getAssociatedObject(self, @selector(pickers));
    if (!pickers) {
        
        @autoreleasepool {
            // Need to removeObserver in dealloc
            
            //在dealloc里来移除通知
            if (objc_getAssociatedObject(self, &WYLViewDeallocHelperKey) == nil) {
                
                __unsafe_unretained typeof(self) weakSelf = self; // NOTE: need to be __unsafe_unretained because __weak var will be reset to nil in dealloc
                id deallocHelper = [self addDeallocBlock:^{
                    
                    [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
                }];
                objc_setAssociatedObject(self, &WYLViewDeallocHelperKey, deallocHelper, OBJC_ASSOCIATION_ASSIGN);
            }
        }

        pickers = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, @selector(pickers), pickers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:WYLVersionThemeChangingNotificaiton object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(night_updateColor) name:WYLVersionThemeChangingNotificaiton object:nil];
    }
    return pickers;
}

- (void)night_updateColor {
    [self.pickers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selector, WYLColorPicker  _Nonnull picker, BOOL * _Nonnull stop) {
        SEL sel = NSSelectorFromString(selector);
        id result = picker([WYLThemeManager shareManager].themeVersion);
        [UIView animateWithDuration:0.4
                         animations:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                             [self performSelector:sel withObject:result];
#pragma clang diagnostic pop
                         }];
    }];
}



@end
