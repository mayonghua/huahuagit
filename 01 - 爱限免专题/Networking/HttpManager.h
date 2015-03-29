//
//  HttpManager.h
//  01 - 爱限免专题
//
//  Created by 马勇 on 15/3/19.
//  Copyright (c) 2015年 yong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Subject.h"

//专题页面数据访问的接口
#define SUBJECT_URL @"http://iappfree.candou.com:8080/free/special?page=%d&limit=5"

//委托 代理
@protocol HTTPManagerDelegate <NSObject>

//专题页面数据下载成功时回调的方法
//网络模块数据下载完成以后需要通过委托将数据会调到控制器, 控制器再告诉 V刷新视图
- (void)didGetSubjectData:(id)object;

@end

@interface HttpManager : NSObject

/**
 *  网络类的代理属性
 */
@property (nonatomic, assign) id<HTTPManagerDelegate>delegate;

//单例
+ (HttpManager *)sharedHttpManager;

#pragma mark --数据请求时访问的方法
/**
 *  专题页面数据访问的方法
 *
 *  @param page 第几页
 */
- (void)getSubjectData:(NSInteger)page;

#pragma mark --
- (BOOL)isRunning;

- (void)start;

- (void)pause;

- (void)resume;

- (void)cancel;
@end
