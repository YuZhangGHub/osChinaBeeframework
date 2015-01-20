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
//  FriendListBoardTab_iPhoneCell.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/16.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "FriendListBoardTab_iPhone.h"

#pragma mark -

@implementation FriendListBoardTab_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIButton, MyFollow );
DEF_OUTLET( BeeUIButton, MyFans );

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

- (void)selectFollowed
{
    $(self.MyFollow).ADD_CLASS( @"active" );
    $(self.MyFans).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectFans
{
    $(self.MyFollow).REMOVE_CLASS( @"active" );
    $(self.MyFans).ADD_CLASS( @"active" );
    
    self.RELAYOUT();
}

@end
