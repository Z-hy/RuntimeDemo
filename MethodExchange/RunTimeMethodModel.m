//
//  RunTimeMethodModel.m
//  RuntimeDemo
//
//  Created by user on 2017/10/19.
//  Copyright © 2017年 user. All rights reserved.
//

#import "RunTimeMethodModel.h"
#import <objc/message.h>

@implementation RunTimeMethodModel

+ (void)load {
//    // Action 2:虽然在+load这个方法里的确是可以保证方法交换只有一次, 但这里有一个弊端, 就是当程序一运行就会执行这个方法交换了, 这并不是一个好的方案.
//    Method methodOne = class_getInstanceMethod(self, @selector(cl_height));
//    Method methodTwo = class_getInstanceMethod(self, @selector(cl_weight));\
//    method_exchangeImplementations(methodOne, methodTwo);
}

+ (void)initialize {
    // Action 3:
    Method methodOne = class_getInstanceMethod(self, @selector(cl_height));
    Method methodTwo = class_getInstanceMethod(self, @selector(cl_weight));\
    method_exchangeImplementations(methodOne, methodTwo);
}

/*
 +load和+initialize的区别:
 +load: 程序一开始就会去执行, 只执行一次.
 +initialize: 当类被初始化的时候会才会去执行, 该类只会执行一次.
 当然并不是说在+load上用是不对的, 也不是说+initialize就一定是对的, 根据场景的需要来使用才是王道.
 */

- (NSString *)cl_height {
    return @"I am 180cm.";
}

- (NSString *)cl_weight {
    return @"My weight is 280kg.";
}

@end
