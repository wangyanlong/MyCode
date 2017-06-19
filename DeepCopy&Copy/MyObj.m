//
//  MyObj.m
//  DeepCopy&Copy
//
//  Created by 王颜龙 on 13-12-24.
//  Copyright (c) 2013年 longyan. All rights reserved.
//

#import "MyObj.h"

@implementation MyObj
@synthesize name;
@synthesize age;
@synthesize imutableStr;
- (id)init
{
    if (self = [super init])
    {
        self.name = [[NSMutableString alloc]init];
        self.imutableStr = [[NSString alloc]init];
        age = -1;
    }
    return self;
}
- (void)dealloc
{
    [name release];
    [imutableStr release];
    [super dealloc];
}
- (id)copyWithZone:(NSZone *)zone
{
    MyObj *copy = [[[self class] allocWithZone:zone] init];
    copy->name = [name copy];
    copy->imutableStr = [imutableStr copy];
    //       copy->name = [name copyWithZone:zone];;
    //       copy->imutableStr = [name copyWithZone:zone];//
    copy->age = 12;
    return copy;
}
- (id)mutableCopyWithZone:(NSZone *)zone
{
    MyObj *copy = NSCopyObject(self, 0, zone);
    copy->name = [self.name mutableCopy];
    copy->age = 22;
    return copy;
}

@end
