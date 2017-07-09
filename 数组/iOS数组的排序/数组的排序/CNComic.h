//
//  CNComic.h
//  数组的排序
//
//  Created by 王老师 on 15/8/31.
//  Copyright (c) 2015年 wyl. All rights reserved.
//
#import "CNChapter.h"
#import "CNPage.h"
#import <Foundation/Foundation.h>

@interface CNComic : NSObject

@property (nonatomic,assign)NSInteger   comicID;
@property (nonatomic,strong)CNChapter   *chapter;
@property (nonatomic,strong)CNPage      *page;

+ (CNComic *)createComicWithComicID:(NSInteger)comicID withChapter:(CNChapter *)chapter withPage:(CNPage *)page;

@end
