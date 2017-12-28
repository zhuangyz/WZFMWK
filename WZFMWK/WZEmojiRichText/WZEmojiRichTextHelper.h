//
//  WZRichTextHelper.h
//  WZFMWK
//
//  Created by Walker on 16/8/3.
//  Copyright © 2016年 wz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  富文本工具类
 *  该类主要用来：将带表情文本转换为富文本、计算富文本高度
 */
@interface WZEmojiRichTextHelper : NSObject

/**
 *  将带表情文本转换为富文本
 */
+ (NSAttributedString *)wz_emojiRichTextConvertedFrom:(NSString *)originText
                                           fontForText:(UIFont *)font;

/**
 *  求富文本高度
 *
 *  @param richText         富文本
 *  @param width            富文本欲显示的宽度
 *  @param configLabelBlock 使用这个block配置用来计算高度的label，参数label为已初始化过的label，通过设置该label的font等属性完善label的初始化，将该label再返回即可
 */
+ (CGFloat)wz_heightForRichText:(NSAttributedString *)richText
                       withWidth:(CGFloat)width
                        useLabel:(void(^)(UILabel *label))configLabelBlock;

+ (CGSize)wz_sizeForRichText:(NSAttributedString *)richText
                      maxSize:(CGSize)maxSize
                     useLabel:(void(^)(UILabel *))configLabelBlock;

@end
