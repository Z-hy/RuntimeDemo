//
//  RunTimeBaseModel.h
//  RuntimeDemo
//
//  Created by user on 2017/10/19.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunTimeBaseModel : NSObject

- (void)cl_logBaseModel;

// 类方法也可以交换和拦截
+ (void)cl_logBaseModelClass;

@end
