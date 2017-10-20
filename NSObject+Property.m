//
//  NSObject+Property.m
//  RuntimeDemo
//
//  Created by user on 2017/3/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSObject (Property)

- (void)setName:(NSString *)name {
    // objc_setAssociatedObject（将某个值跟某个对象关联起来，将某个值存储到某个对象中）
    // object:给哪个对象添加属性
    // key:属性名称
    // value:属性值
    // policy:保存策略
    
    //    typedef OBJC_ENUM(uintptr_t, objc_AssociationPolicy) {
    //        OBJC_ASSOCIATION_ASSIGN = 0,           /**< Specifies a weak reference to the associated object. */
    //        OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1, /**< Specifies a strong reference to the associated object.
    //                                                *   The association is not made atomically. */
    //        OBJC_ASSOCIATION_COPY_NONATOMIC = 3,   /**< Specifies that the associated object is copied.
    //                                                *   The association is not made atomically. */
    //        OBJC_ASSOCIATION_RETAIN = 01401,       /**< Specifies a strong reference to the associated object.
    //                                                *   The association is made atomically. */
    //        OBJC_ASSOCIATION_COPY = 01403          /**< Specifies that the associated object is copied.
    //                                                *   The association is made atomically. */
    //    };
    objc_setAssociatedObject(self, @"name", name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)name {
    return objc_getAssociatedObject(self, @"name");
}

- (void)setHeight:(NSString *)height {
    objc_setAssociatedObject(self, @"height", height, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)height {
    return objc_getAssociatedObject(self, @"height");
}

// 自动生成属性并打印属性字符串
+ (void)transfromToModelByDictionary:(NSDictionary *)dict {
    //根据类别拼接属性字符串代码
    NSMutableString *string = [NSMutableString string];
    //遍历字典，把字典中的所有key取出来，生成对应的属性代码
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //对各类型进行分类，抽取出来
        NSString *type;
        //需要理解系统底层数据结构类型
        if ([obj isKindOfClass:NSClassFromString(@"__NSString")]) {
            type = @"NSString";
        } else if ([obj isKindOfClass:NSClassFromString(@"__NSArrayI")]) {
            type = @"NSArray";
        } else if ([obj isKindOfClass:NSClassFromString(@"__NSArrayM")]) {
            type = @"NSMutaleArray";
        } else if ([obj isKindOfClass:NSClassFromString(@"__NSDictionaryI")]) {
            type = @"NSDictionary";
        } else if ([obj isKindOfClass:NSClassFromString(@"__NSDictionaryM")]) {
            type = @"NSMutableDictionary";
        } else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]) {
            type = @"NSNumber";
        }
        //属性字符串
        NSString *property;
        if ([type containsString:@"NS"]) {
            property = [NSString stringWithFormat:@"@property (nonautomic, strong) %@ *%@;", type, key];
        } else {
            property = [NSString stringWithFormat:@"@property (nonautomic, assign) %@ *%@;", type, key];
        }
        //每生成一对属性字符串 就自动换行
        [string appendFormat:@"\n%@\n", property];
    }];
    //打印拼接字符串
    NSLog(@"对应属性 -> %@", string);
}

@end
