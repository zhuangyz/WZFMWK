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

// 根据最大宽高求出当前富文本的宽高，宽高传0代表不限制
- (CGSize)wz_sizeWithMaxSize:(CGSize)maxSize
                    useLabel:(void(^)(UILabel *))configLabelBlock;

@end

// MARK: - NSString(WZAttributedString)
@interface NSString (WZAttributedString)

- (NSAttributedString *)attributedString;
- (NSMutableAttributedString *)mutableAttributedString;

@end

// MARK: - WZAttributesBuilder
// 文字书写方向，详细:[NSWritingDirectionAttributeName](https://developer.apple.com/documentation/uikit/nswritingdirectionattributename)
typedef NS_ENUM(NSUInteger, WZAttributedWriteDirection) {
    WZAttributedWriteDirectionNone, // 默认方向
    WZAttributedWriteDirectionLRE, // Left to Right, Embed
    WZAttributedWriteDirectionRLE, // Right to Left, Embed
    WZAttributedWriteDirectionLRO, // Left to Right, Override
    WZAttributedWriteDirectionRLO, // Right to Left, Override
};

@interface WZAttributesBuilder : NSObject

@property (nonatomic, strong) UIFont *font;                     // 字体，默认 nil
@property (nonatomic, copy)   NSParagraphStyle *paragraphStyle; // 段落风格，默认 nil
@property (nonatomic, strong) UIColor *foregroundColor;         // 前景色（字体颜色），默认 nil
@property (nonatomic, strong) UIColor *backgroundColor;         // 背景色，默认 nil
@property (nonatomic, assign) BOOL ligature;                 // 是否连字，默认 NO
@property (nonatomic, strong) NSNumber *kern;                   // 字符间距，默认 nil
@property (nonatomic, assign) NSUnderlineStyle strikethroughStyle;  // 删除线样式，默认 NSUnderlineStyleNone，没有删除线
@property (nonatomic, strong) UIColor *strikethroughColor;      // 删除线颜色，默认 nil
@property (nonatomic, assign) NSUnderlineStyle underlineStyle;  // 下划线样式，同删除线
@property (nonatomic, strong) UIColor *underlineColor;          // 下划线颜色，默认 nil
@property (nonatomic, strong) NSNumber *strokeWidth;            // 笔画宽度，默认 nil
@property (nonatomic, strong) UIColor *strokeColor;             // 笔画颜色，默认 nil
@property (nonatomic, strong) NSShadow *shadow;                 // 阴影样式，默认为 nil
@property (nonatomic, strong) NSTextEffectStyle textEffectStyle;// 特殊效果，默认为 nil
@property (nonatomic, strong) NSTextAttachment *attachment;     // 附件，默认 nil
@property (nonatomic, strong) NSURL *link;                      // 链接属性，默认为 nil
@property (nonatomic, strong) NSNumber *baselineOffset;         // 基线偏移量，默认 nil，正值上偏，负值下偏
@property (nonatomic, strong) NSNumber *obliqueness;            // 字体倾斜量，默认 nil，正值右倾，负值左倾
@property (nonatomic, strong) NSNumber *expansion;              // 字体的横向拉伸，默认 nil，正值拉伸，负值压缩
@property (nonatomic, assign) WZAttributedWriteDirection writeDirection;    // 文字书写方向，默认 WZAttributedWriteDirectionNone

- (NSDictionary<NSAttributedStringKey, id> *)attributes;

@end

// MARK: - Attributed String
typedef void(^WZBuildAttributesBlock)(WZAttributesBuilder *builder);
typedef NSAttributedString *(^WZAttributesBlock)(WZBuildAttributesBlock buildAttributes);
// MARK: WZAttributeRange
@interface WZAttributeRange : NSObject

- (instancetype)initWithAttributedString:(NSAttributedString *)attrStr range:(NSRange)range;

@property (nonatomic, readonly) WZAttributesBlock attributes;

@end

typedef WZAttributeRange *(^WZAttributeRangeBlock)(NSUInteger loc, NSUInteger len);
typedef NSAttributedString *(^WZAttributedAppendBlock)(NSAttributedString *attrStr);
// MARK: NSAttributedString(WZAttributeChain)
@interface NSAttributedString (WZAttributeChain)

@property (nonatomic, readonly) WZAttributeRangeBlock range;

@property (nonatomic, readonly) WZAttributesBlock attributes;

@property (nonatomic, readonly) WZAttributedAppendBlock append;

@end

// MARK: - Mutable Attributed String
typedef NSMutableAttributedString *(^WZMutableAttributesBlock)(WZBuildAttributesBlock buildAttributes);
// MARK: WZMutableAttributedRange
@interface WZMutableAttributeRange : NSObject

- (instancetype)initWithMutableAttributedString:(NSMutableAttributedString *)attrStr range:(NSRange)range;

@property (nonatomic, readonly) WZMutableAttributesBlock attributes;

@end

typedef WZMutableAttributeRange *(^WZMutableAttributeRangeBlock)(NSUInteger loc, NSUInteger len);
typedef NSMutableAttributedString *(^WZMutableAttributedAppendBlock)(NSAttributedString *attrStr);
// MARK: NSMutableAttributedString(WZAttributeChain)
@interface NSMutableAttributedString (WZAttributeChain)

@property (nonatomic, readonly) WZMutableAttributeRangeBlock range;

@property (nonatomic, readonly) WZMutableAttributesBlock attributes;

@property (nonatomic, readonly) WZMutableAttributedAppendBlock append;

@end
