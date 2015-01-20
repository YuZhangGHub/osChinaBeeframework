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
//  MiscBoardCell_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/22.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "MiscBoardCell_iPhone.h"

#pragma mark -

@implementation MiscBoardCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUILabel,	label_account );
DEF_MODEL( UserModel, userModel )

- (void)load
{
    self.userModel = [UserModel modelWithObserver:self];
    [self observeNotification:UserModel.LOGIN];
    [self observeNotification:UserModel.LOGOUT];
}

- (void)unload
{
    SAFE_RELEASE_MODEL( self.userModel );
}

- (void)dataDidChanged
{
    // TODO: fill data
}

- (void)updateAccountLabel
{
    // TODO: custom layout here
    if([UserModel online] == YES)
    {
        self.label_account.text = @"我的资料（收藏/关注/粉丝)";
    }
    else
    {
        self.label_account.text = @"登陆";
    }
}

ON_NOTIFICATION3( UserModel, LOGIN, notification )
{
    [self updateAccountLabel];
}

ON_NOTIFICATION3( UserModel, LOGOUT, notification )
{
    [self updateAccountLabel];
}

- (void)layoutDidFinish
{
    [self updateAccountLabel];
}

@end
