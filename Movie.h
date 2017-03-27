//
//  Movie.h
//  RuntimeDemo
//
//  Created by user on 2017/3/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

//如果想要当前类可以实现归档和反归档，需要遵守协议NSCoding
@interface Movie : NSObject<NSCoding>

@property (nonatomic, copy) NSString *movieId;
@property (nonatomic, copy) NSString *movieName;
@property (nonatomic, copy) NSString *pic_url;

@end
