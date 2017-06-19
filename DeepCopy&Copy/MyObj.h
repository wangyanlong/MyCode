//
//  MyObj.h
//  DeepCopy&Copy
//
//  Created by 王颜龙 on 13-12-24.
//  Copyright (c) 2013年 longyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyObj : NSObject<NSCopying,NSMutableCopying>
{
    NSMutableString *name;
    NSString *imutableStr;
    int age;
}

@property (nonatomic, retain) NSMutableString *name;
@property (nonatomic, retain) NSString *imutableStr;
@property (nonatomic) int age;

@end
