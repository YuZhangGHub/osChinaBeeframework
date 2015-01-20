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
//  MenuBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/22.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//
#import "MenuBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@implementation MenuBoard_iPhone

DEF_SINGLETON( MenuBoard_iPhone )

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

- (void)load
{
}

- (void)unload
{
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    self.navigationBarShown = NO;
}

ON_DELETE_VIEWS( signal )
{
}

#pragma mark -

- (void)selectItem:(NSString *)item animated:(BOOL)animated
{
    if ( animated )
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3f];
    }
    
    $(@"item-bg").view.frame = $(item).view.frame;
    
    if ( animated )
    {
        [UIView commitAnimations];
    }
}

@end
