//
//  WZLocationManager.m
//  WZFMWK
//
//  Created by Walker on 2017/11/7.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "WZLocationManager.h"
#import <INTULocationManager/INTULocationManager.h>
#import <objc/runtime.h>

@interface WZLocationManager()

@property (nonatomic, assign, readwrite) float lat; // 纬度
@property (nonatomic, assign, readwrite) float lng; // 经度

@property (nonatomic, copy, readwrite) NSString *country; // 国
@property (nonatomic, copy, readwrite) NSString *state; // 省
@property (nonatomic, copy, readwrite) NSString *city; // 市
@property (nonatomic, copy, readwrite) NSString *county; // 区
@property (nonatomic, copy, readwrite) NSString *thoroughfare; // 街道
@property (nonatomic, copy, readwrite) NSString *subThoroughfare;

@property (nonatomic, strong) NSHashTable *observers;

@end

@implementation WZLocationManager

- (instancetype)init {
    if (self = [super init]) {
        NSDictionary *locationInfoCache = [[NSUserDefaults standardUserDefaults] objectForKey:@"wz_location_info"];
        if (!locationInfoCache) {
            // 默认地址设置到 高新园地铁站
            self.lat = 22.540121;
            self.lng = 113.955284;
            self.country = @"中国";
            self.state = @"广东省";
            self.city = @"深圳市";
            self.county = @"南山区";
            self.thoroughfare = @"深南大道";
            self.subThoroughfare = nil;
            
        } else {
            self.lat = [locationInfoCache[@"lat"] doubleValue];
            self.lng = [locationInfoCache[@"lng"] doubleValue];
            self.country = locationInfoCache[@"country"];
            self.state = locationInfoCache[@"state"];
            self.city = locationInfoCache[@"city"];
            self.county = locationInfoCache[@"county"];
            self.thoroughfare = locationInfoCache[@"thoroughfare"];
            self.subThoroughfare = locationInfoCache[@"subThoroughfare"];
        }
    }
    return self;
}

- (NSHashTable *)observers {
    if (!_observers) {
        _observers = [NSHashTable weakObjectsHashTable];
    }
    return _observers;
}

+ (instancetype)sharedInstance {
    static WZLocationManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[WZLocationManager alloc] init];
    });
    return manager;
}

- (void)startRequestLocation {
    [[INTULocationManager sharedInstance] subscribeToLocationUpdatesWithDesiredAccuracy:INTULocationAccuracyNeighborhood block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusSuccess) {
            [self updateToLocation:currentLocation];
            
        } else {
            NSLog(@"无法获取定位信息");
        }
    }];
}

- (void)updateToLocation:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error && placemarks.count > 0) {
            self.lat = location.coordinate.latitude;
            self.lng = location.coordinate.longitude;
            
            CLPlacemark *placemark = placemarks[0];
            self.country = placemark.country;
            self.state = placemark.administrativeArea;
            self.city = placemark.locality;
            self.county = placemark.subLocality;
            self.thoroughfare = placemark.thoroughfare;
            self.subThoroughfare = placemark.subThoroughfare;
            
            NSMutableDictionary *locationInfo = [NSMutableDictionary dictionary];
            locationInfo[@"lat"] = [NSString stringWithFormat:@"%.6f", self.lat];
            locationInfo[@"lng"] = [NSString stringWithFormat:@"%.6f", self.lng];
            [locationInfo setValue:self.country forKey:@"country"];
            [locationInfo setValue:self.state forKey:@"state"];
            [locationInfo setValue:self.city forKey:@"city"];
            [locationInfo setValue:self.county forKey:@"county"];
            [locationInfo setValue:self.thoroughfare forKey:@"thoroughfare"];
            [locationInfo setValue:self.subThoroughfare forKey:@"subThoroughfare"];
            [[NSUserDefaults standardUserDefaults] setObject:locationInfo forKey:@"wz_location_info"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [(id)self locationManagerDidUpdateLocationInfo:self];
#if DEBUG
            NSLog(@"%@", [self locationDescription]);
#endif
        }
    }];
}

#pragma mark 使用蹦床模式来实现多代理
- (void)addObserver:(id<WZLocationManagerDelegate>)observer {
    if (!observer) return;
    NSAssert([observer conformsToProtocol:@protocol(WZLocationManagerDelegate)], @"observer 必须实现 WZLocationManagerDelegate 协议");
    [self.observers addObject:observer];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *methodSignature = [super methodSignatureForSelector:aSelector];
    if (methodSignature) {
        return methodSignature;
    }
    
    struct objc_method_description methodDesc = protocol_getMethodDescription(@protocol(WZLocationManagerDelegate), aSelector, YES, YES);
    if (methodDesc.name == NULL) {
        methodDesc = protocol_getMethodDescription(@protocol(WZLocationManagerDelegate), aSelector, NO, YES);
    }
    if (methodDesc.name == NULL) {
        [self doesNotRecognizeSelector:aSelector];
        return nil;
    }
    
    return [NSMethodSignature signatureWithObjCTypes:methodDesc.types];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    for (id<WZLocationManagerDelegate> observer in self.observers) {
        [anInvocation setTarget:observer];
        [anInvocation invoke];
    }
}

- (NSString *)locationDescription {
    return [NSString stringWithFormat:@"当前详细地址：(lng %.6f, lat %.6f) %@%@%@%@%@%@", self.lng, self.lat, self.country, self.state, self.city, self.county, self.thoroughfare, self.subThoroughfare];
}

@end


















