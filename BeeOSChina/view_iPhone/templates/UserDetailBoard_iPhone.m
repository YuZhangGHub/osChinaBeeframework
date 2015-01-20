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
//  FriendBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/15.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "UserDetailBoard_iPhone.h"
#import "UserDetailBoardTab_iPhone.h"
#import "oschina.h"
#import "FriendProfileBoard_iPhone.h"
#import "ItemBoardCell_iPhone.h"
#import "PersonalActiveCell_iPhone.h"
#import "FriendProfileBoard_iPhone.h"
#import "DetailBlogBoard_iPhone.h"
#import "DetailQuestionBoard_iPhone.h"
#import "DetailTweetBoard_iPhone.h"
#import "DetailArticleBoard_iPhone.h"
#import "CommonNoResultCell.h"
#import "PullLoader.h"
#import "FootLoader.h"

#pragma mark -

@interface UserDetailBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation UserDetailBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list )
DEF_OUTLET( UserDetailBoardTab_iPhone,	tabbar );

DEF_MODEL(UserBlogListModel, userBlogs)
DEF_MODEL(UserInfoModel, userInfo)

@synthesize isBlog = _isBlog;

- (void)load
{
    self.userBlogs = [UserBlogListModel modelWithObserver:self];
    self.userInfo  = [UserInfoModel modelWithObserver:self];
    _isBlog = 0;
}

- (void)unload
{
    [self.userBlogs removeAllObservers];
    [self.userInfo removeAllObservers];
    
    SAFE_RELEASE_MODEL(self.userBlogs);
    SAFE_RELEASE_MODEL(self.userInfo);
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0x44db5e );
    
    self.navigationBarShown = YES;
    self.navigationBarTitle = @"用户博客";
    self.navigationBarRight = @"资料";
    
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
        if( _isBlog)
        {
            if(self.userBlogs.loaded && self.userBlogs.blogs.count == 0)
            {
                self.list.total     = 1;
                self.list.lineCount = 1;
                
                BeeUIScrollItem * item = self.list.items[0];
                item.clazz = [CommonNoResultCell class];
                item.size = self.list.size;
                item.rule = BeeUIScrollLayoutRule_Tile;
            }
            else
            {
                self.list.total     = self.userBlogs.blogs.count;
                
                for(int i = 0; i < self.userBlogs.blogs.count; i++)
                {
                    BLOG_ITEM* blog = [self.userBlogs.blogs objectAtIndex:i];
                    BeeUIScrollItem * newsItem = self.list.items[i];
                    newsItem.clazz = [ItemBoardCell_iPhone class];
                    newsItem.data = blog;
                    newsItem.order= 0;
                    newsItem.rule = BeeUIScrollLayoutRule_Tile;
                    newsItem.size = CGSizeAuto;
                }
            }
        }
        else
        {
            if(self.userInfo.loaded && self.userInfo.user.activities.count == 0)
            {
                self.list.total     = 1;
                self.list.lineCount = 1;
                
                BeeUIScrollItem * item = self.list.items[0];
                item.clazz = [CommonNoResultCell class];
                item.size = self.list.size;
                item.rule = BeeUIScrollLayoutRule_Tile;
            }
            else
            {
                self.list.total     = self.userInfo.user.activities.count;
                
                for(int i = 0; i < self.userInfo.user.activities.count; i++)
                {
                    ACTIVITY* activity = [self.userInfo.user.activities objectAtIndex:i];
                    BeeUIScrollItem * newsItem = self.list.items[i];
                    newsItem.clazz = [PersonalActiveCell_iPhone class];
                    newsItem.data = activity;
                    newsItem.order= 0;
                    newsItem.rule = BeeUIScrollLayoutRule_Tile;
                    newsItem.size = CGSizeAuto;
                }
            }
        }
    };
    
    self.list.whenHeaderRefresh = ^
    {
        [self loadContent];
    };
    
    self.list.whenFooterRefresh = ^
    {
        [self loadNext];
    };
}

- (void) loadContent
{
    if(_isBlog)
    {
        [self.userBlogs firstPage];
    }
    else
    {
        [self.userInfo firstPage];
    }
}

- (void) loadNext
{
    if(_isBlog)
    {
        [self.userBlogs nextPage];
    }
    else
    {
        [self.userInfo nextPage];
    }
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self.userBlogs firstPage];
    bee.ui.router.view.pannable = YES;
    
    [self loadContent];
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
    FriendProfileBoard_iPhone* board = [FriendProfileBoard_iPhone board];
    board.user = self.userInfo.user;
    
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( UserBlogListModel, RELOADING, signal )
{
    self.list.headerLoading = self.userBlogs.loaded;
    self.list.footerLoading = YES;
}

ON_SIGNAL3( UserBlogListModel, RELOADED, signal )
{
    self.list.headerLoading = NO;
    self.list.footerLoading = NO;
    self.list.footerMore = self.userBlogs.more;
    
    //	[self transitionFade];
    
    [self.list reloadData];
}

ON_SIGNAL3( UserInfoModel, RELOADING, signal )
{
    self.list.headerLoading = self.userInfo.loaded;
    self.list.footerLoading = YES;
}

ON_SIGNAL3( UserInfoModel, RELOADED, signal )
{
    self.list.headerLoading = NO;
    self.list.footerLoading = NO;
    self.list.footerMore = self.userInfo.more;
    
    //	[self transitionFade];
    
    [self.list reloadData];
}

ON_SIGNAL3( UserDetailBoardTab_iPhone, activities, signal )
{
    [self.tabbar selectActivities];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    self.isBlog = 0;
    
    [self loadContent];
}

ON_SIGNAL3( UserDetailBoardTab_iPhone, blogs, signal )
{
    [self.tabbar selectBlogs];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    self.isBlog = 1;
    
    [self loadContent];
}

ON_SIGNAL3( PersonalActiveCell_iPhone, mask, signal )
{
    ACTIVITY* act          = signal.sourceCell.data;
    int activityId         = act.objectID;
    
    if (act.catalog == 4)
    {
        //Blog
        DetailBlogBoard_iPhone * board = [DetailBlogBoard_iPhone board];
        board.articleModel._id = activityId;
        [self.stack pushBoard:board animated:YES];
    }
    else if (act.catalog == 1)
    {
        //News
        DetailArticleBoard_iPhone * board = [DetailArticleBoard_iPhone board];
        board.articleModel.article_id = activityId;
        [self.stack pushBoard:board animated:YES];
    }
    else if(act.catalog == 2)
    {
        //Questions
        DetailQuestionBoard_iPhone * board = [DetailQuestionBoard_iPhone board];
        board.articleModel._id = activityId;
        [self.stack pushBoard:board animated:YES];
    }
    else if(act.catalog == 3)
    {
        //Tweet
        DetailTweetBoard_iPhone * board = [DetailTweetBoard_iPhone board];
        board.tweetModel._id = activityId;
        [self.stack pushBoard:board animated:YES];
    }
}

ON_SIGNAL3( ItemBoardCell_iPhone, mask, signal )
{
    BLOG* blog       = signal.sourceCell.data;
    int blogId       = blog._id;
    
    DetailBlogBoard_iPhone * board = [DetailBlogBoard_iPhone board];
    board.articleModel._id = blogId;
    [self.stack pushBoard:board animated:YES];
}

@end
