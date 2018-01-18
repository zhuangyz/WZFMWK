//
//  NSAttributedString+WZExtend.m
//  WZFMWK
//
//  Created by Walker on 2018/1/16.
//  Copyright © 2018年 wz. All rights reserved.
//

#import "NSAttributedString+WZExtend.h"
#import <objc/runtime.h>

// MARK: - Size
@implementation NSAttributedString (WZSize)

- (CGSize)wz_sizeWithMaxSize:(CGSize)maxSize useLabel:(void (^)(UILabel *))configLabelBlock {
    CGSize opSize = maxSize;
    if (opSize.width == 0) {
        opSize.width = CGFLOAT_MAX;
    }
    if (opSize.height == 0) {
        opSize.height = CGFLOAT_MAX;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:17];
    
    if (configLabelBlock) {
        configLabelBlock(label);
    }
    
    label.attributedText = self;
    CGSize textSize = [label sizeThatFits:opSize];
    textSize.width += 1;
    textSize.height += 1;
    return textSize;
}

@end

// MARK: - NSString(WZAttributedString)
@implementation NSString (WZAttributedString)

- (NSAttributedString *)attributedString {
    return [[NSAttributedString alloc] initWithString:self];
}

- (NSMutableAttributedString *)mutableAttributedString {
    return [[NSMutableAttributedString alloc] initWithString:self];
}

@end

// MARK: - WZAttributesBuilder
@implementation WZAttributesBuilder

- (instancetype)init {
    self = [super init];
    if (self) {
        self.font = nil;
        self.paragraphStyle = nil;
        self.foregroundColor = nil;
        self.backgroundColor = nil;
        self.ligature = NO;
        self.kern = nil;
        self.strikethroughStyle = NSUnderlineStyleNone;
        self.strikethroughColor = nil;
        self.underlineStyle = NSUnderlineStyleNone;
        self.underlineColor = nil;
        self.strokeWidth = nil;
        self.strokeColor = nil;
        self.shadow = nil;
        self.textEffectStyle = nil;
        self.attachment = nil;
        self.link = nil;
        self.baselineOffset = nil;
        self.obliqueness = nil;
        self.expansion = nil;
        self.writeDirection = WZAttributedWriteDirectionNone;
    }
    return self;
}

- (NSDictionary<NSAttributedStringKey,id> *)attributes {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    if (self.font)
        options[NSFontAttributeName] = self.font;
    if (self.paragraphStyle)
        options[NSParagraphStyleAttributeName] = self.paragraphStyle;
    if (self.foregroundColor)
        options[NSForegroundColorAttributeName] = self.foregroundColor;
    if (self.backgroundColor)
        options[NSBackgroundColorAttributeName] = self.backgroundColor;
    if (self.ligature)
        options[NSLigatureAttributeName] = @(1);
    if (self.kern)
        options[NSKernAttributeName] = self.kern;
    if (self.strikethroughStyle != NSUnderlineStyleNone)
        options[NSStrikethroughStyleAttributeName] = @(self.strikethroughStyle);
    if (self.strikethroughColor)
        options[NSStrikethroughColorAttributeName] = self.strikethroughColor;
    if (self.underlineStyle != NSUnderlineStyleNone)
        options[NSUnderlineStyleAttributeName] = @(self.underlineStyle);
    if (self.underlineColor)
        options[NSUnderlineColorAttributeName] = self.underlineColor;
    if (self.strokeWidth)
        options[NSStrokeWidthAttributeName] = self.strokeWidth;
    if (self.strokeColor)
        options[NSStrokeColorAttributeName] = self.strokeColor;
    if (self.shadow)
        options[NSShadowAttributeName] = self.shadow;
    if (self.textEffectStyle)
        options[NSTextEffectAttributeName] = self.textEffectStyle;
    if (self.attachment)
        options[NSAttachmentAttributeName] = self.attachment;
    if (self.link)
        options[NSLinkAttributeName] = self.link;
    if (self.baselineOffset)
        options[NSBaselineOffsetAttributeName] = self.baselineOffset;
    if (self.obliqueness)
        options[NSObliquenessAttributeName] = self.obliqueness;
    if (self.expansion)
        options[NSExpansionAttributeName] = self.expansion;
    if (self.writeDirection != WZAttributedWriteDirectionNone)
        options[NSWritingDirectionAttributeName] = [self writeDirectionValueWith:self.writeDirection];
    return [options copy];
}

- (NSArray<NSNumber *> *)writeDirectionValueWith:(WZAttributedWriteDirection)writeDirection {
    NSArray *value = nil;
    switch (writeDirection) {
        case WZAttributedWriteDirectionNone:
            break;
        case WZAttributedWriteDirectionLRE:
            value = @[@(NSWritingDirectionLeftToRight | NSWritingDirectionEmbedding)];
            break;
        case WZAttributedWriteDirectionRLE:
            value = @[@(NSWritingDirectionRightToLeft | NSWritingDirectionEmbedding)];
            break;
        case WZAttributedWriteDirectionLRO:
            value = @[@(NSWritingDirectionLeftToRight | NSWritingDirectionOverride)];
            break;
        case WZAttributedWriteDirectionRLO:
            value = @[@(NSWritingDirectionRightToLeft | NSWritingDirectionOverride)];
            break;
    }
    return value;
}

@end

// MARK: - Attributed String
// MARK: - WZAttributeRange
@interface WZAttributeRange ()

@property (nonatomic, strong) NSMutableAttributedString *mutableAttrStr;
@property (nonatomic, assign) NSRange range;

@property (nonatomic, readwrite, copy) WZAttributesBlock attributes;

@end

@implementation WZAttributeRange

