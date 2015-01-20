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
//  SoftwareBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/24.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "SoftwareBoard_iPhone.h"
#import "SoftwareCatalogCell_iPhone.h"
#import "SoftwareItemCell_iPhone.h"
#import "SoftwareDetailBoard_iPhone.h"
#import "CommonNoResultCell.h"
#import "oschina.h"
#import "Tool.h"
#import "PullLoader.h"
#import "FootLoader.h"

#pragma mark -

@interface SoftwareBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation SoftwareBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list )
DEF_OUTLET( SoftwareBoardTab_iPhone,	tabbar )

DEF_MODEL( SoftwareTypeListModel,	types )
DEF_MODEL( SoftwareListModel,	items )

@synthesize isTagList  = _isTagList;
@synthesize currentTag = _currentTag;
@synthesize parentTag  = _parentTag;

- (void)load
{
    _isTagList      = YES;
    self.currentTag = 0;
    _parentTag      = -1;
    self.types = [SoftwareTypeListModel modelWithObserver:self];
    self.items = [SoftwareListModel modelWithObserver:self];
}

- (void)unload
{
    [self.types removeAllObservers];
    [self.items removeAllObservers];
    
    SAFE_RELEASE_MODEL(self.types);
    SAFE_RELEASE_MODEL(self.items);
}

- (void) getSWRootTypes
{
    self.currentTag = 0;
    self.types.tag = self.currentTag;
    [self.types firstPage];
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.navigationBarShown = YES;
    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.navigationBarTitle = @"软件";
    
    [self getSWRootTypes];
    
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
        if(self.isTagList)
        {
            if( self.types.loaded && self.types.types.count == 0)
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
                self.list.total = self.types.types.count;
                
                for( int i = 0; i < self.types.types.count; i++)
                {
                    SOFTWARE_TYPE* acItem = [self.types.types objectAtIndex:i];
                    BeeUIScrollItem * scrollItem = self.list.items[i];
                    scrollItem.clazz = [SoftwareCatalogCell_iPhone class];
                    scrollItem.data = acItem;
                    scrollItem.order= 0;
                    scrollItem.rule = BeeUIScrollLayoutRule_Tile;
                    scrollItem.size = CGSizeAuto;
                }
            }
        }
        else
        {
            if( self.items.loaded && self.items.softwares.count == 0)
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
                self.list.total = self.items.softwares.count;
                
                for( int i = 0; i < self.items.softwares.count; i++)
                {
                    SOFTWARE_ITEM* acItem = [self.items.softwares objectAtIndex:i];
                    BeeUIScrollItem * scrollItem = self.list.items[i];
                    scrollItem.clazz = [SoftwareItemCell_iPhone class];
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
        if(self.isTagList)
        {
            [self.types firstPage];
        }
        else
        {
            [self.items firstPage];
        }
    };
    
    self.list.whenFooterRefresh = ^
    {
        if(self.isTagList)
        {
            [self.types nextPage];
        }
        else
        {
            [self.items nextPage];
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
    [self.list reloadData];
    
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
    if(_parentTag == -1)
    {
        [self.stack popBoardAnimated:YES];
    }
    else if(_parentTag == 0)
    {
        self.currentTag         = _parentTag;
        self.parentTag          = -1;
        self.types.tag          = self.currentTag;
        _isTagList              = true;
        [self.types firstPage];
    }
    else
    {
        self.currentTag         = _parentTag;
        self.parentTag          = 0;
        self.types.tag          = self.currentTag;
        _isTagList              = true;
        [self.types firstPage];
    }
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

ON_SIGNAL3( SoftwareBoardTab_iPhone, software_category, signal )
{
    [self.tabbar selectCategory];
    
    self.items.searchTag = @"";
    self.isTagList = YES;
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    [self getSWRootTypes];
}

ON_SIGNAL3( SoftwareBoardTab_iPhone, software_recommend, signal )
{
    [self.tabbar selectRecommend];
    
    self.items.searchTag = @"recommend";
    self.isTagList = NO;
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    [self.items firstPage];
}

ON_SIGNAL3( SoftwareBoardTab_iPhone, software_recent, signal )
{
    [self.tabbar selectRecent];
    
    //_selectedIndex = -1;
    self.items.searchTag = @"time";
    self.isTagList = NO;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    [self.items firstPage];
}

ON_SIGNAL3( SoftwareBoardTab_iPhone, software_hot, signal )
{
    [self.tabbar selectHot];
    
    //_selectedIndex = -1;
    self.items.searchTag = @"view";
    self.isTagList = NO;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    [self.items firstPage];
}

ON_SIGNAL3( SoftwareBoardTab_iPhone, software_cn, signal )
{
    [self.tabbar selectCn];
    
    //_selectedIndex = -1;
    self.items.searchTag = @"list_cn";
    self.isTagList = NO;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    [self.items firstPage];
}

ON_SIGNAL3( SoftwareListModel, RELOADING, signal )
{
    self.list.headerLoading = self.items.loaded;
    self.list.footerLoading = YES;
}

ON_SIGNAL3( SoftwareListModel, RELOADED, signal )
{
    self.list.headerLoading = NO;
    self.list.footerLoading = NO;
    self.list.footerMore = self.items.more;
    self.isTagList          = NO;
    
    //	[self transitionFade];
    
    [self.list reloadData];
}

ON_SIGNAL3( SoftwareTypeListModel, RELOADING, signal )
{
    self.list.headerLoading = self.types.loaded;
    self.list.footerLoading = YES;
}

ON_SIGNAL3( SoftwareTypeListModel, RELOADED, signal )
{
    self.list.headerLoading = NO;
    self.list.footerLoading = NO;
    self.list.footerMore = self.types.more;
    
    //	[self transitionFade];
    
    [self.list reloadData];
}

ON_SIGNAL3( SoftwareCatalogCell_iPhone, open_catalog, signal )
{
    SOFTWARE_TYPE* type     = signal.sourceCell.data;
    
    self.parentTag          = self.currentTag;
    
    if(self.currentTag == 0)
    {
        self.currentTag         = type.tag.intValue;
        self.types.tag          = self.currentTag;
        [self.types firstPage];
    }
    else
    {
        self.currentTag         = type.tag.intValue;
        self.items.searchTag    = [NSString stringWithFormat:@"%d", self.currentTag];
        [self.items firstPage];
    }
}
ON_SIGNAL3( SoftwareItemCell_iPhone, open_software, signal )
{
    SOFTWARE_ITEM* item                    = signal.sourceCell.data;
    SoftwareDetailBoard_iPhone * board     = [SoftwareDetailBoard_iPhone board];
    
    URL_ITEM* resolvedItem = [Tool resolveUrl:item.url];
    
    if(resolvedItem.type == SoftwareDetail)
    {
        board.detailSoftwareModel.softwareName = resolvedItem.attachment;
        //board.detailSoftwareModel. = objId;
        [self.stack pushBoard:board animated:YES];
    }
}

@end
