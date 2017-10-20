//
//  NSObject+Conversion.m
//  RuntimeDemo
//
//  Created by user on 2017/10/20.
//  Copyright © 2017年 user. All rights reserved.
//

#import "NSObject+Conversion.h"

#import <objc/runtime.h>

@implementation NSObject (Conversion)

// runtime 字典转模型 -->字典的key和模型的属性数量不匹配（模型属性数量 > 字典键值对数量）
+ (instancetype)modelWithDict:(NSDictionary *)dict {
    // 创建对象
    id objc = [[self alloc] init];
    // 利用runtime给对象中的成员属性赋值
    /**
     class_copyIvarList: 获取类中所有的成员属性
     Ivar:成员属性
     第一个参数表示获取哪个类中的成员属性
     第二个参数表示这个类有多少成员属性，传入一个int变量地址，会自动给这个变量赋值
     返回值Ivar * 表示一个ivar数组，会把所有的成员属性放在一个数组中，通过返回的数组就能全部获取
     count表示成员变量个数
     */
    unsigned int count = 0;
    // 获取类中所有的成员属性
    Ivar *ivarList = class_copyIvarList(self, &count);
    // 遍历所有成员变量
    for (int i = 0; i < count; i++) {
        // 根据角标，从数组中取出对应的成员属性
        Ivar ivar = ivarList[i];
        // 获取成员变量名字
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 处理成员属性名->字典中的key(去掉 _, 从第一个角标开始截取),从下标1开始取对应的key, 不然的话, 就会取到带"_"的key
        NSString *key = [ivarName substringFromIndex:1];
        // 根据成员属性名字去字典中查找对应的value
        id value = dict[key];
        // 如果模型属性数量大于字典键值对的数量，模型属性会被赋值为nil而报错（could not set nil as the value for the key age.）
        // 判断value是否为nil, 如果不是, 就给属性赋值
        // 当属性的数量大于字典Key的数量时的判断
        if (value) {
            [objc setValue:value forKey:key];
        }
    }
    return objc;
}
/*
 注：
 这里我们是采用class_copyIvarList的方式获取所有成员变量的, 而成员变量都是使用"_"符号进行命名的, 所以我们要处理一下, 当然也可以使用class_copyPropertyList, 命名就不用处理, 其他都差不多.
 为什么使用class_copyIvarList呢? 在前面我们都看到过给分类添加属性的时候, 只是简单的声明了set和get, 并没有实现
 如果我们使用class_copyPropertyList, 可能就会漏掉了成员变量或者是没有实现set和get方法的属性, 而使用class_copyIvarList就不会有这个问题.
 */

// runtime字典转模型->模型中嵌套模型（模型中的一个属性是另外一个模型对象）
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

// runtime 字典转模型->数组中装着模型（模型的属性是一个数组，数组中是字典模型对象）
+ (instancetype)modelWithDictForArray:(NSDictionary *)dict {
    // 创建对象
    id objc = [[self alloc] init];
    // 利用runtime给对象中的成员属性赋值
    /**
     class_copyIvarList: 获取类中所有的成员属性
     Ivar:成员属性
     第一个参数表示获取哪个类中的成员属性
     第二个参数表示这个类有多少成员属性，传入一个int变量地址，会自动给这个变量赋值
     返回值Ivar * 表示一个ivar数组，会把所有的成员属性放在一个数组中，通过返回的数组就能全部获取
     count表示成员变量个数
     */
    unsigned int count = 0;
    // 获取类中所有的成员属性
    Ivar *ivarList = class_copyIvarList(self, &count);
    // 遍历所有成员变量
    for (int i = 0; i < count; i++) {
        // 根据角标，从数组中取出对应的成员属性
        Ivar ivar = ivarList[i];
        // 获取成员变量名字
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 处理成员属性名->字典中的key(去掉 _, 从第一个角标开始截取)
        NSString *key = [ivarName substringFromIndex:1];
        // 根据成员属性名字去字典中查找对应的value
        id value = dict[key];
        // 三级转换，NSArray中也是字典，把数组中的字典转换成模型
        // 判断value是否是数组
        if ([value isKindOfClass:[NSArray class]]) {
            // 判断对应类有没有实现字典数组转模型数组的协议
            // arrayContainModelClass 提供一个协议，只要遵守这个协议的类，都能把数组中的字典转换成模型
            if ([self respondsToSelector:@selector(arrayContainModelClass)]) {
                // 转换成id类型，就能调用任何对象的方法
                id idSelf = self;
                // 获取数组中字典对应的模型
                NSString *type = [idSelf arrayContainModelClass][key];
                // 生成模型
                Class classModel = NSClassFromString(type);
                NSMutableArray *arr = [NSMutableArray array];
                // 遍历字典数组，生成模型数组
                for (NSDictionary *dict in value) {
                    // 字典转模型
                    id model = [classModel modelWithDictForArray:dict];
                    [arr addObject:model];
                }
                // 把模型数组赋值给value
                value = arr;
            }
        }
        // 如果模型属性数量大于字典键值对的数量，模型属性会被赋值为nil而报错（could not set nil as the value for the key age.）
        if (value) {
            [objc setValue:value forKey:key];
        }
    }
    return objc;
}

@end
