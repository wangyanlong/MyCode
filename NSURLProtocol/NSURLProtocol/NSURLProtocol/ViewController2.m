//
//  ViewController2.m
//  NSURLProtocol
//
//  Created by wyl on 2017/6/28.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "ViewController2.h"
#import "MyURLProtocol.h"
@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSURLProtocol registerClass:[MyURLProtocol class]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://huaban.com"]];
    
    UIWebView *wv = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [wv loadRequest:request];
    [self.view addSubview:wv];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
