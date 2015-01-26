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
//  DetailCommentBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/5.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "DetailCommentBoard_iPhone.h"
#import "Tool.h"
#import "UserModel.h"
#import "PersonalBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "UserModel.h"

#pragma mark -

@interface DetailCommentBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation DetailCommentBoard_iPhone

@synthesize comment     = _comment;
@synthesize inputCell   = _inputCell;
@synthesize type        = _type;
@synthesize articleId   = _articleId;
@synthesize source      = _source;

DEF_NOTIFICATION( COMMENT_REPLY )
DEF_NOTIFICATION( BLOG_COMMENT_REPLY )

- (void)load
{
    self.isToolbarHiden = YES;
    _type               = NormalComment;
    _articleId          = 0;
    _source             = FromNews;
}

- (void)unload
{
    
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.navigationBarShown = YES;
    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    UIBarButtonItem *item = (UIBarButtonItem*)self.navigationBarLeft;
    item.title = @"评论";
    super.title = @"评论详情";
    self.navigationBarRight = @"回复";
    
    if (_inputCell == nil )
    {
        _inputCell = [[TextInputCell_iPhone alloc] init];
        _inputCell.autoresizesSubviews = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        [self.view addSubview:_inputCell];
    }
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
    int inputHeight = 50.0f;
    
    CGRect frame = self.view.frame;
    frame.size.height -= inputHeight;
    frame.size.height -= 24;
    if ( IOS7_OR_EARLIER )
    {
        frame.origin.y = 0;
    }
    
    frame.origin.y += frame.size.height;
    frame.size.height = inputHeight;
    _inputCell.frame = frame;
    
    self.webView.scalesPageToFit = NO;

}

ON_WILL_APPEAR( signal )
{
    [self loadContent];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
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
    if([UserModel online] == NO)
    {
        [bee.ui.appBoard presentSuccessTips:@"请先登录!"];
    }
    
    if( _type == NormalComment)
    {
        [self replyComment];
    }
    else
    {
        [self replyBlogComment];
    }
}

-(void) loadContent
{
    if(_comment == nil)
    {
        return;
    }
    
    NSString *first = [NSString stringWithFormat:@"<div style='color:#0D6DA8;font-size:16px'>%@ 发表于%@</div>", _comment.author, _comment.pubDate];
    
    NSString *second = [NSString stringWithFormat:@"<div style='font-size:15px;line-height:20px'>%@</div>",[Tool MyRegularExpressions:_comment.content]];
    
    NSString *three = @"";
    if ([_comment.replies count]>0) {
        three = [NSString stringWithFormat:@"<br/><div style='font-size:14px;line-height:19px'>-- 共有%d条评论 --</div><div style='font-size:13px;color:#888888;'>", [_comment.replies count]];
        for (NSString *r in _comment.replies) {
            three = [NSString stringWithFormat:@"%@%@<p/>",three,r];
        }
        three = [NSString stringWithFormat:@"%@</div>", three];
    }
    NSString* html = [NSString stringWithFormat:@"<body style='background-color:#EBEBF3'>%@%@%@</body>", first, second,three];
    
    self.htmlString = html;
}

- (void) replyBlogComment
{
    UserModel* uModel = [UserModel sharedInstance];
    
    if(uModel == nil || uModel.user == nil || uModel.user.uid == nil)
    {
        return;
    }
    
    [API_BLOG_COMMENT_PUB cancel];
    
    API_BLOG_COMMENT_PUB * api = [API_BLOG_COMMENT_PUB apiWithResponder:self];
    
    int uid       = [UserModel sharedInstance].user.uid.intValue;
    NSString* msg = _inputCell.input_comment.text;
    
    api.INPUT( @"content", msg );
    api.INPUT( @"blog", [NSString stringWithFormat:@"%d", _articleId]);
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", uid]);
    api.INPUT( @"reply_id", [NSString stringWithFormat:@"%d", self.comment._id]);
    api.INPUT( @"objuid", self.comment.authorid);
    
    @weakify( api );
    
    api.whenUpdate = ^
    {
        @normalize( api );
        
        if ( api.sending )
        {
        }
        else if ( api.succeed )
        {
            //            if ( ERROR_CODE_OK != api.resp.resultCode.intValue )
            //            {
            //                [self sendUISignal:self.RELOADED];
            //            }
            //            else
            {
                //Need not update list ui.
                RESULT* res      = api.result;
                COMMENT* comment = api.resp;
                
                if(res.errorCode == 1)
                {
                    [bee.ui.appBoard presentSuccessTips:@"发送评论成功!"];
                    
                    //Todo:: add comment to the comment list
                    [self postNotification:self.BLOG_COMMENT_REPLY withObject:comment];
                    [self.stack popBoardAnimated:YES];
                }
                else
                {
                    [bee.ui.appBoard presentSuccessTips:@"发送评论失败!"];
                }
            }
        }
        else if ( api.failed )
        {
        }
        //    else if ( api.cancelled )
        //    {
        //      [self sendUISignal:self.RELOADED];
        //    }
    };
    
    [api send];
}

- (void) replyComment
{
    UserModel* uModel = [UserModel sharedInstance];
    
    if(uModel == nil || uModel.user == nil || uModel.user.uid == nil)
    {
        return;
    }
    
    [API_COMMENT_REPLY cancel];
    
    API_COMMENT_REPLY * api = [API_COMMENT_REPLY apiWithResponder:self];
    
    int uid       = [UserModel sharedInstance].user.uid.intValue;
    NSString* msg = _inputCell.input_comment.text;
    
    api.INPUT( @"content", msg );
    api.INPUT( @"id", [NSString stringWithFormat:@"%d", _articleId]);
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", uid]);
    api.INPUT( @"replyid", [NSString stringWithFormat:@"%d", self.comment._id]);
    api.INPUT( @"authorid", self.comment.authorid);
    api.INPUT( @"catalog", [NSString stringWithFormat:@"%d", _source]);
    
    @weakify( api );
    
    api.whenUpdate = ^
    {
        @normalize( api );
        
        if ( api.sending )
        {
        }
        else if ( api.succeed )
        {
            //            if ( ERROR_CODE_OK != api.resp.resultCode.intValue )
            //            {
            //                [self sendUISignal:self.RELOADED];
            //            }
            //            else
            {
                //Need not update list ui.
                RESULT* res      = api.result;
                COMMENT* comment = api.resp;
                
                if(res.errorCode == 1)
                {
                    [bee.ui.appBoard presentSuccessTips:@"发送评论成功!"];
                    
                    //Todo:: add comment to the comment list
                    [self postNotification:self.COMMENT_REPLY withObject:comment];
                    [self.stack popBoardAnimated:YES];
                }
                else
                {
                    [bee.ui.appBoard presentSuccessTips:@"发送评论失败!"];
                }
            }
        }
        else if ( api.failed )
        {
        }
        //    else if ( api.cancelled )
        //    {
        //      [self sendUISignal:self.RELOADED];
        //    }
    };
    
    [api send];
}

@end
