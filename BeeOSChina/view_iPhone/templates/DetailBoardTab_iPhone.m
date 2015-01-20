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
//  DetailBoardTab_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/4.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "DetailBoardTab_iPhone.h"

#pragma mark -

@implementation DetailBoardTab_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIButton, tabbtn_details );
DEF_OUTLET( BeeUIButton, tabbtn_comments );
DEF_OUTLET( BeeUIButton, tabbtn_sharing );

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
    $(self.tabbtn_details).ADD_CLASS( @"active" );
    $(self.tabbtn_comments).REMOVE_CLASS( @"active" );
    $(self.tabbtn_sharing).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectComments
{
    $(self.tabbtn_details).REMOVE_CLASS( @"active" );
    $(self.tabbtn_comments).ADD_CLASS( @"active" );
    $(self.tabbtn_sharing).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectSharing
{
    $(self.tabbtn_details).REMOVE_CLASS( @"active" );
    $(self.tabbtn_comments).REMOVE_CLASS( @"active" );
    $(self.tabbtn_sharing).ADD_CLASS( @"active" );
    
    self.RELAYOUT();
}

@end
