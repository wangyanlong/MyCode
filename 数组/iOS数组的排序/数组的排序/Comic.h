//
//  Comic.h
//  数组的排序
//
//  Created by 王老师 on 15/8/31.
//  Copyright (c) 2015年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comic : NSObject

@property (nonatomic,strong)NSString    *name;
@property (nonatomic,assign)NSInteger   comicID;

+ (Comic *)comicWithId:(NSInteger)comicID withName:(NSString *)name;
- (NSComparisonResult)compareComic:(Comic *)c;

@end
