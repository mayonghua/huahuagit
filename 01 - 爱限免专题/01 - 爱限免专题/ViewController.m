//
//  ViewController.m
//  01 - 爱限免专题
//
//  Created by 马勇 on 15/3/19.
//  Copyright (c) 2015年 yong. All rights reserved.
//

#import "ViewController.h"
#import "HttpManager.h"

@interface ViewController () <HTTPManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //获取网络类的单例对象
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    
    //设置代理
    httpManager.delegate = self;
    
    //通过单例对象下载数据
    [httpManager getSubjectData:1];
}

#pragma mark -- HTTPManagerDelegate
//网络模块数据下载完成时的回调方法
- (void)didGetSubjectData:(id)object {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
