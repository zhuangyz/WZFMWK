//
//  WZUtilDefine.h
//  WZFMWK
//
//  Created by Walker on 2017/12/15.
//  Copyright © 2017年 wz. All rights reserved.
//

#ifndef WZUtilDefine_h
#define WZUtilDefine_h

#ifdef DEBUG
#define WZLog(...) NSLog(__VA_ARGS__)
#else
#define WZLog(...)
#endif

// 因为大量使用，所以从 QMKit 那里抄过来了
// 使用文件名(不带后缀名，仅限png)创建一个UIImage对象，不会被系统缓存，用于不被复用的图片，特别是大图
#define WZImageMakeWithFile(name) WZImageMakeWithFileAndSuffix(name, @"png")
#define WZImageMakeWithFileAndSuffix(name, suffix) [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", [[NSBundle mainBundle] resourcePath], name, suffix]]

#define WZFormatString(...) [NSString stringWithFormat:__VA_ARGS__]

#define wz_dispatch_main_async_safe(block)\
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }

#endif /* WZUtilDefine_h */
