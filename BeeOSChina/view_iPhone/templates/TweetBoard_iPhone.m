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
//  TweetBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/25.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "TweetBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "TweetModel.h"
#import "TweetCell_iPhone.h"
#import "UserModel.h"
#import "PersonalBoard_iPhone.h"
#import "DetailTweetBoard_iPhone.h"
#import "TweetImageCell_iPhone.h"
#import "NewTweetBoard_iPhone.h"
#import "CommonNoResultCell.h"
#import "PullLoader.h"
#import "FootLoader.h"

#pragma mark -

@interface TweetBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation TweetBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView,			list );
DEF_OUTLET( TweetBoardTab_iPhone,	    tabbar );

DEF_MODEL(TweetListModel, tweetListModel)

- (void)load
{
    self.tweetListModel = [TweetListModel modelWithObserver:self];
}

- (void)unload
{
    SAFE_RELEASE_MODEL(self.tweetListModel);
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0xff9600 );
    
    self.navigationBarShown = YES;
    self.navigationBarTitle = @"动弹";
    self.navigationBarLeft  = [UIImage imageNamed:@"menu-button.png"];
    self.navigationBarRight = [UIImage imageNamed:@"tweetBlue.png"];
    
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
        if( self.tweetListModel.loaded && self.tweetListModel.feedArray.count == 0)
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
            self.list.total = self.tweetListModel.feedArray.count;
            
            for( int i = 0; i < self.tweetListModel.feedArray.count; i++)
            {
                TWEET_ITEM* acItem = [self.tweetListModel.feedArray objectAtIndex:i];
                BeeUIScrollItem * scrollItem = self.list.items[i];
                
                if([acItem.imgSmall equal:@""] == NO)
                {
                    scrollItem.clazz = [TweetImageCell_iPhone class];
                }
                else
                {
                    scrollItem.clazz = [TweetCell_iPhone class];
                }
                
                scrollItem.data = acItem;
                scrollItem.order= 0;
                scrollItem.rule = BeeUIScrollLayoutRule_Tile;
                scrollItem.size = CGSizeAuto;
            }
        }
    };
    
    self.list.whenHeaderRefresh = ^
    {
        [self.tweetListModel firstPage];
    };
    
    self.list.whenFooterRefresh = ^
    {
        [self.tweetListModel nextPage];
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
    self.tweetListModel.uid = 0;
    [self.tweetListModel firstPage];
    
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
    [[AppBoard_iPhone sharedInstance] showMenu];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
    UserModel* userModel = [UserModel sharedInstance];
    
    if(userModel == nil) return;
    
    if([UserModel online] == NO)
    {
        BeeUIAlertView * alert = [BeeUIAlertView spawn];
        
        alert.title = @"";
        alert.message = @"请登陆后再发动弹。";
        
        [alert addButtonTitle:@"登陆" signal:PersonalBoard_iPhone.SIGNIN_NOW];
        [alert addCancelTitle:@"返回"];
        [alert presentForController:self];
    }

    
    NewTweetBoard_iPhone * board = [NewTweetBoard_iPhone board];
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( TweetBoardTab_iPhone, newtweet, signal )
{
    [self.tabbar selectNewTweet];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    //[self.list reloadData];
    self.tweetListModel.uid = 0;
    
    [self.tweetListModel firstPage];
}

ON_SIGNAL3( TweetBoardTab_iPhone, hottweet, signal )
{
    [self.tabbar selectHotTweet];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    //[self.list reloadData];
    
    self.tweetListModel.uid = -1;
    
    [self.tweetListModel firstPage];
}

ON_SIGNAL3( TweetBoardTab_iPhone, mytweet, signal )
{
    [self.tabbar selectMyTweet];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    //[self.list reloadData];
    
    UserModel* userModel = [UserModel sharedInstance];
    
    if(userModel == nil) return;
    
    if([UserModel online] == NO)
    {
        BeeUIAlertView * alert = [BeeUIAlertView spawn];
        
        alert.title = @"";
        alert.message = @"请登陆后查看信息";
        
        [alert addButtonTitle:@"登陆" signal:PersonalBoard_iPhone.SIGNIN_NOW];
        [alert addCancelTitle:@"返回"];
        [alert presentForController:self];
    }
    
    self.tweetListModel.uid = userModel.user.uid.intValue;
    [self.tweetListModel firstPage];
}

ON_SIGNAL3( TweetListModel, RELOADING, signal )
{
    self.list.headerLoading = self.tweetListModel.loaded;
    self.list.footerLoading = YES;
}

ON_SIGNAL3( TweetListModel, RELOADED, signal )
{
    self.list.headerLoading = NO;
    self.list.footerLoading = NO;
    self.list.footerMore = self.tweetListModel.more;
    
    //	[self transitionFade];
    self.list.total = 0;
    [self.list reloadData];
}

ON_SIGNAL3( TweetCell_iPhone, mask, signal )
{
    TWEET* tweet     = signal.sourceCell.data;
    int tweetId      = tweet._id;
    
    DetailTweetBoard_iPhone * board = [DetailTweetBoard_iPhone board];
    board.tweetModel._id = tweetId;
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( TweetImageCell_iPhone, mask, signal )
{
    TWEET* tweet     = signal.sourceCell.data;
    int tweetId      = tweet._id;
    
    DetailTweetBoard_iPhone * board = [DetailTweetBoard_iPhone board];
    board.tweetModel._id = tweetId;
    [self.stack pushBoard:board animated:YES];
}

@end
