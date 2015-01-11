//
//  NGMessageView.m
//  Banner
//
//  Created by Nitin Gupta on 6/17/14.
//  Copyright (c) 2014 Nitin Gupta. All rights reserved.
//

#import "NGMessageView.h"
@interface NGMessageView ()
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *descriptionString;
@property (nonatomic, copy) NSArray *buttonTitles;
@property (nonatomic, assign) BannerMessageType messageType;
@property (nonatomic, strong) NSArray *callbacks;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) BannerAnimationDirection direction;

- (float)getBannerViewHeightForWidth:(CGFloat)_w;
- (CGFloat)heightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;
- (UIColor *)backgroundColorForMessageType:(BannerMessageType)type ;
- (UIColor *)strokeColorForMessageType:(BannerMessageType)type ;
- (void)updateViewConstraintsForLoading;
- (BOOL)isButtonListAvailable;
@end

float statusBarOffSet = 0;
@implementation NGMessageView
@synthesize delegate = _delegate;
@synthesize direction = _direction;

-(instancetype)initWithTitle:(NSString *)_ttl
                 description:(NSString *)_dsc
                 messageType:(BannerMessageType)_type
                    delegate:(id<MessageViewDelegate>)_del
                    duration:(float)_dur
                buttonTitles:(NSArray *)_btnTtls
               animationType:(BannerAnimationDirection)_animType
                 andCallBack:(BannerCallBackBlock)callBack {
    if (self = [super init]) {
        _titleString = _ttl;
        _descriptionString = _dsc;
        _buttonTitles = _btnTtls;
        _messageType = _type;
        _delegate = _del;
        _duration = _dur;
        _direction = _animType;
        _callbacks = callBack ? [NSArray arrayWithObject:callBack] : [NSArray array];
        if (![UIApplication sharedApplication].statusBarHidden) {
            statusBarOffSet = [[UIApplication sharedApplication] statusBarFrame].size.height;
        }
    }
    return self;
}

- (void)dealloc {
    _delegate = nil;
    _callbacks = nil;
    _titleString = nil;
    _descriptionString = nil;
    _buttonTitles = nil;
}

