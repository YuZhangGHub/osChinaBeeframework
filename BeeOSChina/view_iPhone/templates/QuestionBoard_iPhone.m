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
//  QuestionBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/22.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "QuestionBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "PostItemCell_iPhone.h"
#import "DetailQuestionBoard_iPhone.h"
#import "UserModel.h"
#import "PersonalBoard_iPhone.h"
#import "NewQuestionBoard_iPhone.h"
#import "CommonNoResultCell.h"
#import "FootLoader.h"
#import "PullLoader.h"

#pragma mark -

@interface QuestionBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation QuestionBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list );
DEF_OUTLET( QuestionBoardTab_iPhone, tabbar );
DEF_MODEL(PostListModel, postModel)

- (void)load
{
    self.postModel = [PostListModel modelWithObserver:self];
}

- (void)unload
{
    [self.postModel removeAllObservers];
    SAFE_RELEASE_MODEL(self.postModel);
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0x0076ff );
    
    self.navigationBarShown = YES;
    self.navigationBarTitle = @"问答";
    self.navigationBarLeft = [UIImage imageNamed:@"menu-button.png"];
    self.navigationBarRight = [UIImage imageNamed:@"questionBlue.png"];

    self.postModel.catalog = Question;
    
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
        if( self.postModel.loaded && self.postModel.posts.count == 0)
        {
            self.list.total     = 1;
            
            BeeUIScrollItem * item = self.list.items[0];
            item.clazz = [CommonNoResultCell class];
            item.size = self.list.size;
            item.rule = BeeUIScrollLayoutRule_Tile;
        }
        else
        {
            self.list.total = self.postModel.posts.count;
            
            for( int i = 0; i < self.postModel.posts.count; i++)
            {
                POST_ITEM* acItem = [self.postModel.posts objectAtIndex:i];
                BeeUIScrollItem * scrollItem = self.list.items[i];
                scrollItem.clazz = [PostItemCell_iPhone class];
                scrollItem.data = acItem;
                scrollItem.order= 0;
                scrollItem.rule = BeeUIScrollLayoutRule_Tile;
                scrollItem.size = CGSizeAuto;
            }
        }
    };
    
    self.list.whenHeaderRefresh = ^
    {
        [self.postModel firstPage];
    };
    
    self.list.whenFooterRefresh = ^
    {
        [self.postModel nextPage];
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
    [self.postModel firstPage];
    
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
        alert.message = @"请登陆后再发问题。";
        
        [alert addButtonTitle:@"登陆" signal:PersonalBoard_iPhone.SIGNIN_NOW];
        [alert addCancelTitle:@"返回"];
        [alert presentForController:self];
    }
    
    NewQuestionBoard_iPhone* board = [NewQuestionBoard_iPhone board];
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( QuestionBoardTab_iPhone, question, signal )
{
    [self.tabbar selectQuestion];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    self.postModel.catalog = Question;
    [self.postModel firstPage];
}

ON_SIGNAL3( QuestionBoardTab_iPhone, sharing, signal )
{
    [self.tabbar selectSharing];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    
    self.postModel.catalog = Sharing;
    [self.postModel firstPage];
}

ON_SIGNAL3( QuestionBoardTab_iPhone, synthesis, signal )
{
    [self.tabbar selectSynthesis];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];

    self.postModel.catalog = Synthesize;
    [self.postModel firstPage];
}

ON_SIGNAL3( QuestionBoardTab_iPhone, career, signal )
{
    [self.tabbar selectCareer];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];

    self.postModel.catalog = Carrer;
    [self.postModel firstPage];
}

ON_SIGNAL3( QuestionBoardTab_iPhone, site, signal )
{
    [self.tabbar selectSite];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];

    self.postModel.catalog = Site;
    [self.postModel firstPage];
}

ON_SIGNAL3( PostListModel, RELOADING, signal )
{
    self.list.headerLoading = self.postModel.loaded;
    self.list.footerLoading = YES;
}

ON_SIGNAL3( PostListModel, RELOADED, signal )
{
    self.list.headerLoading = NO;
    self.list.footerLoading = NO;
    self.list.footerMore = self.postModel.more;
    
    //	[self transitionFade];
    
    [self.list reloadData];
}

ON_SIGNAL3( PostItemCell_iPhone, mask, signal )
{
    POST* post       = signal.sourceCell.data;
    int postId       = post._id;
    
    DetailQuestionBoard_iPhone * board = [DetailQuestionBoard_iPhone board];
    board.articleModel._id = postId;
    [self.stack pushBoard:board animated:YES];
}


@end
