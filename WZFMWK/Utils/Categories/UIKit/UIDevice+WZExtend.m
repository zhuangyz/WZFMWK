//
//  UIDevice+WZDeviceInfo.m
//  WZFMWK
//
//  Created by Walker on 2017/11/23.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "UIDevice+WZExtend.h"
#include <sys/sysctl.h>

// MARK: - 设备信息
@implementation UIDevice (WZDeviceInfo)

+ (NSString *)wz_identifier {
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *identifier = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return identifier;
}

+ (NSString *)wz_modelName {
    NSString *identifier = [self wz_identifier];
    // 手机型号最新设备型号对照表(持续更新的)：https://www.theiphonewiki.com/wiki/Models
    if ([identifier isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([identifier isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([identifier isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([identifier isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([identifier isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (Rev. A)";
    if ([identifier isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([identifier isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([identifier isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([identifier isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (CDMA)";
    if ([identifier isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([identifier isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (Global)";
    if ([identifier isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([identifier isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (Global)";
    if ([identifier isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([identifier isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([identifier isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([identifier isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([identifier isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([identifier isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([identifier isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([identifier isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([identifier isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([identifier isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([identifier isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([identifier isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([identifier isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([identifier isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([identifier isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    // iPod
    if ([identifier isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([identifier isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([identifier isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([identifier isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([identifier isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([identifier isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
    // iPad
    if ([identifier isEqualToString:@"iPad1,1"])      return @"iPad 1";
    if ([identifier isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([identifier isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([identifier isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([identifier isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([identifier isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([identifier isEqualToString:@"iPad3,2"])      return @"iPad 3 (CDMA)";
    if ([identifier isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([identifier isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([identifier isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([identifier isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    if ([identifier isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([identifier isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([identifier isEqualToString:@"iPad4,3"])      return @"iPad Air (China)";
    if ([identifier isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
    if ([identifier isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    // iPad mini
    if ([identifier isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([identifier isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([identifier isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    if ([identifier isEqualToString:@"iPad4,4"])      return @"iPad mini 2 (WiFi)";
    if ([identifier isEqualToString:@"iPad4,5"])      return @"iPad mini 2 (Cellular)";
    if ([identifier isEqualToString:@"iPad4,6"])      return @"iPad mini 2 (China)";
    if ([identifier isEqualToString:@"iPad4,7"])      return @"iPad mini 3 (WiFi)";
    if ([identifier isEqualToString:@"iPad4,8"])      return @"iPad mini 3 (Cellular)";
    if ([identifier isEqualToString:@"iPad4,9"])      return @"iPad mini 3 (China)";
    if ([identifier isEqualToString:@"iPad5,1"])      return @"iPad mini 4 (WiFi)";
    if ([identifier isEqualToString:@"iPad5,2"])      return @"iPad mini 4 (Cellular)";
    // iPad Pro 9.7
    if ([identifier isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7 (WiFi)";
    if ([identifier isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7 (Cellular)";
    // iPad Pro 12.9
    if ([identifier isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9 (WiFi)";
    if ([identifier isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9 (Cellular)";
    if ([identifier isEqualToString:@"iPad7,1"])      return @"iPad Pro 12.9 2nd Generation (WiFi)";
    if ([identifier isEqualToString:@"iPad7,2"])      return @"iPad Pro 12.9 2nd Generation (Cellular)";
    // Apple TV
    if ([identifier isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2G";
    if ([identifier isEqualToString:@"AppleTV3,1"])   return @"Apple TV 3G";
    if ([identifier isEqualToString:@"AppleTV3,2"])   return @"Apple TV 3G";
    if ([identifier isEqualToString:@"AppleTV5,3"])   return @"Apple TV 4G";
    // Apple Watch
    if ([identifier isEqualToString:@"Watch1,1"])     return @"Apple Watch 38mm";
    if ([identifier isEqualToString:@"Watch1,2"])     return @"Apple Watch 42mm";
    // Simulator
    if ([identifier isEqualToString:@"i386"])         return @"Simulator";
    if ([identifier isEqualToString:@"x86_64"])       return @"Simulator";
    
    return identifier;
}

@end
