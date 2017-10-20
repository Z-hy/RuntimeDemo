//
//  RunTimeIterceptModel.m
//  RuntimeDemo
//
//  Created by user on 2017/10/19.
//  Copyright © 2017年 user. All rights reserved.
//

#import "RunTimeInterceptModel.h"

@implementation RunTimeInterceptModel

- (void)cl_logInterceptModel {
    NSLog(@"Method Intercept Model Log. Intercept Your Method.");
}

// 类方法也可以交换和拦截
+ (void)cl_logInterceptModelClass {
    NSLog(@"Method Intercept Model Log. Intercept Class Your Method.");
}

@end
