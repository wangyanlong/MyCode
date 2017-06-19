//
//  ViewController.m
//  DeepCopy&Copy
//
//  Created by 王颜龙 on 13-12-23.
//  Copyright (c) 2013年 longyan. All rights reserved.
//

#import "ViewController.h"
#import "MyObj.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    
    NSMutableArray *a = [[NSMutableArray alloc]initWithCapacity:0];
    [a addObject:@"1"];
    
    NSMutableArray *b = [a copy];
    [b addObject:@"b"];
    
    //浅拷贝
    NSArray *copyArr = [[NSArray alloc]initWithArray:@[@(1)]];
    NSDictionary *copyDict = [[NSDictionary alloc]initWithDictionary:@{@"1":@(1),@"3":@(2)}];
    
    //深拷贝
    NSArray *copyArrDeep = [[NSArray alloc]initWithArray:@[@(1)] copyItems:YES];
    NSDictionary *copyDictDeep =[[NSDictionary alloc]initWithDictionary:@{@"1":@(1),@"3":@(2)} copyItems:YES];

    //归档
    //保存
    NSData *buffer = [NSKeyedArchiver archivedDataWithRootObject:@[@(1),@(2)]];
    //恢复
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:buffer];
    
    NSArray *array = [NSArray arrayWithObjects:[NSMutableString stringWithString:@"first"],@"b",@"c",nil];
    
    NSMutableArray *arrTest = [[NSMutableArray alloc]init];
    [arrTest addObject:@[@(1)]];
    [arrTest addObject:@[@(2)]];
    
    NSMutableArray *arrTest2 = [[NSMutableArray alloc]initWithArray:array];
    
    [arrTest2 replaceObjectAtIndex:0 withObject:@{@"3":@(3)}];
    NSLog(@"%@",arrTest2);
    
    
    NSMutableString *string = [NSMutableString stringWithString: @"origion"];
    [string appendString:@"11"];
    NSLog(@"%@",string);
    
    NSMutableArray *mArr = [array mutableCopy];
    [mArr addObject:@"ddd"];
    NSLog(@"arr %@",mArr);
    
    NSArray *deepCopyArray=[[NSArray alloc] initWithArray: array copyItems: YES];
    
    NSArray* trueDeepCopyArray = [NSKeyedUnarchiver unarchiveObjectWithData:
                                  [NSKeyedArchiver archivedDataWithRootObject: array]];

    MyObj *one = [[MyObj alloc]init];
    one.name = [[NSMutableString alloc]initWithString:@"wyl"];
    one.imutableStr = @"111";
    one.age = 25;
    MyObj *two = [one copy];
    NSLog(@"%@,%@,%d",two.name,two.imutableStr,two.age);
    
    MyObj *three = [one mutableCopy];
    NSLog(@"%@,%d",three.name,three.age);
    
    NSLog(@"%p",one);
    NSLog(@"%p",two);
    NSLog(@"%p",three);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
