//
//	Powered by BeeFramework
//
//
//  DetailTweetBoardTab_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/4.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "DetailTweetBoardTab_iPhone.h"

#pragma mark -

@implementation DetailTweetBoardTab_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIButton, tweettab_details );
DEF_OUTLET( BeeUIButton, tweettab_comments );

- (void)load
{
}

- (void)unload
{
}

- (void)dataDidChanged
{
    // TODO: fill data
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

- (void)selectDetail
{
    $(self.tweettab_details).ADD_CLASS( @"active" );
    $(self.tweettab_comments).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectComments
{
    $(self.tweettab_details).REMOVE_CLASS( @"active" );
    $(self.tweettab_comments).ADD_CLASS( @"active" );
    
    self.RELAYOUT();
}

@end
