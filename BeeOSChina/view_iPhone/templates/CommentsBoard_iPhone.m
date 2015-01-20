//
//	Powered by BeeFramework
//
//
//  CommentsBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/5.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "CommentsBoard_iPhone.h"
#import "SimpleCommentCell_iPhone.h"
#import "ReferCommentCell_iPhone.h"
#import "DetailCommentBoard_iPhone.h"
#import "EditCommentBoard_iPhone.h"
#import "UserModel.h"
#import "PersonalBoard_iPhone.h"
#import "CommonNoResultCell.h"
#import "PullLoader.h"
#import "FootLoader.h"

#pragma mark -

@interface CommentsBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation CommentsBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_MODEL( CommentsModel,	 commentList )
DEF_MODEL( BlogCommentsModel, blogCommentList)
DEF_OUTLET( BeeUIScrollView,			list );

@synthesize type       = _type;
@synthesize source     = _source;

- (void)load
{
    self.commentList = [CommentsModel modelWithObserver:self];
    self.blogCommentList = [BlogCommentsModel modelWithObserver:self];
    _type   = NormalComment;
    _source = FromNews;
    
    [self observeNotification:DetailCommentBoard_iPhone.COMMENT_REPLY];
    [self observeNotification:DetailCommentBoard_iPhone.BLOG_COMMENT_REPLY];
    
    [self observeNotification:EditCommentBoard_iPhone.COMMENT_PUB];
    [self observeNotification:EditCommentBoard_iPhone.BLOG_COMMENT_PUB];
}

