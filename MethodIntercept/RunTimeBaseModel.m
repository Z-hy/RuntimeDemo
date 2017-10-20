//
//  RunTimeBaseModel.m
//  RuntimeDemo
//
//  Created by user on 2017/10/19.
//  Copyright © 2017年 user. All rights reserved.
//

#import "RunTimeBaseModel.h"

@implementation RunTimeBaseModel

- (void)cl_logBaseModel {
    NSLog(@"Method Base Model Log.");
}

// 类方法也可以交换和拦截
+ (void)cl_logBaseModelClass {
    NSLog(@"Method Base Model Class Log.");
}
@end
