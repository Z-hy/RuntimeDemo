//
//  UIImage+UIImage.m
//  RuntimeDemo
//
//  Created by user on 2017/3/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import "UIImage+UIImage.h"
#import <objc/message.h>

@implementation UIImage (UIImage)

/**
 load方法: 把类加载进内存的时候调用,只会调用一次方法应先交换，再去调用
 */
+ (void)load {
    // 1.获取imageNamed方法地址
    // class_getClassMethod（获取某个类的方法）
    Method imageNamedMethod = class_getClassMethod(self, @selector(imageNamed:));
    // 2.获取ln_imageNamed方法地址
    Method ln_imageNamedMethod = class_getClassMethod(self, @selector(ln_imageNamed:));
    // 3.交换方法地址，相当于交换实现方式;「method_exchangeImplementations 交换两个方法的实现
    method_exchangeImplementations(imageNamedMethod, ln_imageNamedMethod);
}

// 加载图片且判断是否加载成功
+ (UIImage *)ln_imageNamed:(NSString *)name {
    UIImage *image = [UIImage ln_imageNamed:name];
    if (image) {
        NSLog(@"runtime添加额外功能---加载成功");
    } else {
        NSLog(@"runtime添加额外功能---加载失败");
    }
    return image;
}

/**
 不能在分类中重写系统方法imageNamed，因为会把系统的功能给覆盖掉，而且分类中不能调用super
 所以上面，我们要自己实现一个带有扩展功能的方法.
 + (UIImage *)imageNamed:(NSString *)name {
 
 }
 */

@end
