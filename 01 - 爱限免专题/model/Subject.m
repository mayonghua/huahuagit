//
//  Subject.m
//  01 - 爱限免专题
//
//  Created by 马勇 on 15/3/19.
//  Copyright (c) 2015年 yong. All rights reserved.
//

#import "Subject.h"

@implementation Subject

@synthesize title = _title;
@synthesize date = _date;
@synthesize img = _img;
@synthesize desc_img = _desc_img;
@synthesize desc = _desc;
@synthesize apps = _apps;

//这个 方法的作用是通过 KVC 获取数据模型对象里面的某一个属性的值时 如果这个属性根本不存在 不重写下面的方法程序就会崩溃
- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

//这个方法的作用是字典里面的属性比数据模型里面的属性多时 就会调用这个方法 如果不重写就会崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"%@", key);
    NSLog(@"%@", value);
    
    if ([key isEqualToString:@"applications"]) {
        NSArray *values = (NSArray *)value;
        
        [value enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           
            
            
        }];
    }
}

//对象方法
- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {

        //全局变量  需要权限
        //开辟空间 以便往里面存储数据
        _apps = [[NSMutableArray alloc] initWithCapacity:0];
//        _apps = [[NSMutableArray arrayWithCapacity:0] retain];
        //KVC
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;
}

//工厂方法
+(Subject *)subjectWithDic:(NSDictionary *)dic {
    
    return [[[Subject alloc] initWithDic:dic] autorelease];
}

- (void)dealloc {
    
    [_title release];
    [_desc release];
    [_date release];
    [_desc_img release];
    [_apps release];
    [_img release];
    
    [super dealloc];
}


@end
