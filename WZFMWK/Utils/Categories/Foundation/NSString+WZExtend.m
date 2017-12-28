//
//  NSString+WZExtend.m
//  WZFMWK
//
//  Created by Walker on 2017/11/27.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "NSString+WZExtend.h"
#import <CommonCrypto/CommonDigest.h>

// MARK: - 字符串尺寸
@implementation NSString (WZSize)

- (CGSize)wz_sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    CGSize opSize = maxSize;
    
    if (opSize.width == 0) {
        opSize.width = CGFLOAT_MAX;
    }
    if (opSize.height == 0) {
        opSize.height = CGFLOAT_MAX;
    }
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font}];
    CGRect expectedLabelSize = [attrString boundingRectWithSize:opSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return expectedLabelSize.size;
}

@end

@implementation UILabel (WZSize)

- (CGSize)wz_textSizeInWidth:(CGFloat)maxWidth height:(CGFloat)maxHeight {
    return [self.text wz_sizeWithFont:self.font maxSize:CGSizeMake(maxWidth, maxHeight)];
}

@end

// MARK: - 字符串检验
@implementation NSString (WZValidate)

- (BOOL)wz_isValidNumber {
    NSString *regex = @"[0-9]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)wz_isValidMobile {
    NSString *regex = @"^1[234578]{1}[0-9]{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)wz_isValidEmail {
    NSString *regex = @"^[[:alnum:]!#$%&'*+/=?^_`{|}~-]+((\\.?)[[:alnum:]!#$%&'*+/=?^_`{|}~-]+)*@[[:alnum:]-]+(\\.[[:alnum:]-]+)*(\\.[[:alpha:]]+)+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)wz_isEmpty {
    if ((NSNull *)self == [NSNull null]) {
        return YES;
    }
    NSString *content = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return content.length == 0;
}

@end

// MARK: - 编码/加密
@implementation NSString (WZMD5)

- (NSString *)wz_MD5 {
    const char *tempStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(tempStr, (CC_LONG)strlen(tempStr), result);
    NSMutableString *resultStr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultStr appendFormat:@"%02x", result[i]];
    }
    return [resultStr copy];
}

@end

// MARK: - 删除 HTML
@implementation NSString (WZRemoveHTML)

- (NSString *)wz_stringByRemoveHTML {
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSString *removedHTMLStr = [self copy];
    
    while (!scanner.isAtEnd) {
        NSString *tag = nil;
        [scanner scanUpToString:@"<" intoString:NULL];
        [scanner scanUpToString:@">" intoString:&tag];
        removedHTMLStr = [removedHTMLStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", tag] withString:@" "];
    }
    return removedHTMLStr;
}

@end















