//
//  Subject.h
//  01 - 爱限免专题
//
//  Created by 马勇 on 15/3/19.
//  Copyright (c) 2015年 yong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subject : NSObject

//不可变的字符串 数组 字典 用 copy,retain 是等价的 都属于浅拷贝 只是大家习惯性用 copy
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *desc_img;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSArray *apps;

//对象方法
- (instancetype)initWithDic:(NSDictionary *)dic;

//工厂方法
+ (Subject *)subjectWithDic:(NSDictionary *)dic;

@end
