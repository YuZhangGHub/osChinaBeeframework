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
//  FavoriteBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/15.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "FavoriteBoard_iPhone.h"
#import "oschina.h"
#import "FavoriteCell_iPhone.h"
#import "Tool.h"
#import "URLHandler.h"
#import "CommonNoResultCell.h"
#import "PullLoader.h"
#import "FootLoader.h"

#pragma mark -


@interface FavoriteBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation FavoriteBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list );
DEF_OUTLET( FavoriteBoardTab_iPhone,	tabbar );

@synthesize type = _type;

DEF_MODEL(FavoritesListModel, favoriteList)

- (void)load
{
    self.favoriteList = [FavoritesListModel modelWithObserver:self];
}

- (void)unload
{
    [self.favoriteList removeAllObservers];
    SAFE_RELEASE_MODEL(self.favoriteList);
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    //self.view.backgroundColor = HEX_RGB( 0x44db5e );
    
    self.type = FavoriteSoftware;
    
    self.navigationBarShown = YES;
    self.navigationBarTitle = @"收藏";
    
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
        if( self.favoriteList.loaded && self.favoriteList.favorits.count == 0)
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
            self.list.total = self.favoriteList.favorits.count;
            
            for( int i = 0; i < self.favoriteList.favorits.count; i++)
            {
                FAVORITE* acItem = [self.favoriteList.favorits objectAtIndex:i];
                BeeUIScrollItem * scrollItem = self.list.items[i];
                scrollItem.clazz = [FavoriteCell_iPhone class];
                scrollItem.data = acItem;
                scrollItem.order= 0;
                scrollItem.rule = BeeUIScrollLayoutRule_Tile;
                scrollItem.size = CGSizeAuto;
            }
        }
    };
    
    self.list.whenHeaderRefresh = ^
    {
        [self.favoriteList firstPage];
    };
    
    self.list.whenFooterRefresh = ^
    {
        [self.favoriteList nextPage];
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

ON_SIGNAL3( FavoritesListModel, RELOADING, signal )
{
    self.list.headerLoading = self.favoriteList.loaded;
    self.list.footerLoading = YES;
}

ON_SIGNAL3( FavoritesListModel, RELOADED, signal )
{
    self.list.headerLoading = NO;
    self.list.footerLoading = NO;
    self.list.footerMore = self.favoriteList.more;
    
    //	[self transitionFade];
    
    [self.list reloadData];
}

ON_SIGNAL3( FavoriteCell_iPhone, open_catalog, signal )
{
    FAVORITE* favor       = signal.sourceCell.data;
    //int       objId       = favor.objid;

    [URLHandler handleURL:favor.url parentBoard:self];
}

- (void) loadContents
{
    self.favoriteList.type = self.type;
    [self.favoriteList firstPage];
}

ON_SIGNAL3( FavoriteBoardTab_iPhone, software, signal )
{
    [self.tabbar selectSoftware];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    self.type = FavoriteSoftware;
    
    [self loadContents];
}

ON_SIGNAL3( FavoriteBoardTab_iPhone, topic, signal )
{
    [self.tabbar selectTopic];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    self.type = FavoriteTopic;
    
    [self loadContents];
}

ON_SIGNAL3( FavoriteBoardTab_iPhone, code, signal )
{
    [self.tabbar selectCode];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    self.type = FavoriteCode;
    
    [self loadContents];
}

ON_SIGNAL3( FavoriteBoardTab_iPhone, blog, signal )
{
    [self.tabbar selectBlog];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    self.type = FavoriteBlog;
    
    [self loadContents];
}

ON_SIGNAL3( FavoriteBoardTab_iPhone, news, signal )
{
    [self.tabbar selectNews];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    self.type = FavoriteNews;
    
    [self loadContents];
}

@end
