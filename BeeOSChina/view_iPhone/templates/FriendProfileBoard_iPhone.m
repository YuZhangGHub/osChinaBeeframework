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
//  FriendProfileBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/15.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "FriendProfileBoard_iPhone.h"
#import "Tool.h"
#import "RelationRoutine.h"
#import "AppBoard_iPhone.h"
#import "NewTweetBoard_iPhone.h"
#import "EditMessageBoard_iPhone.h"

#pragma mark -

@interface FriendProfileBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation FriendProfileBoard_iPhone

@synthesize user            = _user;
@synthesize relationRoutine = _relationRoutine;

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    _relationRoutine         = [[RelationRoutine alloc] init];
    [self observeNotification:_relationRoutine.FAILED];
    [self observeNotification:_relationRoutine.SENDED];
    [self observeNotification:_relationRoutine.SENDING];
}

- (void)unload
{
    [self unobserveAllNotifications];
    _relationRoutine = nil;
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0xdfdfdf );
    
    self.navigationBarShown = YES;
    self.navigationBarTitle = @"好友资料";
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    bee.ui.router.view.pannable = YES;
    
    $(@"#avatar").IMAGE( _user.portrait );
    $(@"#last_login").TEXT( [Tool intervalSinceNow:_user.latestonline]);
    $(@"#gender").TEXT( _user.gender );
    $(@"#dev_location").TEXT( _user.from);
    $(@"#join_date").TEXT( _user.joindate);
    $(@"#dev_domain").TEXT( _user.expertise);
    $(@"#dev_platform").TEXT( _user.devplatform);
    
    [self setRightNavTitle];
}

-(void) setRightNavTitle
{    
    //2已关注 3未关注
    if(self.user.relation == 1 || self.user.relation == 2)
    {
        self.navigationBarRight = @"取消";
    }
    else if(self.user.relation == 3 || self.user.relation == 4)
    {
        self.navigationBarRight = @"关注";
    }
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
    bee.ui.router.view.pannable = NO;
}

ON_DID_DISAPPEAR( signal )
{
}

ON_NOTIFICATION3( RelationRoutine, SENDING, notification )
{
    
}

ON_NOTIFICATION3( RelationRoutine, SENDED, notification )
{
    NSString* lastRelation = notification.object;
    int       newRel      = lastRelation.intValue;
    
    if(newRel == 2)
    {
        [bee.ui.appBoard presentSuccessTips:@"关注成功!"];
    }
    else if(newRel == 3)
    {
        [bee.ui.appBoard presentSuccessTips:@"取消关注成功!"];
    }
    
    self.user.relation = newRel;
    [self setRightNavTitle];
}

ON_NOTIFICATION3( RelationRoutine, FAILED, notification )
{
    [bee.ui.appBoard presentSuccessTips:@"操作失败!"];
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
    if(self.user.relation == 1 || self.user.relation == 2)
    {
        //已关注，取消
        [self.relationRoutine removeFollow:self.user.uid.intValue];
    }
    else if(self.user.relation == 3 || self.user.relation == 4)
    {
        //未关注，关注
        [self.relationRoutine addFollow:self.user.uid.intValue];
    }
}

ON_SIGNAL3( FriendProfileBoard_iPhone, at, signal )
{
    NewTweetBoard_iPhone* board = [NewTweetBoard_iPhone board];
    board.atSomebody = [NSString stringWithFormat:@"@%@ ", self.user.name];

    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( FriendProfileBoard_iPhone, message, signal )
{
    EditMessageBoard_iPhone* board = [EditMessageBoard_iPhone board];
    board.receiverName             = self.user.name;
    board.receiverId               = self.user.uid.intValue;
    
    [self.stack pushBoard:board animated:YES];
}

@end
