//
//  ViewController.m
//  NSCache
//
//  Created by 王老师 on 2017/5/16.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSCacheDelegate>

@property (nonatomic, strong)NSCache *cache;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.cache = [[NSCache alloc] init];
    self.cache.name = @"test";
    self.cache.delegate = self;
    
    for (int i = 1; i <= 6 ; i++) {
        [self.cache setObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]] forKey:[NSString stringWithFormat:@"%d.jpg",i]];
    }
    
}

- (void)cache:(NSCache *)cache willEvictObject:(id)obj{

    NSLog(@"当内存达到了一定程度,NSCache会自己释放内存,在这里可以操作CoreData等影响IO操作");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
