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

//自动打印属性字符串
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

//runtime 字典转模型 -->字典的key和模型的属性数量不匹配（模型属性数量 > 字典键值对数量）
+ (instancetype)modelWithDict:(NSDictionary *)dict {
    //创建对象
    id objc = [[self alloc] init];
    //利用runtime给对象中的成员属性赋值
    /**
     class_copyIvarList: 获取类中所有的成员属性
     Ivar:成员属性
     第一个参数表示获取哪个类中的成员属性
     第二个参数表示这个类有多少成员属性，传入一个int变量地址，会自动给这个变量赋值
     返回值Ivar * 表示一个ivar数组，会把所有的成员属性放在一个数组中，通过返回的数组就能全部获取
     count表示成员变量个数
    */
    unsigned int count = 0;
    //获取类中所有的成员属性
    Ivar *ivarList = class_copyIvarList(self, &count);
    //遍历所有成员变量
    for (int i = 0; i < count; i++) {
        //根据角标，从数组中取出对应的成员属性
        Ivar ivar = ivarList[i];
        //获取成员变量名字
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        //处理成员属性名->字典中的key(去掉 _, 从第一个角标开始截取)
        NSString *key = [ivarName substringFromIndex:1];
        //根据成员属性名字去字典中查找对应的value
        id value = dict[key];
        //如果模型属性数量大于字典键值对的数量，模型属性会被赋值为nil而报错（could not set nil as the value for the key age.）
        if (value) {
            [objc setValue:value forKey:key];
        }
    }
    return objc;
}

//runtime字典转模型->模型中嵌套模型（模型中的一个属性是另外一个模型对象）
+ (instancetype)modelWithDictFofNestification:(NSDictionary *)dict {
    //创建对象
    id objc = [[self alloc] init];
    //利用runtime给对象中的成员属性赋值
    /**
     class_copyIvarList: 获取类中所有的成员属性
     Ivar:成员属性
     第一个参数表示获取哪个类中的成员属性
     第二个参数表示这个类有多少成员属性，传入一个int变量地址，会自动给这个变量赋值
     返回值Ivar * 表示一个ivar数组，会把所有的成员属性放在一个数组中，通过返回的数组就能全部获取
     count表示成员变量个数
     */
    unsigned int count = 0;
    //获取类中所有的成员属性
    Ivar *ivarList = class_copyIvarList(self, &count);
    //遍历所有成员变量
    for (int i = 0; i < count; i++) {
        //根据角标，从数组中取出对应的成员属性
        Ivar ivar = ivarList[i];
        //获取成员变量名字
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        //获取成员变量类型
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        //替换 @\"xxxx" -> xxxx (xxxx表示另一个模型对象)
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
        //处理成员属性名->字典中的key(去掉 _, 从第一个角标开始截取)
        NSString *key = [ivarName substringFromIndex:1];
        //根据成员属性名字去字典中查找对应的value
        id value = dict[key];
        //二级转换，如果字典中还嵌套着字典，也需要把对应的字典转换成模型
        //判断value是否是字典，并且是自定义对象才需要转换
        if ([value isKindOfClass:[NSDictionary class]] && ![ivarType hasPrefix:@"NS"]) {
            //字典转换成模型,根据字符串类名生成类对象
            Class modelClass = NSClassFromString(ivarType);
            if (modelClass) {//有对应的模型才需要转
                //把字典转成模型
                value = [modelClass modelWithDictFofNestification:value];
            }
        }
        //如果模型属性数量大于字典键值对的数量，模型属性会被赋值为nil而报错（could not set nil as the value for the key age.）
        if (value) {
            [objc setValue:value forKey:key];
        }
    }
    return objc;
}

////runtime 字典转模型->数组中装着模型（模型的属性是一个数组，数组中是字典模型对象）
//+ (instancetype)modelWithDictForArray:(NSDictionary *)dict {
//    //创建对象
//    id objc = [[self alloc] init];
//    //利用runtime给对象中的成员属性赋值
//    /**
//     class_copyIvarList: 获取类中所有的成员属性
//     Ivar:成员属性
//     第一个参数表示获取哪个类中的成员属性
//     第二个参数表示这个类有多少成员属性，传入一个int变量地址，会自动给这个变量赋值
//     返回值Ivar * 表示一个ivar数组，会把所有的成员属性放在一个数组中，通过返回的数组就能全部获取
//     count表示成员变量个数
//     */
//    unsigned int count = 0;
//    //获取类中所有的成员属性
//    Ivar *ivarList = class_copyIvarList(self, &count);
//    //遍历所有成员变量
//    for (int i = 0; i < count; i++) {
//        //根据角标，从数组中取出对应的成员属性
//        Ivar ivar = ivarList[i];
//        //获取成员变量名字
//        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
//        //处理成员属性名->字典中的key(去掉 _, 从第一个角标开始截取)
//        NSString *key = [ivarName substringFromIndex:1];
//        //根据成员属性名字去字典中查找对应的value
//        id value = dict[key];
//        //三级转换，NSArray中也是字典，把数组中的字典转换成模型
//        //判断value是否是数组
//        if ([value isKindOfClass:[NSArray class]]) {
//            //判断对应类有没有实现字典数组转模型数组的协议
//            //arrayContainModelClass 提供一个协议，只要遵守这个协议的类，都能把数组中的字典转换成模型
//            if ([self respondsToSelector:@selector(arrayContainModelClass)]) {
//                //转换成id类型，就能调用任何对象的方法
//                id idSelf = self;
//                //获取数组中字典对应的模型
//                NSString *type = [idSelf arrayContainModelClass][key];
//                //生成模型
//                Class classModel = NSClassFromString(type);
//                NSMutableArray *arr = [NSMutableArray array];
//                //遍历字典数组，生成模型数组
//                for (NSDictionary *dict in value) {
//                    //字典转模型
//                    id model = [classModel modelWithDictForArray:dict];
//                    [arr addObject:model];
//                }
//                //把模型数组赋值给value
//                value = arr;
//            }
//        }
//        //如果模型属性数量大于字典键值对的数量，模型属性会被赋值为nil而报错（could not set nil as the value for the key age.）
//        if (value) {
//            [objc setValue:value forKey:key];
//        }
//    }
//    return objc;
//}

@end
