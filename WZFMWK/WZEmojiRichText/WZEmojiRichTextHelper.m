//
//  WZRichTextHelper.m
//  WZFMWK
//
//  Created by Walker on 16/8/3.
//  Copyright © 2016年 wz. All rights reserved.
//

#import "WZEmojiRichTextHelper.h"
#import "WZEmojiMappingManager.h"

@implementation WZEmojiRichTextHelper

+ (NSAttributedString *)wz_emojiRichTextConvertedFrom:(NSString *)originText
                                           fontForText:(UIFont *)font {
    NSMutableAttributedString *conventedText = [[NSMutableAttributedString alloc] initWithString:originText];
    
    //根据正则表达式匹配到的所有表情字符串
    NSArray *matchResults = [WZEmojiMappingManager matchEmojiResults:originText];
    
    //保存表情的图片和表情在文本中的位置
    NSMutableArray *emojiImgArray = [NSMutableArray arrayWithCapacity:matchResults.count];
    
    NSDictionary *emojiMappings = [WZEmojiMappingManager shareManager].emojiMappings;
    
    for (NSTextCheckingResult *matchResult in matchResults) {
        //表情在文本中的位置（起始点，长度）
        NSRange emojiStrRange = [matchResult range];
        
        //从originText中根据表情的位置获取表情的文本表示
        NSString *emojiStr = [originText substringWithRange:emojiStrRange];
        
        for (NSString *emojiImgName in emojiMappings.allKeys) {
            //获取表情的文本表示
            NSString *emojiName = [emojiMappings objectForKey:emojiImgName];
            
            //如果两个文本表示相匹配，即同一个表情，那么就根据表情的图片生成一个附件，然后将附件转换成NSAttributedString并保存
            if ([emojiName isEqualToString:emojiStr]) {
                //创建一个附件，用以保存表情图片
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                //表情的大小
                textAttachment.bounds = CGRectMake(0, -3, font.pointSize + 3, font.pointSize + 3);
                textAttachment.image = [self emojiImageWithName:emojiImgName];
                
                //将附件转换成文本框可以表示的一种文本
                NSAttributedString *emojiAttributedStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                
                //将表情的文本位置和文本保存在一个字典里，并将字典保存到emojiImgArray
                NSDictionary *emojiImgDict = @{
                                               @"emojiImg":emojiAttributedStr,
                                               @"emojiRange":[NSValue valueWithRange:emojiStrRange],
                                               };
                [emojiImgArray addObject:emojiImgDict];
                break;
            }
        }
    }
    
    //倒序地将表情的文本表示替换成attributedText
    //如果有多个表情图，必须从后往前替换，因为替换后Range就不准确了
    for (int i=(int)emojiImgArray.count - 1; i>= 0; i--) {
        NSDictionary *emojiImgDict = emojiImgArray[i];
        NSRange emojiRange;
        [emojiImgDict[@"emojiRange"] getValue:&emojiRange];
        NSAttributedString *emojiAttributedStr = emojiImgDict[@"emojiImg"];
        
        [conventedText replaceCharactersInRange:emojiRange withAttributedString:emojiAttributedStr];
    }
    
    return conventedText;
}

+ (CGFloat)wz_heightForRichText:(NSAttributedString *)richText
                       withWidth:(CGFloat)width
                        useLabel:(void(^)(UILabel *))configLabelBlock {
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:17];
    
    if (configLabelBlock) {
        configLabelBlock(label);
    }
    
    label.attributedText = richText;
    CGSize textSize = [label sizeThatFits:CGSizeMake(width, 0)];
    
    return textSize.height == 0 ? 0 : (textSize.height + 1);//计算出来的高度不够显示所有文本（包含表情的时候），加上1之后就可以了（wtf！why？）
}

+ (CGSize)wz_sizeForRichText:(NSAttributedString *)richText
                      maxSize:(CGSize)maxSize
                     useLabel:(void(^)(UILabel *))configLabelBlock {
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:17];
    
    if (configLabelBlock) {
        configLabelBlock(label);
    }
    
    label.attributedText = richText;
    CGSize textSize = [label sizeThatFits:maxSize];
    textSize.width += 1;
    textSize.height += 1;
    return textSize;
}

+ (UIImage *)emojiImageWithName:(NSString *)name {
    return [UIImage imageWithContentsOfFile:[WZEmojiMappingManager resourcePathInEmojiBundleWith:name]];
}

@end

























