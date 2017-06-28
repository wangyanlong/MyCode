//
//  MyURLProtocol.h
//  NSURLProtocol
//
//  Created by wyl on 2017/6/28.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyURLProtocol : NSURLProtocol<NSURLSessionDelegate>

@property (nonatomic, strong)NSURLSession *session;

@end
