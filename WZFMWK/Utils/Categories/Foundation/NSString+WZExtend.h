//
//  NSString+WZExtend.h
//  WZFMWK
//
//  Created by Walker on 2017/11/27.
//  Copyright © 2017年 wz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// MARK: - 字符串尺寸
@interface NSString (WZSize)

- (CGSize)wz_sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

@end

@interface UILabel (WZSize)

- (CGSize)wz_textSizeInWidth:(CGFloat)maxWidth height:(CGFloat)maxHeight;

@end

// MARK: - 字符串检验
@interface NSString (WZValidate)

- (BOOL)wz_isValidNumber;

- (BOOL)wz_isValidMobile;

- (BOOL)wz_isValidEmail;

- (BOOL)wz_isEmpty;

@end

// MARK: - 编码/加密
@interface NSString (WZMD5)

- (NSString *)wz_MD5;

@end

// MARK: - 删除 HTML
@interface NSString (WZRemoveHTML)

- (NSString *)wz_stringByRemoveHTML;

@end















