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

#endif /* WZUtilDefine_h */
