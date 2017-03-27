//
//  UIGestureRecognizer+Block.h
//  RuntimeDemo
//
//  Created by user on 2017/3/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ZZZGestureBlock) (id gestureRecognizer);

@interface UIGestureRecognizer (Block)

/**
 *使用类方法 初始化 添加手势
 *@param block 手势回调
 *@return block 内部action
 *使用 __unsafe_unretained __typeof(self) weakSelf = self; 防止循环引用
 */

+ (instancetype)zzz_gestureRecognizerWithActionBlock:(ZZZGestureBlock)block;

@end
