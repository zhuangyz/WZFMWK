//
//  NSAttributedString+WZExtend.h
//  WZFMWK
//
//  Created by Walker on 2018/1/16.
//  Copyright © 2018年 wz. All rights reserved.
//

#import <UIKit/UIKit.h>

// MARK: - Size
@interface NSAttributedString (WZSize)

// 根据最大宽高求出当前富文本的宽高
- (CGSize)wz_sizeWithMaxSize:(CGSize)maxSize
                    useLabel:(void(^)(UILabel *))configLabelBlock;

// 根据最大宽度求出当前富文本的高度
- (CGFloat)wz_sizeWithWidth:(CGFloat)width
                   useLabel:(void(^)(UILabel *))configLabelBlock;

@end
