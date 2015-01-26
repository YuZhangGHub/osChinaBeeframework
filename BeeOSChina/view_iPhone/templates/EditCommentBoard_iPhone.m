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
//  EditCommentBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/10.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "EditCommentBoard_iPhone.h"
#import "UserModel.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@interface EditCommentBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation EditCommentBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

@synthesize source      = _source;
@synthesize articleId   = _articleId;

DEF_OUTLET(BeeUILabel, description)
DEF_OUTLET(BeeUITextField, comment)
DEF_OUTLET( BeeUISwitch,	switch_cell );

DEF_NOTIFICATION( COMMENT_PUB )
DEF_NOTIFICATION( BLOG_COMMENT_PUB )

- (void)load
{
    _source      = FromNews;
    _articleId   = 0;
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.navigationBarShown = YES;
    self.navigationBarRight = @"发送";
    self.view.backgroundColor = HEX_RGB( 0xdfdfdf );
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    if (_source != FromQuestion)
    {
        [_description setText:@"我要评论"];
        [_comment setPlaceholder:@"点击此处输入评论"];
    }
    else
    {
        [_description setText:@"我要回帖"];
        [_comment setPlaceholder:@"点击此处输入回帖"];
    }
    
    if (_source == FromTweet)
    {
        $(@"switch_label").SHOW();
        $(@"switch_cell").SHOW();
        [_switch_cell setOn:YES animated:NO];
    }
    else
    {
        $(@"switch_label").HIDE();
        $(@"switch_cell").HIDE();
    }
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

-(void) pubTweetCommentInDetail
{
    UserModel* uModel = [UserModel sharedInstance];
    
    if(uModel == nil || uModel.user == nil || uModel.user.uid == nil)
    {
        return;
    }
    
    [API_COMMENT_PUB cancel];
    
    API_COMMENT_PUB * api = [API_COMMENT_PUB apiWithResponder:self];
    
    int uid       = [UserModel sharedInstance].user.uid.intValue;
    NSString* msg = $(@"comment").text;
    
    api.INPUT( @"catalog", @"3");
    api.INPUT( @"content", msg );
    api.INPUT( @"id", [NSString stringWithFormat:@"%d", _articleId]);
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", uid]);
    api.INPUT( @"isPostToMyZone", @"0");
    
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
                RESULT* res = api.result;
                if(res.errorCode == 1)
                {
                    [bee.ui.appBoard presentSuccessTips:@"发送评论成功!"];
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

- (void) pubBlogComment
{
    UserModel* uModel = [UserModel sharedInstance];
    
    if(uModel == nil || uModel.user == nil || uModel.user.uid == nil)
    {
        return;
    }
    
    [API_BLOG_COMMENT_PUB cancel];
    
    API_BLOG_COMMENT_PUB * api = [API_BLOG_COMMENT_PUB apiWithResponder:self];
    
    int uid       = [UserModel sharedInstance].user.uid.intValue;
    NSString* msg = $(@"comment").text;
    
    api.INPUT( @"content", msg );
    api.INPUT( @"blog", [NSString stringWithFormat:@"%d", _articleId]);
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", uid]);
    
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
                    [self postNotification:self.BLOG_COMMENT_PUB withObject:comment];
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

- (void) pubComment
{
    UserModel* uModel = [UserModel sharedInstance];
    
    if(uModel == nil || uModel.user == nil || uModel.user.uid == nil)
    {
        return;
    }
    
    [API_COMMENT_PUB cancel];
    
    API_COMMENT_PUB * api = [API_COMMENT_PUB apiWithResponder:self];
    
    int uid       = [UserModel sharedInstance].user.uid.intValue;
    NSString* msg = $(@"comment").text;
    
    api.INPUT( @"catalog", [NSString stringWithFormat:@"%d", _source]);
    api.INPUT( @"content", msg );
    api.INPUT( @"id", [NSString stringWithFormat:@"%d", _articleId]);
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", uid]);
    api.INPUT( @"isPostToMyZone", [NSString stringWithFormat:@"%d", _switch_cell.on]);
    
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
                    [self postNotification:self.COMMENT_PUB withObject:comment];
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

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
    {
        if([UserModel online] == NO)
        {
            [bee.ui.appBoard presentSuccessTips:@"请先登录!"];
        }
        
        if(_source == FromTweet)
        {
            [self pubTweetCommentInDetail];
        }
        else if(_source == FromBlog)
        {
            [self pubBlogComment];
        }
        else
        {
            [self pubComment];
        }
    }
}

@end
