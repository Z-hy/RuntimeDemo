//
//  Person.m
//  RuntimeDemo
//
//  Created by user on 2017/3/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import "Person.h"
#import <objc/message.h>

@implementation Person
//没有返回值，1个参数
//Void,(id, SEL)

void run(id self, SEL _cmd, NSNumber *meter) {
    NSLog(@"跑了%@米", meter);
}

//任何方法默认都有两个隐式参数，self,_cmd(当前方法的方法编号)
//什么时候调用：只要一个对象调用了一个未实现的方法就会调用这个方法，进行处理
//作用：动态添加方法，处理未实现
+ (BOOL)resolveClassMethod:(SEL)sel {
    if (sel == NSSelectorFromString(@"run:")) {
        //动态添加run:方法
        //class:给哪个类添加方法
        //SEL:添加哪个方法，即添加方法的方法编号
        //IMP: 方法实现 -> 函数 -> 函数入口 -> 函数名（添加方法的函数实现（函数地址））
        //type: 方法类型，返回值+参数类型， v:void @:对象->self:表示SEL->_cmd
        class_addMethod(self, sel, (IMP)run, "v@:@");
        return YES;
    }
    return [super resolveClassMethod:sel];
}

@end
