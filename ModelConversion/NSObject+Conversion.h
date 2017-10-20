//
//  NSObject+Conversion.h
//  RuntimeDemo
//
//  Created by user on 2017/10/20.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModelDictionaryInterconversionDelegate <NSObject>

@optional
// 提供一些用来转换模型的协议, 只要遵守了这个协议, 就可以把数组中的字典转成模型
+ (NSDictionary *)arrayContainModelClass;

@end

@interface NSObject (Conversion)

+ (instancetype)modelWithDict:(NSDictionary *)dict;
+ (instancetype)modelWithDictFofNestification:(NSDictionary *)dict;
+ (instancetype)modelWithDictForArray:(NSDictionary *)dict;

@end
