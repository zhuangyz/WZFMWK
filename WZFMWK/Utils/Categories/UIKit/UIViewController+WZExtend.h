//
//  UIViewController+WZAlert.h
//  WZFMWK
//
//  Created by Walker on 2017/11/23.
//  Copyright © 2017年 wz. All rights reserved.
//

#import <UIKit/UIKit.h>

// MARK: - 系统弹框
@interface UIViewController (WZAlert)

- (UIAlertController *)wz_showAlertWithTitle:(NSString *)title
                                     message:(NSString *)message
                                 cancelTitle:(NSString *)cancelTitle
                                 otherTitles:(NSArray<NSString *> *)otherTitles
                                 cancelBlock:(void(^)(void))cancelBlock
                                actionsBlock:(void(^)(NSInteger tapIndex))actionsBlock;

- (UIAlertController *)wz_showActionSheetWithTitle:(NSString *)title
                                           message:(NSString *)message
                                       cancelTitle:(NSString *)cancelTitle
                                       otherTitles:(NSArray<NSString *> *)otherTitles
                                       cancelBlock:(void (^)(void))cancelBlock
                                      actionsBlock:(void (^)(NSInteger))actionsBlock;

@end