- (void)updateViewConstraintsForLoading {
    CGSize _scrSize = [[UIScreen mainScreen] bounds].size;
    float _w = _scrSize.width;
    float _h = [self getBannerViewHeightForWidth:_w];
    float _y = _scrSize.height - _h;
    CGRect _rect = CGRectMake(0, _y, _scrSize.width,_h );
    [self setFrame:_rect];
    
    CGRect _ttlRect = CGRectMake(0, 0, _rect.size.width, _tH);
    CGRect _dscRect = CGRectMake(0, _tH, _rect.size.width, _dH);
    if (_direction == kBannerAnimationTop) {
        _ttlRect.origin.y += statusBarOffSet;
        _dscRect.origin.y += statusBarOffSet;
    }
    
    UILabel *_bannerTitleLabel = [[UILabel alloc] initWithFrame:_ttlRect];
    [_bannerTitleLabel setText:_titleString];
    [_bannerTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [_bannerTitleLabel setNumberOfLines:1];
    [_bannerTitleLabel setAdjustsFontSizeToFitWidth:YES];
    [_bannerTitleLabel setTextColor:[UIColor blackColor]];
    [_bannerTitleLabel setBackgroundColor:[UIColor clearColor]];
    [_bannerTitleLabel setFont:kTitleFont];
    [self addSubview:_bannerTitleLabel];
    
    UILabel *_bannerDescriptionLabel = [[UILabel alloc] initWithFrame:_dscRect];
    [_bannerDescriptionLabel setText:_descriptionString];
    [_bannerDescriptionLabel setTextAlignment:NSTextAlignmentCenter];
    [_bannerDescriptionLabel setNumberOfLines:0];
    [_bannerDescriptionLabel setAdjustsFontSizeToFitWidth:YES];
    [_bannerDescriptionLabel setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight];
    [_bannerDescriptionLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
    [_bannerDescriptionLabel setTextColor:[UIColor blackColor]];
    [_bannerDescriptionLabel setFont:kDescriptionFont];
    [_bannerDescriptionLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_bannerDescriptionLabel];

    [self setBackgroundColor:[self backgroundColorForMessageType:_messageType]];
    
    NSInteger _loopCount = _buttonTitles.count;
    float buttonWidth = (_w - kButtonXOffset) / _loopCount;
    float buttonPadding = kButtonXOffset / (_loopCount - 1 + 2 * 2);
    for(int i = 0; i < _loopCount; i++) {
        NSString *buttonTitleStr = [_buttonTitles objectAtIndex:i];
        UIButton *_aButton = [UIButton buttonWithType:UIButtonTypeSystem];        
        [[_aButton titleLabel] setFont:kDescriptionFont];

        [_aButton setTitle:buttonTitleStr forState:UIControlStateNormal];
        [_aButton setTitle:buttonTitleStr forState:UIControlStateHighlighted];
        [_aButton setTitle:buttonTitleStr forState:UIControlStateDisabled];
        [_aButton setTitle:buttonTitleStr forState:UIControlStateSelected];
        
        [_aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_aButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [_aButton setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        [_aButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];

        [_aButton setTag:i];
        
        CGRect _btnRect = CGRectMake(buttonPadding * 2 + buttonWidth * i + buttonPadding * i, _tH+_dH,
                                     buttonWidth, kButtonH);
        
        if (_direction == kBannerAnimationTop) {
            _btnRect.origin.y += statusBarOffSet;
        }
        [_aButton setFrame:_btnRect];
        
        if (!([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)) {
            [_aButton setCenter:CGPointMake(_aButton.center.x, _aButton.center.y - kButtonH)];
        }

        [_aButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin];
        [_aButton addTarget:self action:@selector(onButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_aButton];
    }
    
    UITapGestureRecognizer *_gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:_gesture];
}

- (BOOL)isButtonListAvailable {
    return (BOOL)[_buttonTitles count];
}

#pragma mark - IBActions Methods
- (void)onButtonTapped:(id)sender {
    if ([_callbacks count]) {
        BannerCallBackBlock _block = [_callbacks firstObject];
        NSInteger _aTag = -1; // -1 For Tap/Auto Dismiss otherwise Button Index
        if (sender) {
            _aTag = [sender tag];
        }
        _block(_aTag);
    }
    if ([_delegate respondsToSelector:@selector(dismissForciblyBannerView:)]) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeAnimation) object:nil];
        [_delegate dismissForciblyBannerView:self];
    }
}

#pragma mark - Private Methods
-(void)tapped:(id)_gesture {
    [self onButtonTapped:nil];
}

- (float)getBannerViewHeightForWidth:(CGFloat)_w {
    _tH = [self heightForText:_titleString havingWidth:_w andFont:kTitleFont];
    _dH = [self heightForText:_descriptionString havingWidth:_w andFont:kDescriptionFont];
    CGFloat _retVal = kButtonH + _tH + _dH;
    CGFloat _comp = kBannerMaxHeight;
    
    if (_direction == kBannerAnimationTop) {
        _retVal += statusBarOffSet;
        _comp += statusBarOffSet;
    }
    
    if (_retVal > _comp) {
        _dH = _comp - kButtonH - _tH;
        if (_direction == kBannerAnimationTop) {
            _dH -=statusBarOffSet;
        }
        _retVal = _comp;
    }
    return _retVal;
}

- (CGFloat)heightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGFloat result = font.pointSize;
    CGFloat width = widthValue;
    if (text) {
        CGSize textSize = { width, CGFLOAT_MAX };
        CGSize size;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:font}
                                              context:nil];
            size = CGSizeMake(frame.size.width, frame.size.height+1);
        } else {
            size = [text sizeWithFont:font constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
        }
        result = MAX(size.height, result);
    }
    return result;
}

- (UIColor *)backgroundColorForMessageType:(BannerMessageType)type {
    UIColor *backgroundColor = nil;
    switch (type) {
        case kBannerErrorMessageType:
            backgroundColor = [UIColor colorWithRed:1.0 green:0.611 blue:0.0 alpha:0.96];
            break;
        case kBannerSuccessMessageType:
            backgroundColor = [UIColor colorWithRed:0.0f green:0.831f blue:0.176f alpha:0.96];
            break;
        case kBannerInfoMessageType:
            backgroundColor = [UIColor colorWithRed:0.0 green:0.482 blue:1.0 alpha:0.96];
            break;
        default:
            break;
    }
    return backgroundColor;
}

