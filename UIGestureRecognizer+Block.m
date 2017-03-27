//
//  UIGestureRecognizer+Block.m
//  RuntimeDemo
//
//  Created by user on 2017/3/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import "UIGestureRecognizer+Block.h"
#import <objc/runtime.h>

static const int target_key;

@implementation UIGestureRecognizer (Block)

+ (instancetype)zzz_gestureRecognizerWithActionBlock:(ZZZGestureBlock)block {
    return [[self alloc] initWithActionBlock: block];
}

- (instancetype)initWithActionBlock:(ZZZGestureBlock)block {
    self = [self init];
    [self addActionBlock:block];
    [self addTarget:self action:@selector(invoke:)];
    return self;
}

- (void)addActionBlock:(ZZZGestureBlock)block {
    if (block) {
        objc_setAssociatedObject(self, &target_key, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (void)invoke:(id)sender {
    ZZZGestureBlock block = objc_getAssociatedObject(self, &target_key);
    if (block) {
        block(sender);
    }
}

@end
