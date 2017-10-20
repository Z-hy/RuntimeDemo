//
//  RunTimeMethodModel.h
//  RuntimeDemo
//
//  Created by user on 2017/10/19.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunTimeMethodModel : NSObject

@property (nonatomic, copy) NSString *cl_height;
@property (nonatomic, copy) NSString *cl_weight;

- (NSString *)cl_height;
- (NSString *)cl_weight;

@end

