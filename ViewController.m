//
//  ViewController.m
//  RuntimeDemo
//
//  Created by user on 2017/3/24.
//  Copyright © 2017年 user. All rights reserved.
//

/**
 runtime常见作用
 1.动态交换两个方法的实现(UIImage+UIImage)
 2.动态添加属性(ViewController)
 3.实现字典转模型的自动转换 (NSObject+Property)
 4.发送消息(Dog)
 5.动态添加方法(Person)
 6.拦截并替换方法(MethodIntercept Folder)
 7.实现NSCoding的自动归档和解档 (Movie)
 */

#import "ViewController.h"
#import "NSObject+Property.h"
#import "Person.h"
#import "Dog.h"
#import <objc/message.h>
#import "UIGestureRecognizer+Block.h"
#import "RunTimeMessageViewController.h"
#import "RunTimeMethodViewController.h"
#import "RunTimeMethodInterceptViewController.h"
#import "RunTimeCategoryViewController.h"
#import "NSObject+Conversion.h"
#import "RunTimeDataModel.h"

@interface ViewController ()<ModelDictionaryInterconversionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建狗对象 -> 调用方法
    Dog *dog = [[Dog alloc] init];
    // 调用方法 -> 实例方法
    [dog run];
    // 系统调用方法底层本质 -> 让对象发消息
//    objc_msgSend(dog, @selector(run));//等同于[dog run];
    // 调用方法 -> 类方法
//    objc_msgSend([Dog class], @selector(eat));//等同于 [Dog eat];
    
    // 实现字典转模型的自动转换
    NSArray *array = [NSArray arrayWithObjects:@"1", @"2",@"3", nil];
    NSMutableArray * array2 = [NSMutableArray arrayWithArray:array];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"dfdf" forKey:@"dfsdf"];
    [NSObject transfromToModelByDictionary:@{@"name" : @"zhang", @"num" : @"1", @"array" : array, @"ha": array2, @"dict": dict}];
    
    
    // 交换方法
    // 方案一：先搞个分类，定义一个能加载图片并且能打印的方法+ (instancetype)imageWithName:(NSString *)name;
    // 方案二：交换 imageNamed 和 ln_imageNamed 的实现，就能调用 imageNamed，间接调用 ln_imageNamed 的实现。
    UIImage *image = [UIImage imageNamed:@"1"];
    NSLog(@"image %@", image);
    
    
    // 动态添加属性
    NSObject *object = [[NSObject alloc] init];
    object.name = @"111";
    object.height = @"170";
    NSLog(@"name:%@, height:%@", object.name, object.height);
    
    
    // 动态添加方法
    Person *person = [[Person alloc] init];
    // 默认Pserson没有实现run:方法，但是可以通过performSelector调用，但是会报错
    // 动态添加方法就不会报错
//    [person performSelector:@selector(run:) withObject:@10];
    
    // Model 和 Dictionary 转换
    NSDictionary *dictionary = @{@"age": @"27",
                           @"name": @"xiaoming",
                           @"data": @[@{@"info":@"developement"}]
                           };
    RunTimeDataModel *dataModel = [RunTimeDataModel modelWithDictForArray:dictionary];
    NSLog(@"%@", dataModel);
    
    // 使用runtime 来写了通过 block回调 直接调用手势识别的action
    [self.view addGestureRecognizer:[UITapGestureRecognizer zzz_gestureRecognizerWithActionBlock:^(id gestureRecognizer) {
        NSLog(@"点击---------");
    }]];
    [self.view addGestureRecognizer:[UILongPressGestureRecognizer zzz_gestureRecognizerWithActionBlock:^(id gestureRecognizer) {
        NSLog(@"长按---------");
    }]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToRunTimeMessageViewController:(id)sender {
    RunTimeMessageViewController *msgVC = [[RunTimeMessageViewController alloc] init];
    [self.navigationController pushViewController:msgVC animated: YES];
}

- (IBAction)goToRunTimeMethodViewController:(id)sender {
    RunTimeMethodViewController *methodVC = [[RunTimeMethodViewController alloc] init];
    [self.navigationController pushViewController: methodVC animated: YES];
}
- (IBAction)goToMethodInterceptViewController:(id)sender {
    RunTimeMethodInterceptViewController *interceptVC = [[RunTimeMethodInterceptViewController alloc] init];
    [self.navigationController pushViewController: interceptVC animated: YES];
}
- (IBAction)goToRunTimeCategoryViewController:(id)sender {
    RunTimeCategoryViewController *categoryVC = [[RunTimeCategoryViewController alloc] init];
    [self.navigationController pushViewController: categoryVC animated: YES];
}

@end
