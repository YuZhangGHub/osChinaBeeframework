//
//	Powered by BeeFramework
//
//
//  DetailQuestionBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/26.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "DetailQuestionBoard_iPhone.h"
#import "CommentsBoard_iPhone.h"
#import "Tool.h"
#import "FavoriteRoutine.h"
#import "AppBoard_iPhone.h"
#import "ShareRoutine.h"
#import "bee.services.share.sinaweibo.h"
#import "bee.services.share.tencentweibo.h"
//#import "bee.services.share.weixin.h"
#import "URLHandler.h"

#pragma mark -

@interface DetailQuestionBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation DetailQuestionBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

@synthesize tabbar       = _tabbar;
DEF_MODEL( PostModel, articleModel )
@synthesize favroutine   = _favroutine;
@synthesize shareRoutine = _shareRoutine;

DEF_SIGNAL( SHARE_TO_SINA )
DEF_SIGNAL( SHARE_TO_TENCENT )
DEF_SIGNAL( SHARE_TO_WEIXIN_FRIEND )
DEF_SIGNAL( SHARE_TO_WEIXIN_TIMELINE )

- (void)load
{
    self.articleModel = [PostModel modelWithObserver:self];
    self.isToolbarHiden = YES;
    _favroutine         = [[FavoriteRoutine alloc] init];
    _shareRoutine       = [[ShareRoutine alloc] init];
    [self observeNotification:_favroutine.FAILED];
    [self observeNotification:_favroutine.SENDED];
    [self observeNotification:_favroutine.SENDING];
}

- (void)unload
{
    SAFE_RELEASE_MODEL( self.articleModel );
    [self unobserveAllNotifications];
    _favroutine         = nil;
    _shareRoutine       = nil;
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.navigationBarShown = YES;
    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.navigationBarRight  = [UIImage imageNamed:@"item_info_collection_btn.png"];
    UIBarButtonItem *item = (UIBarButtonItem*)self.navigationBarLeft;
    item.title = @"问答";
    super.title = @"问答详情";
    
    if (_tabbar == nil )
    {
        _tabbar = [[DetailBoardTab_iPhone alloc] init];
        _tabbar.autoresizesSubviews = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _tabbar.tabbtn_details.title = @"问答详情";
        
        [self.view addSubview:_tabbar];
    }
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
    int tabbarHeight = 44.0f;
    
    CGRect frame = self.view.frame;
    frame.size.height -= tabbarHeight;
    if ( IOS7_OR_EARLIER )
    {
        frame.origin.y = 0;
    }
    
    frame.origin.y += frame.size.height;
    frame.size.height = tabbarHeight;
    _tabbar.frame = frame;
    
    self.webView.scalesPageToFit = NO;
}

