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
//  PersonalBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/25.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "PersonalBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "UserModel.h"
#import "SignInBoard_iPhone.h"
#import "PersonalActiveCell_iPhone.h"
#import "PersonalMessageCell_iPhone.h"
#import "DetailBlogBoard_iPhone.h"
#import "DetailTweetBoard_iPhone.h"
#import "DetailArticleBoard_iPhone.h"
#import "DetailQuestionBoard_iPhone.h"
#import "NoticeRoutine.h"
#import "MessageBubbleBoard_iPhone.h"
#import "CommonNoResultCell.h"
#import "PullLoader.h"
#import "FootLoader.h"

#pragma mark -

@interface PersonalBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation PersonalBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_SIGNAL( SIGNIN_NOW )

DEF_OUTLET( BeeUIScrollView,			list );
DEF_OUTLET( PersonalBoardTab_iPhone,	    tabbar );

DEF_MODEL( ActiveListModel, activeModel)
DEF_MODEL( MessageListModel, messageModel)

@synthesize type           = _type;
@synthesize noticeRoutine  = _noticeRoutine;
@synthesize updatingNotice = _updatingNotice;

- (void)load
{
    self.activeModel = [ActiveListModel modelWithObserver:self];
    self.messageModel = [MessageListModel modelWithObserver:self];
    _type = All;
    
    _noticeRoutine         = [[NoticeRoutine alloc] init];
    [self observeNotification:_noticeRoutine.FAILED];
    [self observeNotification:_noticeRoutine.SENDED];
    [self observeNotification:_noticeRoutine.SENDING];
    [self observeNotification:_noticeRoutine.CLEARED];
    [self observeNotification:bee.ui.appBoard.NOTICE_UPDATE];
    
    _updatingNotice = NO;
}

