//
//  WZBaseListAPI.h
//  WZFMWK
//
//  Created by Walker on 2017/6/15.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "WZBaseAPIManager.h"

@class WZBaseListAPIManager;
@protocol WZListAPIManagerParamSource <NSObject>

@required
- (NSDictionary *)paramsForRequestNewData:(WZBaseListAPIManager *)manager;
- (NSDictionary *)paramsForRequestMoreData:(WZBaseListAPIManager *)manager;

@optional
- (id)contextForRequestNewData:(WZBaseListAPIManager *)manager;
- (id)contextForRequestMoreData:(WZBaseListAPIManager *)manager;

@end

@protocol WZListAPIManagerDelegate <NSObject>

@optional
- (void)manager:(WZBaseListAPIManager *)manager requestNewDataDidSuccess:(WZAPISuccessResponse *)response;
- (void)manager:(WZBaseListAPIManager *)manager requestNewDataDidFailed:(WZAPIFailResponse *)response;

- (void)manager:(WZBaseListAPIManager *)manager requestMoreDataDidSuccess:(WZAPISuccessResponse *)response;
- (void)manager:(WZBaseListAPIManager *)manager requestMoreDataDidFailed:(WZAPIFailResponse *)response;

@end

@interface WZBaseListAPIManager : WZBaseAPIManager <WZAPIManagerConfig, WZAPIManagerParamSource, WZAPIManagerCallBackDelegate>

// 参数源，取代 WZBaseAPIManager 的 paramSource，请确保这个属性有值
@property (nonatomic, weak) id<WZListAPIManagerParamSource> listParamSource;
// 回调，取代 WZBaseAPIManager 的 delegate
@property (nonatomic, weak) id<WZListAPIManagerDelegate> listDelegate;

- (void)loadFirstPage;
- (void)loadNextPage;

@end



























