//
//  WZEmojiMappingManager.m
//  WZFMWK
//
//  Created by Walker on 16/8/3.
//  Copyright © 2016年 wz. All rights reserved.
//

#import "WZEmojiMappingManager.h"

@interface WZEmojiMappingManager ()

@property (nonatomic, strong, readwrite) NSDictionary *emojiMappings;

@end

@implementation WZEmojiMappingManager

+ (instancetype)shareManager {
    static WZEmojiMappingManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[WZEmojiMappingManager alloc] init];
        manager.emojiMappings = [NSDictionary dictionaryWithContentsOfFile:[self resourcePathInEmojiBundleWith:@"faceMap_ch.plist"]];
        NSAssert(manager.emojiMappings != nil, @"faceMap_ch.plist不存在！");
    });
    return manager;
}

//  获取解析表情的正则表达式
+ (NSRegularExpression *)regularExpressionForEmoji {
    NSError *error = nil;
    NSRegularExpression *regExpression = [NSRegularExpression regularExpressionWithPattern:wz_emojiPatternString.copy options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSAssert(regExpression != nil, @"%@", [error localizedDescription]);
    
    return regExpression;
}

//  获取表情匹配结果集
+ (NSArray *)matchEmojiResults:(NSString *)text {
    NSRegularExpression *regular = [[self class] regularExpressionForEmoji];
    //self.text根据正则表达式匹配到的所有表情字符串
    NSArray *matchResults = [regular matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    return matchResults;
}

// WZEmojiBundle 路径
+ (NSString *)emojiBundlePath {
    static NSString *path = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSBundle *bundle = [NSBundle bundleForClass:[WZEmojiMappingManager class]];
        path = [bundle pathForResource:@"WZEmojiBundle" ofType:@"bundle"];
    });
    return path;
}

+ (NSString *)resourcePathInEmojiBundleWith:(NSString *)resourceName {
    return [[self emojiBundlePath] stringByAppendingPathComponent:resourceName];
}

@end
