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
//  NewsBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/22.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "NewsBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "SearchBoard_iPhone.h"
#import "ItemBoardCell_iPhone.h"
#import "DetailArticleBoard_iPhone.h"
#import "DetailBlogBoard_iPhone.h"
#import "oschina.h"
#import "UserModel.h"
#import "BeCollectionCell.h"
#import "TestCell.h"
#import "CommonNoResultCell.h"
#import "PullLoader.h"
#import "FootLoader.h"

#pragma mark -

@interface NewsBoard_iPhone()
{
}
@end

@implementation NewsBoard_iPhone
{
}

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView,			list );
DEF_OUTLET( NewsBoardTab_iPhone,	    tabbar );
DEF_MODEL( NewsListModel,	news )
DEF_MODEL( BlogListModel, blogList)

@synthesize type = _type;

- (void)load
{
    self.news = [NewsListModel modelWithObserver:self];
    self.blogList = [BlogListModel modelWithObserver:self];
}

- (void)unload
{
    [self.news removeAllObservers];
    [self.blogList removeAllObservers];;
    
    SAFE_RELEASE_MODEL(self.news);
    SAFE_RELEASE_MODEL(self.blogList);
}

- (void) loadNews
{
    [self.news firstPage];
}

- (void) loadBlogs
{
    self.blogList.type = Blog;
    [self.blogList firstPage];
}

- (void) loadRecommends
{
    self.blogList.type = Recommend;
    [self.blogList firstPage];
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0x44db5e );
    
    self.navigationBarShown = YES;
    self.navigationBarTitle = @"资讯";
    self.navigationBarLeft  = [UIImage imageNamed:@"menu-button.png"];
    self.navigationBarRight = [UIImage imageNamed:@"footer_search_icon.png"];
    
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
        if(self.type == News)
        {
            if( self.news.loaded && self.news.news.count == 0)
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
                self.list.total = self.news.news.count;
                
                for( int i = 0; i < self.news.news.count; i++)
                {
                    NEWS* acItem = [self.news.news objectAtIndex:i];
                    BeeUIScrollItem * scrollItem = self.list.items[i];
                    scrollItem.clazz = [ItemBoardCell_iPhone class];
                    scrollItem.data = acItem;
                    scrollItem.order= 0;
                    scrollItem.rule = BeeUIScrollLayoutRule_Tile;
                    scrollItem.size = CGSizeAuto;
                }
            }
        }
        else
        {
            if( self.blogList.loaded && self.blogList.blogs.count == 0)
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
                self.list.total = self.blogList.blogs.count;
                
                for( int i = 0; i < self.blogList.blogs.count; i++)
                {
                    BLOG_ITEM* acItem = [self.blogList.blogs objectAtIndex:i];
                    BeeUIScrollItem * scrollItem = self.list.items[i];
                    scrollItem.clazz = [ItemBoardCell_iPhone class];
                    scrollItem.data = acItem;
                    scrollItem.order= 0;
                    scrollItem.rule = BeeUIScrollLayoutRule_Tile;
                    scrollItem.size = CGSizeAuto;
                }
            }
        }

    };
    
    self.list.whenHeaderRefresh = ^
    {
        if(self.type == News)
        {
            [self.news firstPage];
        }
        else
        {
            [self.blogList firstPage];
        }
    };
    
    self.list.whenFooterRefresh = ^
    {
        if(self.type == News)
        {
            [self.news nextPage];
        }
        else
        {
            [self.blogList nextPage];
        }
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
//    [self.list setDelegate:self];
//    [self.list setDataSource:self];
    
    [self loadNews];
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
    SearchBoard_iPhone * board = [[SearchBoard_iPhone alloc] init];
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( NewsBoardTab_iPhone, uptodatenews, signal )
{
    [self.tabbar selectNews];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    self.type = News;
    [self loadNews];
}

ON_SIGNAL3( NewsBoardTab_iPhone, uptodateblog, signal )
{
    [self.tabbar selectBlogs];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    self.type = Blog;
    [self loadBlogs];
}

ON_SIGNAL3( NewsBoardTab_iPhone, recommendation, signal )
{
    [self.tabbar selectRecommendations];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    self.type = Recommend;
    [self loadRecommends];
}

ON_SIGNAL3( NewsListModel, RELOADING, signal )
{
    self.list.headerLoading = self.news.loaded;
    self.list.footerLoading = YES;
}

ON_SIGNAL3( NewsListModel, RELOADED, signal )
{
    self.list.headerLoading = NO;
    self.list.footerLoading = NO;
    self.list.footerMore = self.news.more;
    
    //	[self transitionFade];
    
    [self.list reloadData];
}

ON_SIGNAL3( BlogListModel, RELOADING, signal )
{
    self.list.headerLoading = self.blogList.loaded;
    self.list.footerLoading = YES;
}

ON_SIGNAL3( BlogListModel, RELOADED, signal )
{
    self.list.headerLoading = NO;
    self.list.footerLoading = NO;
    self.list.footerMore = self.blogList.more;
    
    //	[self transitionFade];
    
    [self.list reloadData];
}

ON_SIGNAL3( ItemBoardCell_iPhone, mask, signal )
{
    if(self.type == News)
    {
        NEWS* news       = signal.sourceCell.data;
        NSNumber* newsId = news.id;
    
        DetailArticleBoard_iPhone * board = [DetailArticleBoard_iPhone board];
        board.articleModel.article_id = newsId.intValue;
        [self.stack pushBoard:board animated:YES];
    }
    else
    {
        BLOG* blog       = signal.sourceCell.data;
        int blogId       = blog._id;
        
        DetailBlogBoard_iPhone * board = [DetailBlogBoard_iPhone board];
        board.articleModel._id = blogId;
        [self.stack pushBoard:board animated:YES];
    }
}

@end
