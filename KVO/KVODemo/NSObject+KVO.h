//
//  NSObject+KVO.h
//  KVODemo
//
//  Created by 王老师 on 2017/2/7.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^studyKvoBlock)(id observer,NSString *key,id oldValue,id newValue);

@interface NSObject (KVO)

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath withBackBlock:(studyKvoBlock)block;

@end
