//
//  NGBannerManager.h
//  Banner
//
//  Created by Nitin Gupta on 6/17/14.
//  Copyright (c) 2014 Nitin Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGBannerConstants.h"

@class NGMessageView;

@interface NGBannerManager : NSObject {
    /**
     *  Banner Queue
     */
    NSMutableArray *_bannersQueue;
    /**
     *  Current Banner View Reference
     */
    NGMessageView *_currentBannerView;
    /**
     *  Parent View For Banner
     */
    UIView *_prtView;
}

+ (instancetype)sharedBannerManager;

/*!
 * @discussion Showing Banner View
 * @param title Title for Banner
 * @param message Description for Banner
 * @param messageType Message Type for Banner
 * @param buttonTitles Buttons Title Array
 * @param duration Duration For Visibility for Banner 
 * @note IF Duration is 0 (zero) Auto Dismiss will be disabled,i.e In Case Banner view have button list and Duration is Zero means, Banner will be dismissed by any button avail in list. Else  in case of nil button list and Zero Duration Banner Will Auto Dismiss with default duration of 2 sec.
 * @param callBack Call Back Action To performed while tapping on Cancel or any other button Button
 * @return void
 */
- (void)showBannerWithTitle:(NSString *)title
                    message:(NSString *)message
                messageType:(BannerMessageType)messageType
                    buttons:(NSArray *)buttonTitles
           autoDismissAfter:(float)duration
              animationType:(BannerAnimationDirection)_animType
               afterDismiss:(BannerCallBackBlock)callBack;

@end
