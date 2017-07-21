//
//  MyObject.m
//  KVCDemo
//
//  Created by 王老师 on 2017/3/28.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "MyObject.h"

@implementation MyObject

//是否寻找与赋值key相关的成员变量去赋值,如果yes会以
//set<Key>:属性值
//_<key>和_is<Key>,<key>和is<Key>的成员变量
//-(void)setValue:(id)value forUndefinedKey:(NSString *)key
//的顺序去赋值
//如果为NO的话,key不符的情况下,直接调用
//-(void)setValue:(id)value forUndefinedKey:(NSString *)key

+(BOOL)accessInstanceVariablesDirectly{
    return NO;
}

//- (NSString *)getName{
//    return _name;
//}
//
//- (NSString *)name{
//    return _name;
//}

//- (void)setName:(NSString *)name1{
//    
//    _name = name1;
//    
//}

- (void)log{
    //NSLog(@"%@",_name);
   // NSLog(@"%@",_isName);
    //NSLog(@"%@",name);
    //NSLog(@"%@",isName);
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%s",__func__);
}

@end
