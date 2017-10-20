//
//  RunTimeMessageViewController.m
//  RuntimeDemo
//
//  Created by user on 2017/10/19.
//  Copyright © 2017年 user. All rights reserved.
//

#import "RunTimeMessageViewController.h"
#import "RunTimeMessageModel.h"
#import <objc/message.h>

@interface RunTimeMessageViewController ()

@end

@implementation RunTimeMessageViewController

// RunTime 中消息应用

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.title = NSStringFromClass([self class]);
    
    Class getClass = objc_getClass("RunTimeMessageModel");
    NSLog(@"Get the class name is：%@", getClass);
    
    // XCode 会自动屏蔽通过objc_msgSend创建对象，我们可以去到工程里设置
    // Build Setting -> Enable Strict Checking of objc_msgSend Calls 改为NO就好了。
    RunTimeMessageModel *messageModel = objc_msgSend(getClass, @selector(alloc));
    NSLog(@"RunTimeMessageModel alloc:%@", messageModel);
    
    // 在不调用init方法，我们也可以通过发消息调用想用的方法，这里调用没有在.h文件里声明方法会警告该方法没有声明
    objc_msgSend(messageModel, @selector(cl_post));
    
    messageModel = objc_msgSend(messageModel, @selector(init));
    NSLog(@"RunTimeMessageModel init:%@", messageModel);
    
    objc_msgSend(messageModel, @selector(cl_post));
    
    // 还有另外一种写法，就是把所有的东西集合在一起，也就是我们常用的[[NSObject alloc] init];的原型
    RunTimeMessageModel *messageModel2 = objc_msgSend(objc_msgSend(objc_getClass("RunTimeMessageModel"), @selector(alloc)), @selector(init));
    objc_msgSend(messageModel2, @selector(cl_getWithCount:), 5);
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
