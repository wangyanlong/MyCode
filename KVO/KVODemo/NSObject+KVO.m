//
//  NSObject+KVO.m
//  KVODemo
//
//  Created by 王老师 on 2017/2/7.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

#define kKvoCls @"KVOCls"
NSString *const kAssociatedOb = @"kAssociatedOb";

@interface ObservationInfo : NSObject

@property (nonatomic, strong) NSString  *key;
@property (nonatomic, weak) NSObject *ob;
@property (nonatomic, copy) studyKvoBlock block;

@end

@implementation ObservationInfo

- (instancetype)initWithObserver:(NSObject *)ob key:(NSString *)key block:(studyKvoBlock)block{
    
    self = [super init];
    
    if (self) {
    
        self.ob = ob;
        self.key = key;
        self.block = block;
        
    }
    
    return self;
}

@end

@implementation NSObject (KVO)

//get
- (NSString *)getGetMethod:(NSString *)str{
    
    if (str.length <=0 || ![str hasPrefix:@"set"] || ![str hasSuffix:@":"]) {
        return nil;
    }
    
    NSRange range = NSMakeRange(3, str.length - 4);
    NSString *key = [str substringWithRange:range];
    
    NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                       withString:firstLetter];
    
    return key;

    
}

//set
- (NSString *)getSetMethod:(NSString *)str{
    
    if (str.length <= 0) {
        return nil;
    }
    
    NSString *firstLetter = [[str substringToIndex:1] uppercaseString];
    NSString *remainingLetters = [str substringFromIndex:1];
    
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", firstLetter, remainingLetters];
    
    return setter;
    
}

#pragma mark - KVO方法

/*
 1.检查对象的类有没有相应的 setter 方法。如果没有抛出异常；
 
 2.检查对象 isa 指向的类是不是一个 KVO 类。如果不是，新建一个继承原来类的子类，并把 isa 指向这个新建的子类；
 
 3.检查新建的子类重写过没有这个 setter 方法。如果没有，添加重写的 setter 方法；
 
 4.新建的子类添加观察者,并用关联对象添加一个数组,把观察者,观察的对象放入数组
 
 5.当set方法被调用重新赋值的时候,检查数组里的key和set的对象是否一致,如果一致,回调block
 */

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath withBackBlock:(studyKvoBlock)block{
    
    // 1.检查对象的类有没有相应的 setter 方法。如果没有抛出异常；
    SEL setSel = NSSelectorFromString([self getSetMethod:keyPath]);
    
    Method setMethod = class_getInstanceMethod([self class], setSel);
    
    if (!setMethod) {
        NSLog(@"error!!!");
        return;
    }
    
    //2.检查对象 isa 指向的类是不是一个 KVO 类。如果不是，新建一个继承原来类的子类，并把 isa 指向这个新建的子类
    Class cls = object_getClass(self);
    NSString *strCls = NSStringFromClass(cls);
    
    if (![strCls isEqualToString:kKvoCls]) {
        cls = [self makeKvoClassWithOriginClsName:kKvoCls];
        object_setClass(self, cls);//把self指向新的类,然后重写set方法,达到kvo效果
    }
    
    // 3.检查新建的子类重写过没有这个 setter 方法。如果没有，添加重写的 setter 方法；
    if (![self hasSelector:setSel]) {
        const char *types = method_getTypeEncoding(setMethod);
        class_addMethod(cls, setSel, (IMP)kvo_setter, types);
    }
    
    // 4.新建的子类添加观察者,并用关联对象添加一个数组,把观察者,观察的对象放入数组
    ObservationInfo *info = [[ObservationInfo alloc]initWithObserver:observer key:keyPath block:block];
    
    NSMutableArray *obArr = objc_getAssociatedObject(self, (__bridge const void*)kAssociatedOb);
    
    if (!obArr) {
    
        obArr = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void*)kAssociatedOb, obArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    
    [obArr addObject:info];
    
}

//判断有没有重写过set方法

static void kvo_setter(id self,SEL _cmd,id newValue){
    
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = [self getGetMethod:setterName];
    
    if (!getterName) {
        return;
    }
    
    id oldValue = [self valueForKey:getterName];
    
    struct objc_super superClass = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    
    void (*objc_msgSendSuperCasted)(void *,SEL,id) = (void*)objc_msgSendSuper;
    
    objc_msgSendSuperCasted(&superClass,_cmd,newValue);
    
    //当set方法被调用重新赋值的时候,检查数组里的key和set的对象是否一致,如果一致,回调block
    NSMutableArray *obArr = objc_getAssociatedObject(self, (__bridge const void*)kAssociatedOb);
    
    for (ObservationInfo *info in obArr) {
        if ([info.key isEqualToString:getterName]) {
            info.block(self,getterName,oldValue,newValue);
            break;
        }
    }
    
}

- (BOOL)hasSelector:(SEL)sel{

    Class class = object_getClass(self);
    
    unsigned int count = 0;
    
    Method *list = class_copyMethodList(class, &count);
    
    for (int i = 0; i < count; i++) {
        
        SEL selector = method_getName(list[i]);
        
        if (selector == sel) {
            free(list);
            return YES;
        }
        
    }
    
    free(list);
    
    return NO;
}

//创建一个新类
- (Class)makeKvoClassWithOriginClsName:(NSString *)className{

    Class cls = NSClassFromString(kKvoCls);
    
    if (cls) {
        return cls;
    }
    
    Class originalClass = object_getClass(self);
    Class kvoClass = objc_allocateClassPair(originalClass, className.UTF8String, 0);
    objc_registerClassPair(kvoClass);
    
    return kvoClass;
}

@end
