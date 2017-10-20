//
//  RunTimeDataModel.h
//  RuntimeDemo
//
//  Created by user on 2017/10/20.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunTimeDataListModel : NSObject

@property (nonatomic, retain) NSString *info;

@end

@interface RunTimeDataModel : NSObject

@property (nonatomic, retain) NSString *age;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *data;

@end
