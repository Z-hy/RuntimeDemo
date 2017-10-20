//
//  NSObject+CLObject.m
//  RuntimeDemo
//
//  Created by user on 2017/10/20.
//  Copyright © 2017年 user. All rights reserved.
//

#import "NSObject+CLObject.h"
#import <objc/runtime.h>

@implementation NSObject (CLObject)

/*
 而我们给对应的类添加Category就意味着是再给methodLists添加方法, 也就是因为这样子, 所以一般我们是不能在Category里面添加属性的, 虽然我们用了@property声明, 但也只是仅仅声明了get和set的方法, 并没有去实现.
 而在这里, 我们就是要利用RunTime去实现这个get和set:
 */
- (void)setCategoryName:(NSString *)categoryName {
    objc_setAssociatedObject(self, @"categoryName", categoryName, OBJC_ASSOCIATION_COPY);
}

/*
 在Category这里添加属性, 其实并不是真的添加, 只是关联上而已.
 这里的objc_setAssociatedObject有四个参数:
 
 id _Nonnull object: 给哪个对象关联属性
 const void * _Nonnull key: 属性的名称, 这里我们可以用OC字符串, 也可以用静态的void.
 id _Nullable value: 属性的数值
 objc_AssociationPolicy policy: 保存的策略, 这里共有五种保存的策略:
 
 OBJC_ASSOCIATION_ASSIGN
 OBJC_ASSOCIATION_RETAIN_NONATOMIC
 OBJC_ASSOCIATION_COPY_NONATOMIC
 OBJC_ASSOCIATION_RETAIN
 OBJC_ASSOCIATION_COPY
 */

- (NSString *)categoryName {
    return objc_getAssociatedObject(self, @"categoryName");
}

@end
