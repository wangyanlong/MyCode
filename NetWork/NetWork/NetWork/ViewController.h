//
//  ViewController.h
//  NetWork
//
//  Created by wyl on 2017/7/4.
//  Copyright © 2017年 wyl. All rights reserved.
//

/*
 1 每一个url对应一个文件 url(不是明文 MD5)
 如果我缓存设置20秒过期（页面恶意频繁的刷新或者重复的退出界面，进来界面）
 如果数据更新可以不是及时的（设置时效）（非即时）
 
 2时效性
 3删除机制
 
 首先URL+parameters（URL+P）
 1那么通过URL+P生成一个字符串，那么字符串明文不安全，加密生成一个文件名 fileName
 2那么我就去找NSCache又没有这个一个fileName这个一个key，如有直接返回，实效都不用判断了
 3如果NSCache没有，那么我们就直接去文件系统里面查找filename是否存在
 4如果存在，那么我们要判断这个filename的实效性，是否过期
 5如果filename没过期，那么我们就直接读取文件数据返回。
 6如果filename过期了，那么我们就直接去AF请求，
 7请求完之后，判断是否要存储缓存（通过实效resultCacheDuration>0来判断）大于0(等等-1)就存储，小于0就不存储
 
 删除操作：
 进入后台时期删除缓存文件
 删除方式：1 通过时间来删除（有一个maxCacheAge）  2 通过缓存大小设置来删除（maxCacheSize）3 保护缓存（protectCaches 不被删除的）
 
 1和2 都是文件的操作（排序，获取文件时间和大小属性操作）
 
 */

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end

