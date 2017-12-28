//
//  WZBaseAPIManager1.h
//  WZFMWK
//
//  Created by Walker on 2017/5/17.
//  Copyright © 2017年 wz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZOriginResponse.h"
#import "WZNetworkingDefine.h"
#import "WZAPIResponse.h"
#import "NSURLRequest+WZParam.h"

@class WZBaseAPIManager;

#pragma mark - WZAPIManagerConfig
// 提供接口的基本信息，子类必须实现该协议！
@protocol WZAPIManagerConfig <NSObject>

@required
- (NSString *)serviceBaseURL; // 例如 http://112.74.16.180:8694/v9
- (NSString *)serviceName; // 例如 user/detail
- (WZRequestMethod)requestMethod;
/*
 服务的描述，虽然这个方法对请求的发起落地过程都是不必要的，
 但是出于维护的考虑，子类必须实现该方法，说明这个服务的功能（至少包括接口号、接口名等，例如@"3.5 帖子详情"）
 */
- (NSString *)serviceDescription;

@optional
/*
 子类可通过实现该方法，来额外添加一些业务相关性不大的参数，也可以修改参数值等
 但是要注意的是，这个方法是透明的，外部不清楚参数是否经过修改，所以对于修改参数这方面要慎重！！
 另外，和WZAPIManagerParamSource协议的-paramsForAPIManager:方法的说明一样，注意保证参数的来源的位置一致！
 */
- (NSDictionary *)reformParams:(NSDictionary *)params;

@end


#pragma mark - WZAPIManagerCallBackDelegate
@protocol WZAPIManagerCallBackDelegate <NSObject>

/*
 请求回调并解析之后的回调，成功和失败的response是不一样的！！！
 */
@optional
- (void)manager:(WZBaseAPIManager *)manager callAPIDidSuccess:(WZAPISuccessResponse *)response;
- (void)manager:(WZBaseAPIManager *)manager callAPIDidFailed:(WZAPIFailResponse *)response;

@end


#pragma mark - WZAPIManagerParamSource
@protocol WZAPIManagerParamSource <NSObject>

@required
/*
 提供参数给APIManager，发起请求时会调用。
 虽然APIManager子类可以通过-reformParams:来添加或操作参数，
 但是建议实现了-reformParams:方法的APIManager，同时作为它自己的paramSource并实现该协议，
 保证参数的来源的位置比较统一，方便调试！！！
 */
- (NSDictionary *)paramsForAPIManager:(WZBaseAPIManager *)manager;

@end


#pragma mark - WZAPIMangerInterceptor
// 拦截器的功能很强大，能做额外很多事情。但是如果处理不当，会引发很多bug（主要在回调到vc方面）。
@protocol WZAPIManagerInterceptor <NSObject>

@optional
/*
 请求发起的拦截器，可根据params判断是否允许请求起飞，也可根据不同的请求策略来判断请求是否可以起飞。
 对于同一个API，它已经有一个请求发出并且还未落地，此时如果再次发起请求，这时有两种起飞策略：
 1. 取消前一个请求，发起第二个请求：这时可以在这里调用-cancelAllRequests方法来取消前一个请求，并且该方法return YES;这样既可实现；
 2. 等待第一个请求，终止第二个请求：这时return NO;既可。
 */
- (BOOL)manager:(WZBaseAPIManager *)manager shouldCallAPIWithParams:(NSDictionary *)params error:(WZRequestErrorObject **)error;
// 成功发起新请求之后的回调
- (void)manager:(WZBaseAPIManager *)manager afterCallAPIWithParams:(NSDictionary *)params;

/*
 “执行成功请求的回调”的拦截器，可根据response来判断是否应该执行回调，return YES将可以执行回调，return NO则不执行
 */
- (BOOL)manager:(WZBaseAPIManager *)manager shouldPerformSuccessWithResponse:(WZAPISuccessResponse *)response;
- (void)manager:(WZBaseAPIManager *)manager afterPerformSuccessWithResponse:(WZAPISuccessResponse *)response;

/*
 同上
 */
- (BOOL)manager:(WZBaseAPIManager *)manager shouldPerformFailWithResponse:(WZAPIFailResponse *)response;
- (void)manager:(WZBaseAPIManager *)manager afterPerformFailWithResponse:(WZAPIFailResponse *)response;

