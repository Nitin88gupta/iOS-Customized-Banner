//
//  NGViewController.m
//  Banner
//
//  Created by Nitin Gupta on 6/17/14.
//  Copyright (c) 2014 Nitin Gupta. All rights reserved.
//

#import "NGViewController.h"
#import "NGBannerManager.h"
#import "NGMessageView.h"
@interface NGViewController ()

@end

@implementation NGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setUserInteractionEnabled:YES];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showBanners:(id)sender {
    NSArray *_codeArr = [NSArray arrayWithObjects:[NSNumber numberWithInt:0],
                         [NSNumber numberWithInt:1],
                         [NSNumber numberWithInt:0],
                         [NSNumber numberWithInt:2],
                         [NSNumber numberWithInt:0],
                         [NSNumber numberWithInt:2],
                         [NSNumber numberWithInt:1],
                         [NSNumber numberWithInt:0],
                         [NSNumber numberWithInt:1],
                         [NSNumber numberWithInt:2],
                         [NSNumber numberWithInt:0],
                         [NSNumber numberWithInt:2],
                         nil];
    NSUInteger count = [_codeArr count];
    NSString *ttlStr = @"Nitin Gupta";
    NSString *msgStr = @"Read all latest news from India & World on Politics, Business, Technology, Entertainment, Sports etc. Find exclusive news stories on current affairs, cricket etc.";
    NSArray *buttonsList = [NSArray arrayWithObjects:@"Ok",@"Cancel", nil];
    CGFloat duration = 4.0f;
    
    for (int i = 0; i < count; i++) {
        BannerMessageType type = (BannerMessageType)[[_codeArr objectAtIndex:i] intValue];
        
        [[NGBannerManager sharedBannerManager] showBannerWithTitle:ttlStr
                                                           message:msgStr
                                                       messageType:type
                                                           buttons:buttonsList
                                                  autoDismissAfter:duration
                                                     animationType:kBannerAnimationTop
                                                      afterDismiss:^(int buttonIndex) {
                                                          [self bannerDismissedForIndex:buttonIndex];
                                                    }];
    }
}

-(void)bannerDismissedForIndex:(NSInteger)_index {
    if (_index >= 0) {
        NSLog(@"Button Clicked Index:%d",_index);
    } else {
        NSLog(@"Tap/Auto Dismiss");
    }
}
@end
