//
//  NGBannerManager.m
//  Banner
//
//  Created by Nitin Gupta on 6/17/14.
//  Copyright (c) 2014 Nitin Gupta. All rights reserved.
//

#import "NGBannerManager.h"
#import "NGMessageView.h"

static NGBannerManager* sharedInstance = nil;

@interface NGBannerManager (private)<MessageViewDelegate>
-(void)displayNextBanner;
-(void)displayBanner:(NGMessageView*)_msgView;
-(id)getParentView ;
-(void)pushBannerViewToBannerQueue:(NGMessageView *)_msgView;
-(void)popBannerViewToBannerQueue:(NGMessageView*)_msgView;
@end

@implementation NGBannerManager

+ (instancetype)sharedBannerManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NGBannerManager alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    self = [super init];
    if (self) {
        _bannersQueue = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)dealloc {
    if ([_currentBannerView superview]) {
        [_currentBannerView removeFromSuperview];
    }
    _currentBannerView = nil;
    
    [_bannersQueue removeAllObjects];
    _bannersQueue = nil;
}

#pragma mark - Life Cycle Related
- (void)showBannerWithTitle:(NSString *)title
                    message:(NSString *)message
                messageType:(BannerMessageType)messageType
                    buttons:(NSArray *)buttonTitles
           autoDismissAfter:(float)duration
              animationType:(BannerAnimationDirection)_animType
               afterDismiss:(BannerCallBackBlock)callBack {
    
    NGMessageView *_msgView = [[NGMessageView alloc] initWithTitle:title description:message messageType:messageType delegate:self duration:duration buttonTitles:buttonTitles animationType:_animType andCallBack:callBack];
    [self pushBannerViewToBannerQueue:_msgView];
}

-(void)displayNextBanner {
    if (_currentBannerView) {
        [self popBannerViewToBannerQueue:_currentBannerView];
        _currentBannerView= nil;
    }
    NGMessageView *_msgView = [_bannersQueue firstObject];
    [self displayBanner:_msgView];
}

-(void)displayBanner:(NGMessageView*)_msgView {
    if (_msgView) {
        _currentBannerView = _msgView;
        [_msgView showWithAnimationWithParent:[self getParentView]];
    }
}

-(id)getParentView {
    if (!_prtView) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if(!keyWindow) {
            NSArray *windows = [UIApplication sharedApplication].windows;
            if(windows.count > 0)  {
                keyWindow = [windows lastObject];
            }
            keyWindow = [windows firstObject];
        }
        _prtView = [[keyWindow subviews] firstObject];
    }
    return _prtView;
}

-(void)pushBannerViewToBannerQueue:(NGMessageView *)_msgView {
    [_bannersQueue addObject:_msgView];
    if (!_currentBannerView) {
        [self displayBanner:_msgView];
    }
}

-(void)popBannerViewToBannerQueue:(NGMessageView*)_msgView {
    if (_bannersQueue && [_bannersQueue count]) {
        if ([_bannersQueue containsObject:_msgView]) {
            [_bannersQueue removeObject:_msgView];
            _msgView = nil;
        }
    }
}

#pragma mark - MessageView Delegate
-(void)dismissForciblyBannerView:(NGMessageView*)_msgView {
    [self animationDidFinish:_msgView];
}

-(void)animationDidFinish:(NGMessageView *)_msgView {
    if (_msgView) {
        [[_msgView layer] removeAllAnimations];
        [_msgView removeFromSuperview];
    }
    [self displayNextBanner];
}


@end
