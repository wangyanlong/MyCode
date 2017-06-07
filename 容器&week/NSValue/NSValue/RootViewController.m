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

static NSMutableArray *_array;

@implementation RootViewController

//懒加载
- (NSMutableArray *)array {
    
    if (!_array) {
        _array = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _array;
    
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
    
    NSLog(@"%@", [self array]);
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%@--%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));

}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    NSLog(@"%@--%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));

}

- (void)dealloc
{
    NSLog(@"%@--%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
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
