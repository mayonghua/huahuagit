//
//  HttpManager.m
//  01 - 爱限免专题
//
//  Created by 马勇 on 15/3/19.
//  Copyright (c) 2015年 yong. All rights reserved.
//

#import "HttpManager.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"   

/*
 ASIHTTPRequest : NSOperation
 ASIHTTPRequest继承自NSOperation, 当我们用NSOperation 这个类或者是他的子类创建一个对象是 会自动创建一个"分线程"
 你现在先这么理解 整个工程里面有一个"主线程"
 
 ASINetworkQueue : NSOperationQueue
 
 ASINetworkQueue 继承自 NSOperationQueue, 当我们创建一个 NSOperationQueue 对象时 就是创建了一个队列 我们可以将NSOperation或者他的子类创建的对象[分线程] 添加到NSOperationQueue 创建的队列里面去由NSOperationQueue 创建的队列取调度 [给每一个分线程分配时间片] 管理.


 
 */
@interface HttpManager ()

//队列 管理分线程的调度工作
@property (nonatomic, retain) ASINetworkQueue *netWorkQueue;

@end


static HttpManager *httpManager = nil;
@implementation HttpManager
@synthesize netWorkQueue = _netWorkQueue;
@synthesize delegate = _delegate;


- (void)dealloc {
    
    //不是对象 需要滞空
    _delegate = nil;
    
    [_netWorkQueue release];
    
    [super dealloc];
}

+ (HttpManager *)sharedHttpManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
//        httpManager = [[HttpManager alloc] init];
//        httpManager = [[HttpManager allocWithZone:NULL] init];
//        httpManager = [[self alloc] init];
//        httpManager = [[self allocWithZone:NULL] init];
        
        //以后只要记住下面这中写法就 OK
        httpManager = [[super allocWithZone:NULL] init];
    });
    
    return httpManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //创建_netWorkQueue对象
        _netWorkQueue = [[ASINetworkQueue alloc] init];

        //设置代理
        _netWorkQueue.delegate = self;
        
        //设置队列里面某一个线程开始下载数据时回调的方法
        [self.netWorkQueue setRequestDidStartSelector:@selector(requestDidStart:)];
        
        //设置队列里面的某一个线程数据下载成功时回调的方法
        [self.netWorkQueue setRequestDidFinishSelector:@selector(requestDidFinish)];
        
        
        //设置队列里面的某一个线程数据下载失败时回调的方法
        [self.netWorkQueue setRequestDidFailSelector:@selector(requestDidFail)];
        
        //设置队列里面的所有线程的任务完成时回调的方法
        [self.netWorkQueue setQueueDidFinishSelector:@selector(queueDidFinish)];
        
        //启动队列, 只有启动队列 我们往队列里面添加线程时 队列才会对添加进来的线程进行调度
        [self start];
        
        
    }
    return self;
}

#pragma mark --数据请求时访问的方法
/**
 *  下载专题页面数据
 *
 *  @param page 第几页
 */
- (void)getSubjectData:(NSInteger)page {
    //路径拼接
    NSString *path = [NSString stringWithFormat:SUBJECT_URL,page];
    //    将路径转换成URL
    NSURL *url = [NSURL URLWithString:path];
    //    创建线程
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    //    设置userInfo属性
//    [self setGetMethod:request and:ENUM_SubjectType];
    
    //    将线程添加到队列里面
    [self.netWorkQueue addOperation:request];
    
    [request release];

}


#pragma mark -- 对调方法
//队列里面的线程开始下载数据时的回调方法
- (void)requestDidStart:(ASIHTTPRequest *)request {
    
}

//队列里面的线程成功下砸数据时的回调方法
- (void)requestDidFinish:(ASIHTTPRequest *)request {
    //下载完成的 json 数据
    NSString *result = [request responseString];
    
    //获取到二进制数据
    NSData *data = [request responseData];
    
    //json 解析
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //创建一个可变的数组, 装数据模型
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    
    //便利数组创建模型数据
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        
        Subject *sb = [Subject subjectWithDic:obj];
        [mutableArray addObject:sb];
        
    }];
    
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didGetSubjectData:)]) {
        [self.delegate didGetSubjectData:result];
    }
    
    
    
}

//队列里面的线程数据下载失败时的回调方法
- (void)requestDidFail:(ASIHTTPRequest *)request {
    
}

// 队列里面的线程的所有方法完成时候的回调方法
- (void)queueDidFinish:(ASINetworkQueue *)networkQueue {
    
}

#pragma mark -- Operate queue
//判断 self.netWorkQueue 时候处于运行状态
- (BOOL)isRunning {
    return ![self.netWorkQueue isSuspended];
}

//启动队列
- (void)start {
    if ([self.netWorkQueue isSuspended]) {
        [self.netWorkQueue go];
    }
}

//停止
- (void)pause {
    [self.netWorkQueue setSuspended:YES];
}

//重新开始
- (void)resume {
    [self.netWorkQueue setSuspended:NO];
}

//取消队列里面所有的线程
- (void)cancel {
    [self.netWorkQueue cancelAllOperations];
}

@end
