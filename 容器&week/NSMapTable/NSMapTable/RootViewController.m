//
//  RootViewController.m
//  NSMapTable
//
//  Created by wyl on 2017/6/7.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

static NSMapTable *_mapTable;

@implementation RootViewController

//懒加载
- (NSMapTable *)mapTable {
    
    if (!_mapTable) {
        _mapTable = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsCopyIn valueOptions:NSPointerFunctionsWeakMemory];
    }
    return _mapTable;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%@", [self mapTable]);
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