ON_WILL_APPEAR( signal )
{
    self.navigationBarTitle = self.articleModel.post.title;
    [self.webView setDelegate:self];
    [self.articleModel reload];
    [_tabbar selectDetail];
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

ON_NOTIFICATION3( FavoriteRoutine, SENDING, notification )
{
    
}

ON_NOTIFICATION3( FavoriteRoutine, SENDED, notification )
{
    POST* post = self.articleModel.post;
    BOOL lastStatus = post.favorite;
    
    if(lastStatus)
    {
        [bee.ui.appBoard presentSuccessTips:@"取消收藏成功!"];
        post.favorite = NO;
    }
    else
    {
        [bee.ui.appBoard presentSuccessTips:@"收藏成功!"];
        post.favorite = YES;
    }
    
    [self refreshFavorite:post];
}

ON_NOTIFICATION3( FavoriteRoutine, FAILED, notification )
{
    [bee.ui.appBoard presentSuccessTips:@"操作失败!"];
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
    POST* post = self.articleModel.post;
    
    if(post == nil) return;
    
    if(post.favorite)
    {
        [_favroutine deleteFavorite:post._id type:2];
    }
    else
    {
        [_favroutine addFavorite:post._id type:2];
    }
}

ON_SIGNAL3( PostModel, RELOADING, signal )
{
}

ON_SIGNAL3( DetailBoardTab_iPhone, tabbtn_details, signal )
{
    [_tabbar selectDetail];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
}

ON_SIGNAL3( DetailBoardTab_iPhone, tabbtn_comments, signal )
{
    [_tabbar selectComments];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    CommentsBoard_iPhone *board = [CommentsBoard_iPhone board];
    board.commentList._id       = self.articleModel._id;
    board.commentList.catalog   = 2; //问答
    board.type                  = NormalComment;
    board.source                = FromQuestion;
    
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( DetailBoardTab_iPhone, tabbtn_sharing, signal )
{
    [_tabbar selectSharing];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    BOOL valid = NO;
    
    BeeUIActionSheet * sheet = [BeeUIActionSheet spawn];
    
    [sheet addButtonTitle:(@"分享到新浪微博") signal:self.SHARE_TO_SINA];
    [sheet addButtonTitle:(@"分享到腾讯微博") signal:self.SHARE_TO_TENCENT];
//    [sheet addButtonTitle:(@"分享到微信") signal:self.SHARE_TO_WEIXIN_FRIEND];
//    [sheet addButtonTitle:(@"分享到微信朋友圈") signal:self.SHARE_TO_WEIXIN_TIMELINE];
    
    valid = YES;
    
    if ( valid )
    {
        [sheet addCancelTitle:(@"取消")];
        [sheet showInViewController:self];
    }
}

ON_SIGNAL3( DetailQuestionBoard_iPhone, SHARE_TO_SINA, signal )
{
    POST* post = self.articleModel.post;
    
    if(post == nil) return;
    
    [self.shareRoutine shareToSinaWeibo:post.url];
}

ON_SIGNAL3( DetailQuestionBoard_iPhone, SHARE_TO_TENCENT, signal )
{
    POST* post = self.articleModel.post;
    
    if(post == nil) return;
    
    [self.shareRoutine shareToTencentWeibo:post.url];
}

//ON_SIGNAL3( DetailQuestionBoard_iPhone, SHARE_TO_WEIXIN_FRIEND, signal )
//{
//    POST* post = self.articleModel.post;
//    
//    if(post == nil) return;
//    
//    [self.shareRoutine shareToWechat:post.url :post.title];
//}
//
//ON_SIGNAL3( DetailQuestionBoard_iPhone, SHARE_TO_WEIXIN_TIMELINE, signal )
//{
//    POST* post = self.articleModel.post;
//    
//    if(post == nil) return;
//    
//    [self.shareRoutine shareToWechatCircle:post.url :post.title];
//}

- (void)refreshFavorite:(POST *)p
{
    if(p.favorite)
    {
        self.navigationBarRight  = [UIImage imageNamed:@"item_info_pushed_collect_btn.png"];
    }
    else
    {
        self.navigationBarRight  = [UIImage imageNamed:@"item_info_collection_btn.png"];
    }
}

ON_SIGNAL3( PostModel, RELOADED, signal )
{
    if ( self.articleModel.post.body && self.articleModel.post.body.length )
    {
        POST* post = self.articleModel.post;
        
        _tabbar.tabbtn_comments.title = [NSString stringWithFormat:@"回帖（%d）", post.answerCount];
        
//        //通知已经获取了帖子回复数
//        Notification_CommentCount *notification = [[Notification_CommentCount alloc] initWithParameters:self andCommentCount:p.answerCount];
//        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_DetailCommentCount object:notification];
//        
//        //微博分享准备
//        [Config Instance].shareObject = [[ShareObject alloc] initWithParameters:p.title andUrl:p.url andContent:p.body];
        //显示
        NSString *author_str = [NSString stringWithFormat:@"<a href='http://my.oschina.net/u/%d'>%@</a> 发布于 %@",post.authorid, post.author, post.pubDate];
        NSString *html = [NSString stringWithFormat:@"<body style='background-color:#EBEBF3;'>%@<div id='oschina_title'>%@</div><div id='oschina_outline'>%@</div><hr/><div id='oschina_body'>%@</div>%@%@</body>",[Tool getHtmlStyleString], post.title,author_str,post.body,[Tool GenerateTags:post.tags],HTML_Bottom];
        
        self.htmlString = html;
        
        [self refreshFavorite:post];
        
        [self refresh];
    }
    else
    {
        [self presentFailureTips:(@"no_data")];
    }
}

#pragma mark - 浏览器链接处理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [URLHandler handleURL:request.URL.absoluteString parentBoard:self];
    if ([request.URL.absoluteString isEqualToString:@"about:blank"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
