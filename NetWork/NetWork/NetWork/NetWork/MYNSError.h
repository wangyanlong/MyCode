//
//  MYNSError.h
//  NetWork
//
//  Created by wyl on 2017/7/5.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYNSError : NSObject

@property(nonatomic, strong)NSString *errorDescription;
@property(nonatomic, strong)NSString *errorCode;
@property(nonatomic, strong)NSError *sysError;

@end
