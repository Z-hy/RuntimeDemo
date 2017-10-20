//
//  RunTimeMethodInterceptViewController.m
//  RuntimeDemo
//
//  Created by user on 2017/10/19.
//  Copyright © 2017年 user. All rights reserved.
//

#import "RunTimeMethodInterceptViewController.h"
#import "RunTimeBaseModel.h"
#import "RunTimeInterceptModel.h"
#import <objc/message.h>

@interface RunTimeMethodInterceptViewController ()

@end

@implementation RunTimeMethodInterceptViewController

// RunTime 实现方法拦截

+ (void)initialize {
    // 拦截实例方法（减方法）
    Method methodOne = class_getInstanceMethod([RunTimeBaseModel class], @selector(cl_logBaseModel));
    Method methodTwo = class_getInstanceMethod([RunTimeInterceptModel class], @selector(cl_logInterceptModel));
    method_exchangeImplementations(methodOne, methodTwo);
    
    // 拦截类方法（加方法）
    Method calssMethodOne = class_getClassMethod([RunTimeBaseModel class], @selector(cl_logBaseModelClass));
    Method classMethodTwo = class_getClassMethod([RunTimeInterceptModel class], @selector(cl_logInterceptModelClass));
    method_exchangeImplementations(calssMethodOne, classMethodTwo);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSStringFromClass([self class]);
    
    RunTimeBaseModel *baseModel = [[RunTimeBaseModel alloc] init];
    [baseModel cl_logBaseModel];
    [RunTimeBaseModel cl_logBaseModelClass];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
