//
//  NSString+HttpResponce.h
//  NetWork
//
//  Created by wyl on 2017/7/5.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HttpResponce)

+ (NSString *)appVersionString;
+ (NSString *)cacheFileKeyNameWithUrlstring:(NSString* )urlString method:(NSString*)method parameters:(NSDictionary *)parameters;

@end