- (UIColor *)strokeColorForMessageType:(BannerMessageType)type {
    UIColor *strokeColor = nil;
    switch (type) {
        case kBannerErrorMessageType:
            strokeColor = [UIColor colorWithRed:0.949f green:0.580f blue:0.0f alpha:1.0f];
            break;
        case kBannerSuccessMessageType:
            strokeColor = [UIColor colorWithRed:0.0f green:0.772f blue:0.164f alpha:1.0f];
            break;
        case kBannerInfoMessageType:
            strokeColor = [UIColor colorWithRed:0.0f green:0.415f blue:0.803f alpha:1.0f];
            break;
        default:
            break;
    }
    return strokeColor;
}

#pragma mark - Animation Related
-(void)showWithAnimationWithParent:(UIView *)_prtView {
    if (_prtView) {
        [self updateViewConstraintsForLoading];

        [_prtView addSubview:self];
        [_prtView bringSubviewToFront:self];
        
        [self setFrame:[self getViewFrameForAnimation]];
        
        [UIView animateWithDuration:1.0 delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            [self setFrame:[self getOriginalFrameForAnimation]];
        } completion:^(BOOL finished) {
            //In Case Banner view have button list and Duration is Zero means, Banner will be dismissed by any button avail in list. Else  in case of nil button list and Zero Duration Banner Will Auto Dismiss with default Deutaion of 2 sec.
            BOOL _canAutoDismiss = FALSE;
            _canAutoDismiss = [self isButtonListAvailable] ? (_duration ? YES:NO) : YES;
            if (_canAutoDismiss) {
                _duration = _duration <= 0 ? 2:_duration;
                [self performSelector:@selector(removeAnimation) withObject:Nil afterDelay:_duration];
            } else {
                NSLog(@"Auto dismiss is Disabled due to Zero duration value, It could be dismissed by tapping anyone of banner button.");
            }
        }];
    }
}

-(void)removeAnimation {
    [UIView animateWithDuration:0.5 delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        [self setFrame:[self getViewFrameForAnimation]];
    } completion:^(BOOL finished) {
        //Removing From SuperView
        if ([_delegate  respondsToSelector:@selector(animationDidFinish:)]) {
            [self onButtonTapped:nil];
        } else {
            NSAssert(0, @"[_delegate  respondsToSelector:@selector(animationDidFinish:)] Failed");
        }
    }];
}

#pragma mark - Private Getters Related
-(CGRect)getOriginalFrameForAnimation {
    CGSize _scrnSize = [[UIScreen mainScreen] bounds].size;
    float _y;

    switch (_direction) {
        case kBannerAnimationBottom: {
            _y = _scrnSize.height - self.frame.size.height;
        } break;
        case kBannerAnimationTop: {
            _y = 0;
        } break;
            
        default:
            //Un-Defined
            break;
    }
    
    CGRect _vwRect = CGRectMake(0, _y, self.frame.size.width,self.frame.size.height);
    
    if (!([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)) {
        _vwRect.origin.y = _vwRect.origin.y -44;
        _vwRect.size.height = _vwRect.size.height +44;
    }

    return _vwRect;
}

-(CGRect)getViewFrameForAnimation {
    CGRect _retRect = CGRectZero;
    CGRect _vwRect = [self getOriginalFrameForAnimation];
    switch (_direction) {
        case kBannerAnimationBottom: {
            _retRect = CGRectMake(_vwRect.origin.x, _vwRect.origin.y+_vwRect.size.height, _vwRect.size.width, _vwRect.size.height);
        } break;
        case kBannerAnimationTop: {
            _retRect = CGRectMake(_vwRect.origin.x, _vwRect.origin.y-_vwRect.size.height, _vwRect.size.width, _vwRect.size.height);
        } break;
            
        default:
            //Un-Defined
            break;
    }
    return _retRect;
}

@end
