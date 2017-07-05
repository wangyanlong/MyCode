//
//  NSString+HttpResponce.m
//  NetWork
//
//  Created by wyl on 2017/7/5.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "NSString+HttpResponce.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (HttpResponce)

- (NSString *)md5Encrypt
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (unsigned int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}

// 看需求， 如果没更新一次版本，缓存就抛弃掉
+(NSString*)appVersionString{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

//获取某个缓存文件的存储名字 这里名字 进行MD5加密
+ (NSString *)cacheFileKeyNameWithUrlstring:(NSString* )urlString method:(NSString*)method parameters:(NSDictionary *)parameters{
    
    NSString *requestInfo = [NSString stringWithFormat:@"Method:%@ Url:%@ Argument:%@ AppVersion:%@ ",method,urlString,parameters,[NSString appVersionString]];
    //app 版本
    NSString *cacheFileName = [requestInfo md5Encrypt];
    
    return cacheFileName;
}

@end
