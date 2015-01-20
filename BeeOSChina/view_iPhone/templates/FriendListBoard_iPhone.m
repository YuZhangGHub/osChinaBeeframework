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
//  FriendListBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/16.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "FriendListBoard_iPhone.h"
#import "oschina.h"
#import "FriendCell_iPhone.h"
#import "PersonalBoard_iPhone.h"
#import "UserDetailBoard_iPhone.h"
#import "CommonNoResultCell.h"
#import "PullLoader.h"
#import "FootLoader.h"

#pragma mark -

@interface FriendListBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation FriendListBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list );
DEF_OUTLET( FriendListBoardTab_iPhone,	tabbar );

DEF_MODEL(FriendsListModel, friendsList)
@synthesize relation = _relation;

- (void)load
{
    self.relation = 1;
    self.friendsList = [FriendsListModel modelWithObserver:self];
}

- (void)unload
{
    [self.friendsList removeAllObservers];
    SAFE_RELEASE_MODEL(self.friendsList);
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0x44db5e );
    
    self.navigationBarShown = YES;
    self.navigationBarTitle = @"好友";
    
    self.list.headerClass = [PullLoader class];
    self.list.headerShown = YES;
    
    self.list.footerClass = [FootLoader class];
    self.list.footerShown = YES;
    
    self.list.lineCount = 1;
    self.list.vertical = YES;
    self.list.animationDuration = 0.25f;
    self.list.baseInsets = bee.ui.config.baseInsets;
    
    self.list.whenReloading = ^
    {
        if( self.friendsList.loaded && self.friendsList.friends.count == 0)
        {
            self.list.lineCount = 1;
            self.list.total     = 1;
            
            BeeUIScrollItem * item = self.list.items[0];
            item.clazz = [CommonNoResultCell class];
            item.size = self.list.size;
            item.rule = BeeUIScrollLayoutRule_Tile;
        }
        else
        {
            self.list.total = self.friendsList.friends.count;
            
            for( int i = 0; i < self.friendsList.friends.count; i++)
            {
                FRIEND* acItem = [self.friendsList.friends objectAtIndex:i];
                BeeUIScrollItem * scrollItem = self.list.items[i];
                scrollItem.clazz = [FriendCell_iPhone class];
                scrollItem.data = acItem;
                scrollItem.order= 0;
                scrollItem.rule = BeeUIScrollLayoutRule_Tile;
                scrollItem.size = CGSizeAuto;
            }
        }
    };
    
    self.list.whenHeaderRefresh = ^
    {
        [self.friendsList firstPage];
    };
    
    self.list.whenFooterRefresh = ^
    {
        [self.friendsList nextPage];
    };
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self loadContents];
    
    if(self.relation == 1)
    {
        [self.tabbar selectFollowed];
    }
    else
    {
        [self.tabbar selectFans];
    }
    
    bee.ui.router.view.pannable = YES;
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

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

ON_SIGNAL3( FriendsListModel, RELOADING, signal )
{
    self.list.headerLoading = self.friendsList.loaded;
    self.list.footerLoading = YES;
}

ON_SIGNAL3( FriendsListModel, RELOADED, signal )
{
    self.list.headerLoading = NO;
    self.list.footerLoading = NO;
    self.list.footerMore = self.friendsList.more;
    
    //	[self transitionFade];
    
    [self.list reloadData];
}

- (void) loadContents
{
    self.friendsList.relation = self.relation;
    [self.friendsList firstPage];
}

ON_SIGNAL3( FriendCell_iPhone, mask, signal )
{
    UserDetailBoard_iPhone* board = [UserDetailBoard_iPhone board];
    
    FRIEND* frd                = signal.sourceCell.data;
    
    board.userInfo.hisuid      = frd.userid;
    board.userInfo.hisname     = frd.name;
    board.userBlogs.authorid   = frd.userid;
    board.userBlogs.authorname = frd.name;
    
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( FriendListBoardTab_iPhone, MyFollow, signal )
{
    [self.tabbar selectFollowed];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    self.relation = 1;
    
    [self loadContents];
}

ON_SIGNAL3( FriendListBoardTab_iPhone, MyFans, signal )
{
    [self.tabbar selectFans];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    self.relation = 0;
    
    [self loadContents];
}

@end
