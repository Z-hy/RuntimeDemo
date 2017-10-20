//
//  RunTimeMethodViewController.m
//  RuntimeDemo
//
//  Created by user on 2017/10/19.
//  Copyright © 2017年 user. All rights reserved.
//

#import "RunTimeMethodViewController.h"
#import "RunTimeMethodModel.h"
#import <objc/message.h>

@interface RunTimeMethodViewController ()

@end

@implementation RunTimeMethodViewController

// RunTime 实现方法交换

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSStringFromClass([self class]);
    
    RunTimeMethodModel *methodModel = [[RunTimeMethodModel alloc] init];
    NSLog(@"我的身高是：%@", methodModel.cl_height);
    NSLog(@"我的体重是：%@", methodModel.cl_weight);
    
    // Action 1:放在这里当返回上一页面，再次进入该页面的时候method_exchangeImplementations一直存在，就会根据上次交换过的顺序再次交换，就会出错
//    Method methodOne = class_getInstanceMethod([methodModel class], @selector(cl_height));
//    Method methodTwo = class_getInstanceMethod([methodModel class], @selector(cl_weight));
//    method_exchangeImplementations(methodOne, methodTwo);
    
    NSLog(@"打印的内容：%@", [methodModel cl_height]);
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
