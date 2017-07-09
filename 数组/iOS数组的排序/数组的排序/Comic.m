//
//  Comic.m
//  数组的排序
//
//  Created by 王老师 on 15/8/31.
//  Copyright (c) 2015年 wyl. All rights reserved.
//

#import "Comic.h"

@implementation Comic

+ (Comic *)comicWithId:(NSInteger)comicID withName:(NSString *)name{

    Comic *c = [[Comic alloc]init];
    c.comicID = comicID;
    c.name = name;
    
    return c;
    
}

//自定义排序方法
- (NSComparisonResult)compareComic:(Comic *)c{

    NSComparisonResult result = [[NSNumber numberWithInteger:self.comicID] compare:[NSNumber numberWithInteger:c.comicID]];
    
    if (result == NSOrderedSame) {
        result = [self.name compare:c.name];
    }
    
    return result;

}

@end
