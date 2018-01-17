//
//  NSAttributedString+WZExtend.m
//  WZFMWK
//
//  Created by Walker on 2018/1/16.
//  Copyright © 2018年 wz. All rights reserved.
//

#import "NSAttributedString+WZExtend.h"

@implementation NSAttributedString (WZSize)

- (CGFloat)wz_sizeWithWidth:(CGFloat)width useLabel:(void (^)(UILabel *))configLabelBlock {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:17];
    
    if (configLabelBlock) {
        configLabelBlock(label);
    }
    
    label.attributedText = self;
    CGSize textSize = [label sizeThatFits:CGSizeMake(width, 0)];
    
    return textSize.height == 0 ? 0 : (textSize.height + 1);//计算出来的高度不够显示所有文本（包含表情的时候），加上1之后就可以了（wtf！why？）
}

- (CGSize)wz_sizeWithMaxSize:(CGSize)maxSize useLabel:(void (^)(UILabel *))configLabelBlock {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:17];
    
    if (configLabelBlock) {
        configLabelBlock(label);
    }
    
    label.attributedText = self;
    CGSize textSize = [label sizeThatFits:maxSize];
    textSize.width += 1;
    textSize.height += 1;
    return textSize;
}

@end
