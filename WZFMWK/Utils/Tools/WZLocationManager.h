//
//  WZLocationManager.h
//  WZFMWK
//
//  Created by Walker on 2017/11/7.
//  Copyright © 2017年 wz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WZLocationManager;
@protocol WZLocationManagerDelegate <NSObject>

- (void)locationManagerDidUpdateLocationInfo:(WZLocationManager *)manager;

@end

@interface WZLocationManager : NSObject

+ (instancetype)sharedInstance;

- (void)startRequestLocation;

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
