- (void)unload
{
    [self.activeModel removeAllObservers];
    [self.messageModel removeAllObservers];
    
    SAFE_RELEASE_MODEL(self.activeModel);
    SAFE_RELEASE_MODEL(self.messageModel);
    
    [self unobserveAllNotifications];
    _noticeRoutine = nil;
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0x54c7fc );
    
    self.navigationBarShown = YES;
    self.navigationBarTitle = @"我的";
    self.navigationBarLeft = [UIImage imageNamed:@"menu-button.png"];
    
    //    self.list.lineCount = 1;
    //    self.list.animationDuration = 0.25f;
    //    self.list.baseInsets = bee.ui.config.baseInsets;
    
    self.list.headerClass = [PullLoader class];
    self.list.headerShown = YES;
    
    self.list.footerClass = [FootLoader class];
    self.list.footerShown = YES;
    
    self.list.lineCount = 1;
    self.list.vertical = YES;
    self.list.animationDuration = 0.25f;
    self.list.baseInsets = bee.ui.config.baseInsets;
    self.type = All;
    self.activeModel.catalog = self.type;
    
    self.list.whenReloading = ^
    {
        // 已加载，无数据
        if (_type == MyMessage)
        {
            if( self.messageModel.loaded && 0 == self.messageModel.messages.count)
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
                self.list.total = self.messageModel.messages.count;
                
                for (int i = 0; i < self.messageModel.messages.count; i++)
                {
                    MESSAGE* messageItem = [self.messageModel.messages objectAtIndex:i];
                    BeeUIScrollItem * msgItem = self.list.items[i];
                    msgItem.clazz = [PersonalMessageCell_iPhone class];
                    msgItem.data = messageItem;
                    msgItem.order= 0;
                    msgItem.rule = BeeUIScrollLayoutRule_Tile;
                    msgItem.size = CGSizeAuto;
                }
            }
        }
        else
        {
            if( self.activeModel.loaded && 0 == self.activeModel.actives.count)
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
                self.list.total = self.activeModel.actives.count;
                
                for( int i = 0; i < self.activeModel.actives.count; i++)
                {
                    ACTIVITY* acItem = [self.activeModel.actives objectAtIndex:i];
                    BeeUIScrollItem * scrollItem = self.list.items[i];
                    scrollItem.clazz = [PersonalActiveCell_iPhone class];
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
        if(_type == MyMessage)
        {
            [self.messageModel firstPage];
        }
        else
        {
            [self.activeModel firstPage];
        }
    };
    
    self.list.whenFooterRefresh = ^
    {
        if(_type == MyMessage)
        {
            [self.messageModel nextPage];
        }
        else
        {
            [self.activeModel nextPage];
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
    [self.activeModel firstPage];
    
    bee.ui.router.view.pannable = YES;
}

ON_DID_APPEAR( signal )
{
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
}

ON_WILL_DISAPPEAR( signal )
{
     bee.ui.router.view.pannable = NO;
    
    if(_type == MyMessage)
    {
        [self.messageModel firstPage];
    }
    else
    {
        [self.activeModel firstPage];
    }
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
}

ON_SIGNAL3( PersonalBoard_iPhone, SIGNIN_NOW, signal)
{
    [bee.ui.appBoard showLogin];
}

ON_SIGNAL3( PersonalBoardTab_iPhone, all, signal )
{
    [self.tabbar selectAll];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    self.type = All;
    self.activeModel.catalog = self.type;
    
    [self.activeModel firstPage];
    //[self.list reloadData];
}

ON_SIGNAL3( PersonalBoardTab_iPhone, at, signal )
{
    [self.tabbar selectAt];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    self.type = AtMe;
    self.activeModel.catalog = self.type;
    
    [self clearNotice];
    
    [self.activeModel firstPage];
    //[self.list reloadData];
}

ON_SIGNAL3( PersonalBoardTab_iPhone, comments, signal )
{
    [self.tabbar selectComments];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    self.type = MyComment;
    self.activeModel.catalog = self.type;
    
    [self clearNotice];
    
    [self.activeModel firstPage];
    //[self.list reloadData];
}

ON_SIGNAL3( PersonalBoardTab_iPhone, selfstuff, signal )
{
    [self.tabbar selectSelfStuff];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    self.type = MyBlog;
    self.activeModel.catalog = self.type;
    
    [self.activeModel firstPage];
    //[self.list reloadData];
}

ON_SIGNAL3( PersonalBoardTab_iPhone, message, signal )
{
    [self.tabbar selectMessage];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    [self.list scrollToIndex:0 animated:YES];
    self.type = MyMessage;

    [self clearNotice];
    
    [self.messageModel firstPage];
    //[self.list reloadData];
}

ON_SIGNAL3( ActiveListModel, RELOADING, signal )
{
    self.list.headerLoading = self.activeModel.loaded;
    self.list.footerLoading = YES;
}

ON_SIGNAL3( ActiveListModel, RELOADED, signal )
{
    self.list.headerLoading = NO;
    self.list.footerLoading = NO;
    self.list.footerMore = self.activeModel.more;
    
    //	[self transitionFade];
    
    [self.list reloadData];
}

ON_SIGNAL3( MessageListModel, RELOADING, signal )
{
    self.list.headerLoading = self.messageModel.loaded;
    self.list.footerLoading = YES;
}

ON_SIGNAL3( MessageListModel, RELOADED, signal )
{
    self.list.headerLoading = NO;
    self.list.footerLoading = NO;
    self.list.footerMore = self.messageModel.more;
    
    //	[self transitionFade];
    
    [self.list reloadData];
}

ON_SIGNAL3( PersonalMessageCell_iPhone, mask, signal )
{
    MESSAGE* message                 = signal.sourceCell.data;
    
    MessageBubbleBoard_iPhone* board = [MessageBubbleBoard_iPhone board];
    board.friendName                 = message.friendname;
    board.friendID                   = message.friendid;
    
    [self.stack pushBoard:board animated:YES];
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

- (void) clearNotice
{
    if( _updatingNotice == NO )
    {
        int noticeClearType = -1;
        switch (self.type) {
            case AtMe:
                noticeClearType = 1;
                break;
            case MyComment:
                noticeClearType = 3;
                break;
            case MyMessage:
                noticeClearType = 2;
                break;
            default:
                break;
        }
    
        [_noticeRoutine clearNotice:noticeClearType];
    }
}

ON_NOTIFICATION3( NoticeRoutine, SENDING, notification )
{
    
}

ON_NOTIFICATION3( NoticeRoutine, SENDED, notification )
{
    USER_NOTICE* notice = notification.object;
    
    [_tabbar setAtCount:notice.atmeCount.intValue];
    [_tabbar setCommentCount:notice.reviewCount.intValue];
    [_tabbar setMessageCount:notice.msgCount.intValue];
    
    _updatingNotice = NO;
}

ON_NOTIFICATION3( NoticeRoutine, FAILED, notification )
{
    //[bee.ui.appBoard presentSuccessTips:@"操作失败!"];
}

ON_NOTIFICATION3( NoticeRoutine, CLEARED, notification )
{
    NSString* typeString = notification.object;
    int       type       = typeString.intValue;
    
    if(type == 1)
    {
        [_tabbar setAtCount:0];
    }
    else if(type == 3)
    {
        [_tabbar setCommentCount:0];
    }
    else if(type == 2)
    {
        [_tabbar setMessageCount:0];
    }
}

ON_NOTIFICATION3( AppBoard_iPhone, NOTICE_UPDATE, notification )
{
    _updatingNotice = YES;
    [_noticeRoutine getNotice];
}

@end
