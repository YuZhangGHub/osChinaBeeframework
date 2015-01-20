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
//  DetailArticleBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/14.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "DetailArticleBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "UIViewController+ErrorTips.h"
#import "oschina.h"
#import "Tool.h"
#import "CommentsBoard_iPhone.h"
#import "FavoriteRoutine.h"
#import "ShareRoutine.h"
#import "bee.services.share.sinaweibo.h"
#import "bee.services.share.tencentweibo.h"
//#import "bee.services.share.weixin.h"
#import "URLHandler.h"

#pragma mark -

@interface DetailArticleBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation DetailArticleBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_MODEL(DetailNewsModel, articleModel)

@synthesize tabbar       = _tabbar;
@synthesize favroutine   = _favroutine;
@synthesize shareRoutine = _shareRoutine;

DEF_SIGNAL( SHARE_TO_SINA )
DEF_SIGNAL( SHARE_TO_TENCENT )
DEF_SIGNAL( SHARE_TO_WEIXIN_FRIEND )
DEF_SIGNAL( SHARE_TO_WEIXIN_TIMELINE )

- (void)load
{
    self.articleModel = [DetailNewsModel modelWithObserver:self];
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
    item.title = @"资讯";
    super.title = @"资讯详情";
    
    if (_tabbar == nil )
    {
        _tabbar = [[DetailBoardTab_iPhone alloc] init];
        _tabbar.autoresizesSubviews = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _tabbar.tabbtn_details.title = @"资讯详情";
        
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
    //[bee.ui.appBoard hideTabbar];
    self.navigationBarTitle = self.articleModel.article_title;
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
    DetailNewsModel* news = self.articleModel;
    BOOL lastStatus = news.favorite;
    
    if(lastStatus)
    {
        [bee.ui.appBoard presentSuccessTips:@"取消收藏成功!"];
        news.favorite = NO;
    }
    else
    {
        [bee.ui.appBoard presentSuccessTips:@"收藏成功!"];
        news.favorite = YES;
    }
    
    [self refreshFavorite:news];
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
    DetailNewsModel* news = self.articleModel;
    
    if(news == nil) return;
    
    if(news.favorite)
    {
        [_favroutine deleteFavorite:news.article_id type:4];
    }
    else
    {
        [_favroutine addFavorite:news.article_id type:4];
    }
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
    board.commentList._id       = self.articleModel.article_id;
    board.commentList.catalog   = 1; //资讯
    board.source                = FromNews;
    board.type                  = NormalComment;

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

ON_SIGNAL3( DetailArticleBoard_iPhone, SHARE_TO_SINA, signal )
{
    DetailNewsModel* detail = self.articleModel;
    
    if(detail == nil) return;
    
    [self.shareRoutine shareToSinaWeibo:detail.url];
}

ON_SIGNAL3( DetailArticleBoard_iPhone, SHARE_TO_TENCENT, signal )
{
    DetailNewsModel* detail = self.articleModel;
    
    if(detail == nil) return;
    
    [self.shareRoutine shareToTencentWeibo:detail.url];
}

//ON_SIGNAL3( DetailArticleBoard_iPhone, SHARE_TO_WEIXIN_FRIEND, signal )
//{
//    DetailNewsModel* detail = self.articleModel;
//    
//    if(detail == nil) return;
//    
//    [self.shareRoutine shareToWechat:detail.url :detail.article_title];
//}
//
//ON_SIGNAL3( DetailArticleBoard_iPhone, SHARE_TO_WEIXIN_TIMELINE, signal )
//{
//    DetailNewsModel* detail = self.articleModel;
//    
//    if(detail == nil) return;
//    
//    [self.shareRoutine shareToWechatCircle:detail.url :detail.article_title];
//}

ON_SIGNAL3( DetailNewsModel, RELOADING, signal )
{
}

- (void)refreshFavorite:(DetailNewsModel *)detail
{
    if(detail.favorite)
    {
        self.navigationBarRight  = [UIImage imageNamed:@"item_info_pushed_collect_btn.png"];
    }
    else
    {
        self.navigationBarRight  = [UIImage imageNamed:@"item_info_collection_btn.png"];
    }
}

ON_SIGNAL3( DetailNewsModel, RELOADED, signal )
{
    if ( self.articleModel.html && self.articleModel.html.length )
    {
        DetailNewsModel* detail = self.articleModel;
        
       _tabbar.tabbtn_comments.title = [NSString stringWithFormat:@"评论（%d）", detail.comment_count];
        
        NSString *author_str = [NSString stringWithFormat:@"<a href='http://my.oschina.net/u/%d'>%@</a> 发布于 %@",detail.author_id, detail.author, detail.pub_date];
        
        NSString *software = @"";
        if ([detail.softwarename isEqualToString:@""] == NO) {
            software = [NSString stringWithFormat:@"<div id='oschina_software' style='margin-top:8px;color:#FF0000;font-size:14px;font-weight:bold'>更多关于:&nbsp;<a href='%@'>%@</a>&nbsp;的详细信息</div>",detail.softwarelink, detail.softwarename];
        }
        NSString *html = [NSString stringWithFormat:@"<body style='background-color:#EBEBF3'>%@<div id='oschina_title'>%@</div><div id='oschina_outline'>%@</div><hr/><div id='oschina_body'>%@</div>%@%@%@</body>",[Tool getHtmlStyleString], detail.article_title, author_str, detail.html, software,[Tool generateRelativeNewsString:detail.relativies],HTML_Bottom];

        
        self.htmlString = html;
        
        [self refreshFavorite:detail];
        
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