- (instancetype)initWithAttributedString:(NSAttributedString *)attrStr range:(NSRange)range {
    if (self = [super init]) {
        self.mutableAttrStr = [attrStr mutableCopy];
        self.range = range;
        
        __weak typeof(self) weak_self = self;
        [self setAttributes:^NSAttributedString *(WZBuildAttributesBlock buildAttributes) {
            WZAttributesBuilder *builder = [[WZAttributesBuilder alloc] init];
            buildAttributes(builder);
            [weak_self.mutableAttrStr addAttributes:builder.attributes range:weak_self.range];
            return [weak_self.mutableAttrStr copy];
        }];
    }
    return self;
}

@end

static const void *kWZAttributedStringRangeBlockKey = &kWZAttributedStringRangeBlockKey;
static const void *kWZAttributedStringAttributesBlockKey = &kWZAttributedStringAttributesBlockKey;
static const void *kWZAttributedStringAppendBlockKey = &kWZAttributedStringAppendBlockKey;
// MARK: - NSAttributedString(WZAttributeChain)
@implementation NSAttributedString (WZAttributeChain)

- (WZAttributeRangeBlock)range {
    WZAttributeRangeBlock range = objc_getAssociatedObject(self, kWZAttributedStringRangeBlockKey);
    if (!range) {
        __weak typeof(self) weak_self = self;
        range = ^WZAttributeRange *(NSUInteger loc, NSUInteger len){
            WZAttributeRange *range = [[WZAttributeRange alloc] initWithAttributedString:weak_self range:NSMakeRange(loc, len)];
            return range;
        };
        objc_setAssociatedObject(self, kWZAttributedStringRangeBlockKey, range, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return range;
}

- (WZAttributesBlock)attributes {
    WZAttributesBlock attributes = objc_getAssociatedObject(self, kWZAttributedStringAttributesBlockKey);
    if (!attributes) {
        __weak typeof(self) weak_self = self;
        attributes = ^NSAttributedString *(WZBuildAttributesBlock buildAttributes) {
            return weak_self.range(0, weak_self.length).attributes(buildAttributes);
        };
        objc_setAssociatedObject(self, kWZAttributedStringAttributesBlockKey, attributes, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return attributes;
}

- (WZAttributedAppendBlock)append {
    WZAttributedAppendBlock append = objc_getAssociatedObject(self, kWZAttributedStringAppendBlockKey);
    if (!append) {
        __weak typeof(self) weak_self = self;
        append = ^NSAttributedString *(NSAttributedString *attrStr) {
            NSMutableAttributedString *mutableAttrStr = [[NSMutableAttributedString alloc] initWithAttributedString:weak_self];
            [mutableAttrStr appendAttributedString:attrStr];
            return [mutableAttrStr copy];
        };
        objc_setAssociatedObject(self, kWZAttributedStringAppendBlockKey, append, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return append;
}

@end

// MARK: - Mutable Attributed String
// MARK: - WZMutableAttributedRange
@interface WZMutableAttributeRange ()

@property (nonatomic, strong) NSMutableAttributedString *mutableAttrStr;
@property (nonatomic, assign) NSRange range;

@property (nonatomic, readwrite, copy) WZMutableAttributesBlock attributes;

@end

@implementation WZMutableAttributeRange

- (instancetype)initWithMutableAttributedString:(NSMutableAttributedString *)attrStr range:(NSRange)range {
    if (self = [super init]) {
        self.mutableAttrStr = attrStr;
        self.range = range;
        
        __weak typeof(self) weak_self = self;
        [self setAttributes:^NSMutableAttributedString *(WZBuildAttributesBlock buildAttributes) {
            WZAttributesBuilder *builder = [[WZAttributesBuilder alloc] init];
            buildAttributes(builder);
            [weak_self.mutableAttrStr addAttributes:builder.attributes range:weak_self.range];
            return weak_self.mutableAttrStr;
        }];
    }
    return self;
}

@end

// MARK: - NSMutableAttributedString(WZAttributeChain)
@implementation NSMutableAttributedString (WZAttributeChain)

- (WZMutableAttributeRangeBlock)range {
    WZMutableAttributeRangeBlock range = objc_getAssociatedObject(self, kWZAttributedStringRangeBlockKey);
    if (!range) {
        __weak typeof(self) weak_self = self;
        range = ^WZMutableAttributeRange *(NSUInteger loc, NSUInteger len){
            WZMutableAttributeRange *range = [[WZMutableAttributeRange alloc] initWithMutableAttributedString:weak_self range:NSMakeRange(loc, len)];
            return range;
        };
        objc_setAssociatedObject(self, kWZAttributedStringRangeBlockKey, range, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return range;
}

- (WZMutableAttributesBlock)attributes {
    WZMutableAttributesBlock attributes = objc_getAssociatedObject(self, kWZAttributedStringAttributesBlockKey);
    if (!attributes) {
        __weak typeof(self) weak_self = self;
        attributes = ^NSMutableAttributedString *(WZBuildAttributesBlock buildAttributes) {
            return weak_self.range(0, weak_self.length).attributes(buildAttributes);
        };
        objc_setAssociatedObject(self, kWZAttributedStringAttributesBlockKey, attributes, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return attributes;
}

- (WZMutableAttributedAppendBlock)append {
    WZMutableAttributedAppendBlock append = objc_getAssociatedObject(self, kWZAttributedStringAppendBlockKey);
    if (!append) {
        __weak typeof(self) weak_self = self;
        append = ^NSMutableAttributedString *(NSAttributedString *attrStr) {
            [weak_self appendAttributedString:attrStr];
            return weak_self;
        };
        objc_setAssociatedObject(self, kWZAttributedStringAppendBlockKey, append, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return append;
}

@end























