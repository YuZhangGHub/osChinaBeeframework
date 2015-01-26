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
//  DetailBlogBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/26.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "DetailBlogBoard_iPhone.h"
#import "CommentsBoard_iPhone.h"
#import "FavoriteRoutine.h"
#import "Tool.h"
#import "AppBoard_iPhone.h"
#import "ShareRoutine.h"
#import "URLHandler.h"
#import "UserModel.h"

#pragma mark -

@interface DetailBlogBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation DetailBlogBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )
@synthesize tabbar       = _tabbar;
@synthesize favroutine   = _favroutine;
@synthesize shareRoutine = _shareRoutine;

DEF_SIGNAL( SHARE_TO_SINA )
DEF_SIGNAL( SHARE_TO_TENCENT )
DEF_SIGNAL( SHARE_TO_WEIXIN_FRIEND )
DEF_SIGNAL( SHARE_TO_WEIXIN_TIMELINE )

DEF_MODEL( BlogModel, articleModel )

- (void)load
{
    self.articleModel   = [BlogModel modelWithObserver:self];
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
    self.navigationBarRight = [UIImage imageNamed:@"item_info_pushed_collect_btn.png"];
    UIBarButtonItem *item = (UIBarButtonItem*)self.navigationBarLeft;
    item.title = @"博客";
    super.title = @"博客详情";
    
    if (_tabbar == nil )
    {
        _tabbar = [[DetailBoardTab_iPhone alloc] init];
        _tabbar.autoresizesSubviews = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _tabbar.tabbtn_details.title = @"博客详情";
        
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
    self.navigationBarTitle = self.articleModel.blog.title;
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
    BLOG* blog = self.articleModel.blog;
    BOOL lastStatus = blog.favorite;
    
    if(lastStatus)
    {
        [bee.ui.appBoard presentSuccessTips:@"取消收藏成功!"];
        blog.favorite = NO;
    }
    else
    {
        [bee.ui.appBoard presentSuccessTips:@"收藏成功!"];
        blog.favorite = YES;
    }
    
    [self refreshFavorite:blog];
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
    BLOG* blog = self.articleModel.blog;
    
    if(blog == nil) return;
    
    if([UserModel online] == NO)
    {
        [bee.ui.appBoard presentSuccessTips:@"请先登录!"];
    }
    
    if(blog.favorite)
    {
        [_favroutine deleteFavorite:blog._id type:3];
    }
    else
    {
        [_favroutine addFavorite:blog._id type:3];
    }
}

ON_SIGNAL3( BlogModel, RELOADING, signal )
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
    board.blogCommentList._id   = self.articleModel._id;
    board.type                  = BlogComment;
    board.source                = FromBlog;
    
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

ON_SIGNAL3( DetailBlogBoard_iPhone, SHARE_TO_SINA, signal )
{
    BLOG* blog = self.articleModel.blog;
    
    if(blog == nil) return;
    
    [self.shareRoutine shareToSinaWeibo:blog.url];
}

ON_SIGNAL3( DetailBlogBoard_iPhone, SHARE_TO_TENCENT, signal )
{
    BLOG* blog = self.articleModel.blog;
    
    if(blog == nil) return;
    
    [self.shareRoutine shareToTencentWeibo:blog.url];
}

//ON_SIGNAL3( DetailBlogBoard_iPhone, SHARE_TO_WEIXIN_FRIEND, signal )
//{
//    BLOG* blog = self.articleModel.blog;
//    
//    if(blog == nil) return;
//    
//    [self.shareRoutine shareToWechat:blog.url :blog.title];
//}
//
//ON_SIGNAL3( DetailBlogBoard_iPhone, SHARE_TO_WEIXIN_TIMELINE, signal )
//{
//    BLOG* blog = self.articleModel.blog;
//    
//    if(blog == nil) return;
//    
//    [self.shareRoutine shareToWechatCircle:blog.url :blog.title];
//}

- (void)refreshFavorite:(BLOG *)b
{
    if(b.favorite)
    {
        self.navigationBarRight  = [UIImage imageNamed:@"item_info_pushed_collect_btn.png"];
    }
    else
    {
        self.navigationBarRight  = [UIImage imageNamed:@"item_info_collection_btn.png"];
    }
}

ON_SIGNAL3( BlogModel, RELOADED, signal )
{
    if ( self.articleModel.blog.body && self.articleModel.blog.body.length )
    {
        BLOG* blog = self.articleModel.blog;
        
//        //通知去修改新闻评论数
//        Notification_CommentCount *notification = [[Notification_CommentCount alloc] initWithParameters:self andCommentCount:b.commentCount];
//        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_DetailCommentCount object:notification];
        _tabbar.tabbtn_comments.title = [NSString stringWithFormat:@"评论（%d）", blog.commentCount];
        
        
        //新式方法
        NSString *author_str = [NSString stringWithFormat:@"<a href='http://my.oschina.net/u/%d'>%@</a>&nbsp;发表于&nbsp;%@",blog.authorid, blog.author,  [Tool intervalSinceNow:blog.pubDate]];
        NSString *html = [NSString stringWithFormat:@"<body style='background-color:#EBEBF3'>%@<div id='oschina_title'>%@</div><div id='oschina_outline'>%@</div><hr/><div id='oschina_body'>%@</div>%@</body>",[Tool getHtmlStyleString], blog.title,author_str,blog.body,HTML_Bottom];
        
        self.htmlString = html;
        
        [self refreshFavorite:blog];
        
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
