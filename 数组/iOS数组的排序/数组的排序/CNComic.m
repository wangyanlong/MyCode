//
//  CNComic.m
//  数组的排序
//
//  Created by 王老师 on 15/8/31.
//  Copyright (c) 2015年 wyl. All rights reserved.
//

#import "CNComic.h"

@implementation CNComic

+ (CNComic *)createComicWithComicID:(NSInteger)comicID withChapter:(CNChapter *)chapter withPage:(CNPage *)page{

    CNComic *c = [[CNComic alloc]init];
    c.comicID = comicID;
    c.chapter = chapter;
    c.page = page;
    
    return c;

}

@end
