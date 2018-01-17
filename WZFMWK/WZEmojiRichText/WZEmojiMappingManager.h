//
//  WZEmojiMappingManager.h
//  WZFMWK
//
//  Created by Walker on 16/8/3.
//  Copyright © 2016年 wz. All rights reserved.
//

#import <Foundation/Foundation.h>

//  表情的正则表达式
static NSString const *wz_emojiPatternString = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";

/**
 *  管理表情库的单例类
 */
NS_CLASS_DEPRECATED_IOS(2_0, 9_0, "这个类已经弃用！")
@interface WZEmojiMappingManager : NSObject

@property (nonatomic, readonly) NSDictionary *emojiMappings;

+ (instancetype)shareManager;

/**
 *  获取解析表情的正则表达式
 */
+ (NSRegularExpression *)regularExpressionForEmoji;

/**
 *  获取表情匹配结果集
 */
+ (NSArray *)matchEmojiResults:(NSString *)text;

// WZEmojiBundle 路径
+ (NSString *)emojiBundlePath;
+ (NSString *)resourcePathInEmojiBundleWith:(NSString *)resourceName;

@end

/**
 *  emojiMappings格式：
 *      {
            @"表情图片名" : @"表情名",
        }
 */


















