//
//  ViewController.m
//  数组的排序
//
//  Created by 王老师 on 15/8/31.
//  Copyright (c) 2015年 wyl. All rights reserved.
//
#import "CNPage.h"
#import "CNChapter.h"
#import "CNComic.h"
#import "Comic.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

//    NSMutableArray *arrNumber = [[NSMutableArray alloc]initWithCapacity:0];
//    
//    for (int i = 10; i > 0 ; i--) {
//        NSNumber *number = [NSNumber numberWithInt:i];
//        [arrNumber addObject:number];
//    }
//    
//    NSArray *oneNumber = [arrNumber sortedArrayUsingSelector:@selector(compare:)];
//    
//    NSArray *oneNumber2 = [[oneNumber reverseObjectEnumerator]allObjects];
//    
//    
//    NSArray *twoNumber = [arrNumber sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        
//        /*!
//         *  NSOrderedAscending  //左边的小于右边的
//            NSOrderedSame       //左边的等于右边的
//            NSOrderedDescending //左边的大于右边的
//         */
//        
//        NSComparisonResult result = [obj1 compare:obj2];
//        
//        return result;
//        
//    }];
//
//    NSArray *arrString = @[@"a",@"A",@"b",@"B",@"c",@"C"];
//    
//    NSArray *oneString = [arrString sortedArrayUsingSelector:@selector(compare:)];
//    
//    
//    NSArray *twoString = [arrString sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//       
//        NSComparisonResult result = [obj1 compare:obj2];
//        
//        return result;
//        
//    }];
    
    
//    Comic *c1 = [Comic comicWithId:1 withName:@"manhua1"];
//    Comic *c2 = [Comic comicWithId:2 withName:@"manhua2"];
//    Comic *c3 = [Comic comicWithId:3 withName:@"manhua3"];
//    
//    NSArray *arrayComic = [NSArray arrayWithObjects:c3,c2,c1,nil];
//    NSArray *sortComicArr = [arrayComic sortedArrayUsingSelector:@selector(compareComic:)];
//    
//    NSArray *sortComicArr2 = [arrayComic sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//       
//        NSComparisonResult result = [obj1 compareComic:obj2];
//        
//        return result;
//        
//    }];
    
    CNPage *p1 = [[CNPage alloc]init];
    p1.pageID = 3;
    CNPage *p2 = [[CNPage alloc]init];
    p2.pageID = 2;
    CNPage *p3 = [[CNPage alloc]init];
    p3.pageID = 1;
    
    CNChapter *chapter1 = [[CNChapter alloc]init];
    chapter1.chapterID = 5;
    CNChapter *chapter2 = [[CNChapter alloc]init];
    chapter2.chapterID = 4;
    CNChapter *chapter3 = [[CNChapter alloc]init];
    chapter3.chapterID = 6;
    
    CNComic *cn1 = [CNComic createComicWithComicID:7 withChapter:chapter1 withPage:p1];
    CNComic *cn2 = [CNComic createComicWithComicID:8 withChapter:chapter2 withPage:p2];
    CNComic *cn3 = [CNComic createComicWithComicID:9 withChapter:chapter3 withPage:p3];

    NSArray *array = @[cn1,cn2,cn3];
    
    //构建排序描述器
    NSSortDescriptor *comicIDDes = [NSSortDescriptor sortDescriptorWithKey:@"comicID" ascending:YES];
    NSSortDescriptor *chapterIDDes = [NSSortDescriptor sortDescriptorWithKey:@"chapter.chapterID" ascending:YES];
    NSSortDescriptor *pageIDDes = [NSSortDescriptor sortDescriptorWithKey:@"page.pageID" ascending:YES];
    
    NSArray *desArr = @[chapterIDDes,pageIDDes,comicIDDes];
    
    NSArray *resultArr = [array sortedArrayUsingDescriptors:desArr];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
