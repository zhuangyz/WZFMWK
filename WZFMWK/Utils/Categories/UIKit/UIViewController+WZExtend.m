//
//  UIViewController+WZAlert.m
//  WZFMWK
//
//  Created by Walker on 2017/11/23.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "UIViewController+WZExtend.h"

// MARK: - 系统弹框
@implementation UIViewController (WZAlert)

- (UIAlertController *)wz_showAlertWithTitle:(NSString *)title
                                     message:(NSString *)message
                                 cancelTitle:(NSString *)cancelTitle
                                 otherTitles:(NSArray<NSString *> *)otherTitles
                                 cancelBlock:(void(^)(void))cancelBlock
                                actionsBlock:(void(^)(NSInteger tapIndex))actionsBlock {
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//    if (cancelTitle && cancelTitle.length > 0) {
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            if (cancelBlock) {
//                cancelBlock();
//            }
//        }];
//        [alertController addAction:cancelAction];
//    }
//    if (otherTitles && otherTitles.count > 0) {
//        for (NSInteger i = 0; i < otherTitles.count; i++) {
//            NSString *otherTitle = otherTitles[i];
//            UIAlertAction *action = [self createDefaultAction:otherTitle index:i handle:actionsBlock];
//            [alertController addAction:action];
//        }
//    }
//    [self presentViewController:alertController animated:YES completion:nil];
//    return alertController;
    return [self _showAlertWithStyle:UIAlertControllerStyleAlert title:title message:message cancelTitle:cancelTitle otherTitles:otherTitles cancelBlock:cancelBlock actionsBlock:actionsBlock];
}

- (UIAlertController *)wz_showActionSheetWithTitle:(NSString *)title
                                           message:(NSString *)message
                                       cancelTitle:(NSString *)cancelTitle
                                       otherTitles:(NSArray<NSString *> *)otherTitles
                                       cancelBlock:(void (^)(void))cancelBlock
                                      actionsBlock:(void (^)(NSInteger))actionsBlock {
    return [self _showAlertWithStyle:UIAlertControllerStyleActionSheet title:title message:message cancelTitle:cancelTitle otherTitles:otherTitles cancelBlock:cancelBlock actionsBlock:actionsBlock];
}

- (UIAlertController *)_showAlertWithStyle:(UIAlertControllerStyle)style
                                       title:(NSString *)title
                                     message:(NSString *)message
                                 cancelTitle:(NSString *)cancelTitle
                                 otherTitles:(NSArray<NSString *> *)otherTitles
                                 cancelBlock:(void(^)(void))cancelBlock
                                actionsBlock:(void(^)(NSInteger tapIndex))actionsBlock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    if (cancelTitle && cancelTitle.length > 0) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        [alertController addAction:cancelAction];
    }
    if (otherTitles && otherTitles.count > 0) {
        for (NSInteger i = 0; i < otherTitles.count; i++) {
            NSString *otherTitle = otherTitles[i];
            UIAlertAction *action = [self _createDefaultAction:otherTitle index:i handle:actionsBlock];
            [alertController addAction:action];
        }
    }
    [self presentViewController:alertController animated:YES completion:nil];
    return alertController;
}

- (UIAlertAction *)_createDefaultAction:(NSString *)title
                                 index:(NSInteger)index
                                handle:(void(^)(NSInteger))handle {
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handle) {
            handle(index);
        }
    }];
    return action;
}

@end





























