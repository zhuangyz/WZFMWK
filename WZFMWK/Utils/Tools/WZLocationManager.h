//
//  WZLocationManager.h
//  WZFMWK
//
//  Created by Walker on 2017/11/7.
//  Copyright © 2017年 wz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WZLocationStatus) {
    WZLocationStatusSuccess,                // 位置请求成功
    WZLocationStatusTimedOut,               // 请求超时
    WZLocationStatusServicesNotDetermined,  // 用户还未对位置权限请求做出选择
    WZLocationStatusServicesDenied,         // 用户拒绝授予位置权限
    WZLocationStatusServicesRestricted,     // 用户没有权利授权，比如在家长控制模式下
    WZLocationStatusServicesDisabled,       // 用户在设置 app 中关闭定位功能
    WZLocationStatusError,                  // 使用系统定位功能时出现错误
};

@class WZLocationManager;
@protocol WZLocationManagerDelegate <NSObject>

- (void)locationManagerDidUpdateLocationInfo:(WZLocationManager *)manager;

@end

@interface WZLocationManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, readonly) WZLocationStatus locationStatus;
- (void)startRequestLocation;
- (void)stopRequestLocation;

// 定位失败的时候，所有定位信息都是零值
@property (nonatomic, readonly) float lat; // 纬度
@property (nonatomic, readonly) float lng; // 经度
@property (nonatomic, readonly) NSString *country; // 国，可能为nil
@property (nonatomic, readonly) NSString *state; // 省/直辖市，可能为nil
@property (nonatomic, readonly) NSString *city; // 市，可能为nil（直辖市的 city 也为 nil）
@property (nonatomic, readonly) NSString *county; // 区，可能为nil
@property (nonatomic, readonly) NSString *thoroughfare; // 街道，可能为nil
@property (nonatomic, readonly) NSString *subThoroughfare;

- (void)addObserver:(id<WZLocationManagerDelegate>)observer;

- (NSString *)locationDescription;

@end
















