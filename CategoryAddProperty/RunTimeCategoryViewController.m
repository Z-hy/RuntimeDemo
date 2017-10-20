//
//  RunTimeCategoryViewController.m
//  RuntimeDemo
//
//  Created by user on 2017/10/20.
//  Copyright © 2017年 user. All rights reserved.
//

#import "RunTimeCategoryViewController.h"
#import "NSObject+CLObject.h"

@interface RunTimeCategoryViewController ()

@end

@implementation RunTimeCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSStringFromClass([self class]);
    
    NSObject *objc = [[NSObject alloc] init];
    objc.categoryName = @"NSObject+CLObject";
    NSLog(@"---%@", objc.categoryName);
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
