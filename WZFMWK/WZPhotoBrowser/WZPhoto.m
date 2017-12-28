//
//  WZPhoto.m
//  WZPhotoBrowser
//
//  Created by Walker on 2017/6/6.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "WZPhoto.h"

@interface WZPhoto ()

@property (nonatomic, copy, readwrite) NSURL *imageURL;
@property (nonatomic, strong, readwrite) UIImage *image;

@end

@implementation WZPhoto

- (instancetype)initWithImageURLString:(NSString *)urlStr {
    NSAssert(urlStr != nil, @"url string is nil!!!");
    return [self initWithImageURL:[NSURL URLWithString:urlStr]];
}

- (instancetype)initWithImageURL:(NSURL *)url {
    if (self = [super init]) {
        self.imageURL = url;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        self.image = image;
    }
    return self;
}

@end

@implementation WZPhoto (Factory)

+ (instancetype)photoWithImageURLString:(NSString *)urlStr {
    return [[WZPhoto alloc] initWithImageURLString:urlStr];
}

+ (instancetype)photoWithImageURL:(NSURL *)url {
    return [[WZPhoto alloc] initWithImageURL:url];
}

+ (instancetype)photoWithImage:(UIImage *)image {
    return [[WZPhoto alloc] initWithImage:image];
}

@end
