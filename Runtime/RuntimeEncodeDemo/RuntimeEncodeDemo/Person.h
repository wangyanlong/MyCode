//
//  Person.h
//  RuntimeEncodeDemo
//
//  Created by 王老师 on 2017/2/5.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject<NSCoding>

@property (nonatomic, strong) NSString  *name;
@property (nonatomic, assign) int       age;

@end
