//
//  MyObject.h
//  KVCDemo
//
//  Created by 王老师 on 2017/3/28.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyObject : NSObject
{
//    NSString *_name;
//    NSString *_isName;
//    NSString *name;
//    NSString *isName;
}
- (void)log;

@property (nonatomic, assign) NSInteger price;
@property (nonatomic, strong) NSString  *name;

@end
