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
//  SearchBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/27.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "SearchBoard_iPhone.h"
#import "SearchBarCell_iPhone.h"
#import "ItemBoardCell_iPhone.h"
#import "DetailArticleBoard_iPhone.h"
#import "DetailBlogBoard_iPhone.h"
#import "DetailQuestionBoard_iPhone.h"
#import "SoftwareDetailBoard_iPhone.h"
#import "CommonNoResultCell.h"
#import "Tool.h"
#import "PullLoader.h"
#import "FootLoader.h"

#pragma mark -

@interface SearchBoard_iPhone()
{
	//<#@private var#>
    SearchBarCell_iPhone *	_titleSearch;
}
@end

@implementation SearchBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView,			list );
DEF_OUTLET( SearchBoardTab_iPhone,	    tabbar );

DEF_MODEL(SearchListModel, searchList)

- (void)load
{
    self.searchList = [SearchListModel modelWithObserver:self];
}

- (void)unload
{
    SAFE_RELEASE_MODEL(self.searchList);
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = [UIColor grayColor];
    
    self.navigationBarShown = YES;
    self.navigationBarLeft  = [UIImage imageNamed:@"navigation-back.png"];
    
    self.list.headerClass = [PullLoader class];
    self.list.headerShown = YES;
    
    self.list.footerClass = [FootLoader class];
    self.list.footerShown = YES;
    
    
//    self.list.lineCount = 1;
//    self.list.vertical = YES;
//    self.list.animationDuration = 0.25f;
//    self.list.baseInsets = bee.ui.config.baseInsets;
//    
    self.list.whenReloading = ^
    {
        if( self.searchList.loaded && self.searchList.items.count == 0)
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
            self.list.total = self.searchList.items.count;
            
            for( int i = 0; i < self.searchList.items.count; i++)
            {
                SEARCH_ITEM* acItem = [self.searchList.items objectAtIndex:i];
                BeeUIScrollItem * scrollItem = self.list.items[i];
                scrollItem.clazz = [ItemBoardCell_iPhone class];
                scrollItem.data = acItem;
                scrollItem.order= 0;
                scrollItem.rule = BeeUIScrollLayoutRule_Tile;
                scrollItem.size = CGSizeAuto;
            }
        }
    };

    self.list.whenHeaderRefresh = ^
    {
        [self.searchList firstPage];
    };
    
    self.list.whenFooterRefresh = ^
    {
        [self.searchList nextPage];
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
    //[bee.ui.appBoard hideTabbar];
    
    if ( nil == _titleSearch )
    {
//        _searchBackground = [[B1_ProductListSearchBackgroundCell_iPhone alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
//        [self.view insertSubview:_searchBackground atIndex:self.view.subviews.count];
        
        _titleSearch = [[SearchBarCell_iPhone alloc] initWithFrame:CGRectZero];
        _titleSearch.frame = CGRectMake(0, 0, self.view.width, 44.0f);
        self.navigationBarTitle = _titleSearch;
    }
    
    bee.ui.router.view.pannable = YES;
    self.searchList.type = SearchTypeSoftware;
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
    [self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

ON_SIGNAL3( SearchBoardTab_iPhone, software, signal )
{
    [self.tabbar selectSoftware];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    self.searchList.type = SearchTypeSoftware;
    
    self.searchList.content = _titleSearch.search_input.text;
    
    if([self.searchList.content length] > 0)
    {
        [self.searchList firstPage];
    }
}

ON_SIGNAL3( SearchBoardTab_iPhone, question, signal )
{
    [self.tabbar selectQuestion];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    self.searchList.type = SearchTypePost;
    
    self.searchList.content = _titleSearch.search_input.text;
    
    if([self.searchList.content length] > 0)
    {
        [self.searchList firstPage];
    }
}

ON_SIGNAL3( SearchBoardTab_iPhone, blog, signal )
{
    [self.tabbar selectBlog];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    self.searchList.type = SearchTypeBlog;
    
    self.searchList.content = _titleSearch.search_input.text;
    
    if([self.searchList.content length] > 0)
    {
        [self.searchList firstPage];
    }
}

ON_SIGNAL3( SearchBoardTab_iPhone, news, signal )
{
    [self.tabbar selectNews];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    self.searchList.type = SearchTypeNews;
    
    self.searchList.content = _titleSearch.search_input.text;
    
    if([self.searchList.content length] > 0)
    {
        [self.searchList firstPage];
    }
}

ON_SIGNAL3( SearchListModel, RELOADING, signal )
{
    self.list.headerLoading = self.searchList.loaded;
    self.list.footerLoading = YES;
}

ON_SIGNAL3( SearchListModel, RELOADED, signal )
{
    self.list.headerLoading = NO;
    self.list.footerLoading = NO;
    self.list.footerMore = self.searchList.more;
    
    //	[self transitionFade];
    
    [self.list reloadData];
}

ON_SIGNAL2( BeeUITextField, signal )
{
    BeeUITextField * textField = (BeeUITextField *)signal.source;
    
    if ( [signal is:BeeUITextField.RETURN] )
    {
        [textField endEditing:YES];
        
        self.searchList.content = textField.text;
        
        if([self.searchList.content length] > 0)
        {
            [self.searchList firstPage];
        }
    }
}

ON_SIGNAL3( ItemBoardCell_iPhone, mask, signal )
{
    SEARCH_ITEM* item       = signal.sourceCell.data;
    int objId               = item._objId;
    NSString*    type       = item.type;
    
    if([type equal:@"software"])
    {
        SoftwareDetailBoard_iPhone * board = [SoftwareDetailBoard_iPhone board];
        
        URL_ITEM* resolvedItem = [Tool resolveUrl:item.url];
        
        if(resolvedItem.type == SoftwareDetail)
        {
            board.detailSoftwareModel.softwareName = resolvedItem.attachment;
            //board.detailSoftwareModel. = objId;
            [self.stack pushBoard:board animated:YES];
        }
    }
    else if([type equal:@"news"])
    {
        DetailArticleBoard_iPhone* board = [DetailArticleBoard_iPhone board];
        board.articleModel.article_id    = objId;
        [self.stack pushBoard:board animated:YES];
    }
    else if([type equal:@"blog"])
    {
        DetailBlogBoard_iPhone* board = [DetailBlogBoard_iPhone board];
        board.articleModel._id        = objId;
        [self.stack pushBoard:board animated:YES];
    }
    else if([type equal:@"post"])
    {
        DetailQuestionBoard_iPhone* board = [DetailQuestionBoard_iPhone board];
        board.articleModel._id           = objId;
        [self.stack pushBoard:board animated:YES];
    }
}

@end
