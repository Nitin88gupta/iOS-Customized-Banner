//
//  NGBannerConstants.h
//  Banner
//
//  Created by Nitin Gupta on 6/17/14.
//  Copyright (c) 2014 Nitin Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kBannerErrorMessageType = 0,
    kBannerSuccessMessageType = 1,
    kBannerInfoMessageType = 2,
} BannerMessageType;

typedef enum {
    kBannerAnimationTop = 0,
    kBannerAnimationBottom = 1,
} BannerAnimationDirection;

typedef void(^BannerCallBackBlock)(NSInteger buttonIndex);


static const CGFloat kButtonH = 20.0f;
static const CGFloat kButtonXOffset = 100.0f;
static const CGFloat kBannerMaxHeight = 100.0f;

#define kDescriptionFont [UIFont systemFontOfSize:16]
#define kTitleFont [UIFont boldSystemFontOfSize:18]