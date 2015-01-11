//
//  NGMessageView.h
//  Banner
//
//  Created by Nitin Gupta on 6/17/14.
//  Copyright (c) 2014 Nitin Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGBannerConstants.h"

@protocol MessageViewDelegate;
@interface NGMessageView : UIView {
    /**
     *   Title Height
     */
    CGFloat _tH;
    /**
     *  Description Height
     */
    CGFloat _dH;
}
@property (nonatomic, weak) id <MessageViewDelegate> delegate;

/**
 *  Initilaizing Banner Massage View With following Param
 *
 *  @param _ttl      Title Of Banner View
 *  @param _dsc      Description of Banner View
 *  @param _type     Message Type
 *  @param _del      Delegate Confrimed By..
 *  @param _dur      Banner Display Duration
 *  @param _btnTtls  Banner Botton Titles List
 *  @param _animType Banner Display Animation Type
 *  @param callBack  After Dismiss With Button Click Call Back Action
 *
 *  @return Returns Instance (UIView *) Type Banner Massage
 */
-(instancetype)initWithTitle:(NSString *)_ttl
                 description:(NSString *)_dsc
                 messageType:(BannerMessageType)_type
                    delegate:(id<MessageViewDelegate>)_del
                    duration:(float)_dur
                buttonTitles:(NSArray *)_btnTtls
               animationType:(BannerAnimationDirection)_animType
                 andCallBack:(BannerCallBackBlock)callBack;
/**
 *  Showing Banner Animation
 */
-(void)showWithAnimationWithParent:(UIView *)_prtView;
@end

@protocol MessageViewDelegate <NSObject>
@required
-(void)dismissForciblyBannerView:(NGMessageView*)_msgView;
-(void)animationDidFinish:(NGMessageView *)_msgView;
@end
