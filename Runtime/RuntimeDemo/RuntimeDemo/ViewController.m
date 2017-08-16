//
//  ViewController.m
//  RuntimeDemo
//
//  Created by 王老师 on 2017/1/9.
//  Copyright © 2017年 wyl. All rights reserved.
//
#import <objc/runtime.h>
#import "ViewController.h"
#import "SubClass.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)runtimeMethod1 {
    //class objc&object
    
      SubClass *myClass = [[SubClass alloc]init];
    
    unsigned int count = 0;
    
    Class cls = myClass.class;
    
    //得到类名
    NSLog(@"类名 %s",class_getName(cls));
    
    //获取整个成员变量的列表
    Ivar *ivars = class_copyIvarList(cls, &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"成员变量&属性名 : %s , index : %d",ivar_getName(ivar),i);
    }
    free(ivars);

    //得到父类
    NSLog(@"父类 : %s",class_getName(class_getSuperclass(cls)));
    
    //得到metaclass
    NSLog(@"SubClass %@ 是一个元类",class_isMetaClass(cls)?@"":@"不");

    //得到指定成员变量信息
    Ivar fourCopy = class_getInstanceVariable(cls, "_four");
    NSLog(@"%s",ivar_getName(fourCopy));
    
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t pro = properties[i];
        //得到属性名
        NSLog(@"%s",property_getName(pro));
    }
    
    //获得一个指定的属性
    objc_property_t four = class_getProperty(cls, "four");
    if (four != NULL) {
        NSLog(@"property_getName === %s",property_getName(four));
    }
    
    for (int i = 0; i < count; i++) {
        objc_property_t pro = properties[i];
        const char *proName = property_getName(pro);
        
        /**
         属性类型  name值：T  value：变化
         编码类型  name值：C(copy) &(strong) W(weak)空(assign) 等 value：无
         非/原子性 name值：空(atomic) N(Nonatomic)  value：无
         变量名称  name值：V  value：变化
         */
        
        //得到属性的特性
        const char *attribute = property_getAttributes(pro);
    
        NSLog(@"ProName %s attribute %s",proName,attribute);
        
        unsigned int attCount;
        
        objc_property_attribute_t *attList = property_copyAttributeList(pro, &attCount);
        
        for (int j = 0; j < attCount; j++) {
            objc_property_attribute_t attribute_t = attList[j];
            const char *name = attribute_t.name;
            const char *value = attribute_t.value;
        
            NSLog(@"name : %s value : %s",name,value);
        }
        
    }
    
    free(properties);
    
    //class_copyIvarList & class_copyPropertyList
    //class_copyIvarList 可以得到所有的成员变量和属性
    //class_copyPropertyList 只能得到属性
    //记得free
}

- (void)runtimeMethod2 {
    // Do any additional setup after loading the view, typically from a nib.

    SubClass *myClass = [[SubClass alloc]init];
    unsigned int count = 0;
    Class cls = myClass.class;
    
    //得到方法的列表
    Method *methodList = class_copyMethodList(cls, &count);
    
    for (int i = 0; i < count; i ++) {
        Method method = methodList[i];
        //得到方法的名字
        NSLog(@"%s",method_getName(method));
    }
    free(methodList);
    
    //得到类方法
    Method classMethod = class_getClassMethod(cls, @selector(method3));
    if (classMethod) {
        NSLog(@"%s",method_getName(classMethod));
    }
    
    //得到指定的方法
    Method method1 = class_getInstanceMethod(cls, @selector(method1));
    if (method1 != NULL) {
        NSLog(@"%s",method_getName(method1));
    }
    
    //是否相应方法
    BOOL y = class_respondsToSelector(cls, @selector(method1));
    NSLog(@"%d",y);
    
    //得到方法的具体实现
    IMP imp = class_getMethodImplementation(cls, @selector(method1));
    imp();
    
    NSLog(@"--------------");
    
    //得到协议列表
    Protocol * __unsafe_unretained * list = class_copyProtocolList(cls, &count);
    Protocol *p;
    for (int i = 0; i < count; i++) {
        p = list[i];
        //得到协议的名字
        NSLog(@"%s",protocol_getName(p));
    }
    
    //是否包含协议
    NSLog(@"subClass is%@ responsed to protocol %s",class_conformsToProtocol(cls, p)?@"":@"not",protocol_getName(p));
}

- (void)runtimeMethod3 {
    //在运行时创建继承自NSObject的People类
      Class People = objc_allocateClassPair([NSObject class], "People", 0);
    
    //添加成员变量,class_addIvar方法必须在创建类和注册类之间
    class_addIvar(People, "_name", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
    class_addIvar(People, "_age", sizeof(int), log2(sizeof(int)), @encode(int));
    
    //完成People的注册
    objc_registerClassPair(People);
    
    unsigned int varCount = 0;
    
    Ivar *list = class_copyIvarList(People, &varCount);
    for (int i = 0; i < varCount; i++) {
        NSLog(@"%s",ivar_getName(list[i]));
    }
    free(list);

    id p = [[People alloc]init];
    
    //得到指定的成员变量
    Ivar nameIvar = class_getInstanceVariable(People, "_name");
    Ivar ageIvar = class_getInstanceVariable(People, "_age");

    //为成员变量赋值
    object_setIvar(p, nameIvar, @"u17");
    object_setIvar(p, ageIvar, @123);
    
    NSLog(@"%@",object_getIvar(p, nameIvar));
    NSLog(@"%@",object_getIvar(p, ageIvar));
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
