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
//  FootLoader.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/30.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "FootLoader.h"

#pragma mark -

@implementation FootLoader

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUILabel,					state )
DEF_OUTLET( BeeUIActivityIndicatorView,	indicator )

- (void)load
{
    self.alpha = 0.0f;
    self.indicator.hidden = YES;
    self.state.data = @"Click to load more";
}

- (void)unload
{
}

#pragma mark -

ON_SIGNAL3( BeeUIFootLoader, STATE_CHANGED, signal )
{
    if ( self.animated )
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.25f];
    }
    
    if ( self.loading )
    {
        self.alpha = 1.0f;
        self.indicator.animating = YES;
        self.state.data = @"Loading...";
    }
    else
    {
        self.indicator.animating = NO;
        
        if ( self.more )
        {
            self.alpha = 1.0f;
            self.state.data = @"Click to load more";
        }
        else
        {
            self.alpha = 0.0f;
            self.state.data = @"No more";
        }
    }
    
    if ( self.animated )
    {
        [UIView commitAnimations];
    }
}

@end
