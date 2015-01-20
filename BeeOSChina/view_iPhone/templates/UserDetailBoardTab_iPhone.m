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
//  UserDetailBoardTab_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/21.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "UserDetailBoardTab_iPhone.h"

#pragma mark -

@implementation UserDetailBoardTab_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIButton, activities );
DEF_OUTLET( BeeUIButton, blogs );

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

- (void)selectActivities
{
    $(self.activities).ADD_CLASS( @"active" );
    $(self.blogs).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectBlogs
{
    $(self.activities).REMOVE_CLASS( @"active" );
    $(self.blogs).ADD_CLASS( @"active" );
    
    self.RELAYOUT();
}

@end
