//
//  NSObject+Property.h
//  RuntimeDemo
//
//  Created by user on 2017/3/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Property)

//@property分类:只会生成get,set方法声明,不会生成实现,也不会生成下划线成员属性
@property NSString *name;
@property NSString *height;

+ (void)transfromToModelByDictionary:(NSDictionary *)dict;

@end