- (void)unload
{
    [self.commentList removeAllObservers];
    [self.blogCommentList removeAllObservers];
    
    SAFE_RELEASE_MODEL(self.commentList);
    SAFE_RELEASE_MODEL(self.blogCommentList);
    
    [self unobserveAllNotifications];
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0x44db5e );
    
    self.navigationBarShown = YES;
    self.navigationBarTitle = @"评论";
    
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
        if(_type == BlogComment)
        {
            if(self.blogCommentList.loaded && self.blogCommentList.b_comments.count == 0)
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
                self.list.total     = self.blogCommentList.b_comments.count;
                
                for(int i = 0; i < self.blogCommentList.b_comments.count; i++)
                {
                    COMMENT* comment = [self.blogCommentList.b_comments objectAtIndex:i];
                    BeeUIScrollItem * newsItem = self.list.items[i];
                    newsItem.clazz = [SimpleCommentCell_iPhone class];
                    newsItem.data = comment;
                    newsItem.order= 0;
                    newsItem.rule = BeeUIScrollLayoutRule_Tile;
                    newsItem.size = CGSizeAuto;
                }
            }
        }
        else
        {
            if(self.commentList.loaded && self.commentList.comments.count == 0)
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
                self.list.total     = self.commentList.comments.count;
                
                for(int i = 0; i < self.commentList.comments.count; i++)
                {
                    COMMENT* comment = [self.commentList.comments objectAtIndex:i];
                    BeeUIScrollItem * newsItem = self.list.items[i];
                    newsItem.clazz = [SimpleCommentCell_iPhone class];
                    newsItem.data = comment;
                    newsItem.order= 0;
                    newsItem.rule = BeeUIScrollLayoutRule_Tile;
                    newsItem.size = CGSizeAuto;
                }
            }
        }
    };
    
    self.list.whenHeaderRefresh = ^
    {
        if(_type == NormalComment)
        {
            [self.commentList firstPage];
        }
        else if(_type == BlogComment)
        {
            [self.blogCommentList firstPage];
        }
    };
    
    self.list.whenFooterRefresh = ^
    {
        if(_type == NormalComment)
        {
            [self.commentList nextPage];
        }
        else if(_type == BlogComment)
        {
            [self.blogCommentList nextPage];
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
    if(_type == BlogComment)
    {
        [self.blogCommentList firstPage];
    }
    else
    {
        [self.commentList firstPage];
    }

    //Set nav bar right button
    if(_source == FromQuestion)
    {
        self.navigationBarRight = @"回帖";
    }
    else
    {
        self.navigationBarRight = @"评论";
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
    UserModel* userModel = [UserModel sharedInstance];
    
    if(userModel == nil) return;
    
    if([UserModel online] == NO)
    {
        BeeUIAlertView * alert = [BeeUIAlertView spawn];
        
        if(_source == FromQuestion)
        {
            alert.message = @"请登陆后再发回帖。";
        }
        else
        {
            alert.message = @"请登陆后再发评论。";
        }
        
        alert.title = @"";
        
        [alert addButtonTitle:@"登陆" signal:PersonalBoard_iPhone.SIGNIN_NOW];
        [alert addCancelTitle:@"返回"];
        [alert presentForController:self];
    }

    EditCommentBoard_iPhone * board = [EditCommentBoard_iPhone board];
    board.source    = _source;
    
    if(_source == FromBlog)
    {
        board.articleId = self.blogCommentList._id;
    }
    else
    {
        board.articleId = self.commentList._id;
    }
    
    [self.stack pushBoard:board animated:YES];
}

- (void) updateFirstComment : (COMMENT*) comment
{
    if([self.commentList.comments count] == 0)
    {
        [self.commentList.comments addObject:comment];
    }
    else
    {
        NSMutableArray* temp = [[NSMutableArray alloc] init];
        for(int i = 1; i < [self.commentList.comments count]; i++)
        {
            COMMENT* c = [self.commentList.comments objectAtIndex:i];
            [temp addObject:c];
        }
        
        [self.commentList.comments removeAllObjects];
        
        [self.commentList.comments addObject:comment];
        
        for(int i = 0; i < [temp count]; i++)
        {
            [self.commentList.comments addObject:[temp objectAtIndex:i]];
        }
    }
    
    [self.list reloadData];
}

- (void) updateBlogFirstComment : (COMMENT*) comment
{
    if([self.blogCommentList.b_comments count] == 0)
    {
        [self.blogCommentList.b_comments addObject:comment];
    }
    else
    {
        NSMutableArray* temp = [[NSMutableArray alloc] init];
        for(int i = 1; i < [self.blogCommentList.b_comments count]; i++)
        {
            COMMENT* c = [self.blogCommentList.b_comments objectAtIndex:i];
            [temp addObject:c];
        }
        
        [self.blogCommentList.b_comments removeAllObjects];
        
        [self.blogCommentList.b_comments addObject:comment];
        
        for(int i = 0; i < [temp count]; i++)
        {
            [self.blogCommentList.b_comments addObject:[temp objectAtIndex:i]];
        }
    }
    
    [self.list reloadData];
}

ON_NOTIFICATION3( DetailCommentBoard_iPhone, COMMENT_REPLY, notification )
{
    COMMENT* comment = notification.object;
    
    if(comment == nil) return;
    
    [self updateFirstComment:comment];
}

ON_NOTIFICATION3( DetailCommentBoard_iPhone, BLOG_COMMENT_REPLY, notification )
{
    COMMENT* comment = notification.object;
    
    if(comment == nil) return;
    
    [self updateBlogFirstComment:comment];
}

ON_NOTIFICATION3( EditCommentBoard_iPhone, COMMENT_PUB, notification )
{
    COMMENT* comment = notification.object;
    
    if(comment == nil) return;
    
    [self updateFirstComment:comment];
}

ON_NOTIFICATION3( EditCommentBoard_iPhone, BLOG_COMMENT_PUB, notification )
{
    COMMENT* comment = notification.object;
    
    if(comment == nil) return;
    
    [self updateBlogFirstComment:comment];
}

ON_SIGNAL3( CommentsModel, RELOADING, signal )
{
    self.list.headerLoading = self.commentList.loaded;
    self.list.footerLoading = YES;
}

ON_SIGNAL3( CommentsModel, RELOADED, signal )
{
    self.list.headerLoading = NO;
    self.list.footerLoading = NO;
    self.list.footerMore = self.commentList.more;
    
    //	[self transitionFade];
    
    [self.list reloadData];
}

ON_SIGNAL3( BlogCommentsModel, RELOADING, signal )
{
    self.list.headerLoading = self.blogCommentList.loaded;
    self.list.footerLoading = YES;
}

ON_SIGNAL3( BlogCommentsModel, RELOADED, signal )
{
    self.list.headerLoading = NO;
    self.list.footerLoading = NO;
    self.list.footerMore = self.blogCommentList.more;
    
    //	[self transitionFade];
    
    [self.list reloadData];
}

ON_SIGNAL3( SimpleCommentCell_iPhone, mask, signal )
{
    COMMENT* comment       = signal.sourceCell.data;
    
    DetailCommentBoard_iPhone * board = [DetailCommentBoard_iPhone board];
    board.comment = comment;
    board.source  = self.source;
    board.type    = self.type;
    
    if(_type == NormalComment)
    {
        board.articleId = self.commentList._id;
    }
    else
    {
        board.articleId = self.blogCommentList._id;
    }

    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( ReferCommentCell_iPhone, mask, signal )
{
    
}

@end
