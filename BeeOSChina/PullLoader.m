//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  PullLoader.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/30.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "PullLoader.h"

#pragma mark -

@implementation PullLoader

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUILabel,					state )
DEF_OUTLET( BeeUILabel,					date )
DEF_OUTLET( BeeUIImageView,				arrow )
DEF_OUTLET( BeeUIActivityIndicatorView,	indicator )

- (void)load
{
    self.alpha = 0.0f;
    self.arrow.hidden = NO;
    self.indicator.hidden = YES;
    self.status.data = @"Pull to refresh";
    self.date.data = [NSString stringWithFormat:@"Last update：%@", [[NSDate date] stringWithDateFormat:@"MM/dd/yyyy"]];
}

- (void)unload
{
}

ON_SIGNAL3( BeeUIPullLoader, STATE_CHANGED, signal )
{
    if ( self.animated )
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.25f];
    }
    
    if ( self.pulling )
    {
        self.alpha = 1.0f;
        
        self.arrow.hidden = NO;
        self.arrow.transform = CGAffineTransformRotate( CGAffineTransformIdentity, (M_PI / 360.0f) * -359.0f );
        self.indicator.hidden = YES;
        self.status.data = @"Release to refresh";
        self.date.data = [NSString stringWithFormat:@"Last update：%@", [[NSDate date] stringWithDateFormat:@"MM/dd/yyyy"]];
    }
    else if ( self.loading )
    {
        self.alpha = 1.0f;
        
        self.indicator.hidden = NO;
        self.indicator.animating = YES;
        
        self.arrow.hidden = YES;
        self.status.data = @"Loading...";
        self.date.data = [NSString stringWithFormat:@"Last update：%@", [[NSDate date] stringWithDateFormat:@"MM/dd/yyyy"]];
    }
    else
    {
        self.alpha = 0.0f;
        
        self.arrow.hidden = NO;
        self.arrow.transform = CGAffineTransformIdentity;
        self.indicator.hidden = YES;
        self.status.data = @"Pull to refresh";
        self.date.data = [NSString stringWithFormat:@"Last update：%@", [[NSDate date] stringWithDateFormat:@"MM/dd/yyyy"]];
    }
    
    if ( self.animated )
    {
        [UIView commitAnimations];
    }
}

@end