@end


#pragma mark - WZBaseAPIManager
@interface WZBaseAPIManager : NSObject

@property (nonatomic, weak) id<WZAPIManagerConfig> child; // 子类必须实现WZAPIManagerConfig协议
@property (nonatomic, weak) id<WZAPIManagerParamSource> paramSource;
@property (nonatomic, weak) id<WZAPIManagerCallBackDelegate> delegate;
@property (nonatomic, weak) id<WZAPIManagerInterceptor> interceptor;

@property (nonatomic, readonly) BOOL isLoading;

#pragma mark 请求起飞和取消
- (NSInteger)loadData;
// 尝试发起请求，并附加上调用和回调上下文相关的信息，这个信息可以从response.context获取
- (NSInteger)loadDataWithContext:(id)context;

- (void)cancelAllRequests;
- (void)cancelRequestWithRequestID:(NSInteger)requestID;

#pragma mark 请求落地回调
// 成功得到服务器响应，子类一般不需要用到这两个方法
- (void)successOnCallingAPI:(WZOriginResponse *)response;
// 无法得到服务器响应
- (void)failOnCallingAPI:(WZOriginResponse *)response;

/*
 从服务器返回的 responseContent 字典中提取出数据字段的内容，子类根据项目要求重写该方法，返回值不能为 nil。
 比如圣卫士项目的原始数据结构为 {"status":1, "code":0, data:{实际有用的数据}}
 那么子类重写该方法为 return originResponseContent[@"data"]
 */
- (NSDictionary *)extractResponseContentFromOriginResponseContent:(NSDictionary *)originResponseContent;

#pragma mark 执行回调
// 执行回调，但因为有拦截器的存在，所以不一定能回调成功，子类可以调用，但是不要重写！！！
- (void)tryPerformSuccessCallBack:(WZAPISuccessResponse *)response;
- (void)tryPerformFailCallBack:(WZAPIFailResponse *)response;

#pragma mark 验证器
/*
 验证请求参数是否正确。
 如果返回NO意味着参数有问题，error的code应当是kRequestErrorCodeParamError，msg则是具体的参数错误的信息；
 而这个实现一般是由子类来实现的，BaseAPIManager只简单地返回YES，子类可以重写该方法来实现参数检查；
 当然，子类也可以通过实现WZAPIManagerInterceptor的-manager:shouldCallAPIWithParams:方法来实现这个检查参数的功能，但要记得在这里实现的话，检查到参数错误时，要创建一个error并通过-tryPerformFailCallBack:方法将错误回调出去，虽然这个回调的步骤不是必须的。
 */
- (BOOL)isCorrectWithParams:(NSDictionary *)params
                      error:(WZRequestErrorObject **)error;

/*
 验证服务器反馈的数据是否意味着请求成功。这里只是简单的返回 YES，不同项目请求结果的结构可能不同，所以必要时，需要在子类中重写这个方法。
 */
- (BOOL)isCorrectWithCallBackData:(WZOriginResponse *)response
                            error:(WZRequestErrorObject **)error;

#pragma mark 拦截器
/*
 对请求和回调的拦截，子类重写的时候记得调用super或者手动执行WZAPIManagerInterceptor代理方法，保证拦截器代理能够正确执行
 */
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params error:(WZRequestErrorObject **)error;
- (void)afterCallAPIWithParams:(NSDictionary *)params;

- (BOOL)shouldPerformSuccessWithResponse:(WZAPISuccessResponse *)response;
- (void)afterPerformSuccessWithResponse:(WZAPISuccessResponse *)response;

- (BOOL)shouldPerformFailWithResponse:(WZAPIFailResponse *)response;
- (void)afterPerformFailWithResponse:(WZAPIFailResponse *)response;

// 当请求被取消时，有些情况需要将取消的信息传递出去，但是大部分情况下是不需要的，所以默认return NO
// 需要反馈取消操作的时候（例如列表下拉刷新和上拉加载更多是互斥的，这时候取消其中一个的时候需要刷新界面的刷新状态），return YES 即可。
- (BOOL)shouldPerformCancelledRequestsResponse:(WZOriginResponse *)response;

@end




























