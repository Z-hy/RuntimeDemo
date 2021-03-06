//
//  Movie.m
//  RuntimeDemo
//
//  Created by user on 2017/3/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import "Movie.h"
#import <objc/runtime.h>

@implementation Movie

// 3.实现字典转模型的自动转换

- (void)encodeWithCoder:(NSCoder *)aCoder {
    /*
     常规归档写法：
    [aCoder encodeObject:_movieId forKey:@"id"];
    [aCoder encodeObject:_movieName forKey:@"name"];
    [aCoder encodeObject:_pic_url forKey:@"url"];
     */
    [self cl_runtimeEncoderWithCoder:aCoder];
}
// runtime 归档
- (void)cl_runtimeEncoderWithCoder:(NSCoder *)aCoder {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        // 查看成员变量
        const char *name = ivar_getName(ivar);
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    free(ivars);
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    /*
     常规解档写法：
    if (self == [super init]) {
        self.movieId = [aDecoder decodeObjectForKey:@"id"];
        self.movieName = [aDecoder decodeObjectForKey:@"name"];
        self.pic_url = [aDecoder decodeObjectForKey:@"url"];
    }
    return self;
     */
    if (self == [super init]) {
        [self cl_runtimeDecideWithCoder:aDecoder];
    }
    return self;
}

// runtime 解档
- (void)cl_runtimeDecideWithCoder:(NSCoder *)aDecoder {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        //取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        //查看成员变量
        const char *name = ivar_getName(ivar);
        //归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [aDecoder decodeObjectForKey:key];
        //设置到成员变量身上
        [self setValue:value forKey:key];
    }
    free(ivars);
}

@end
