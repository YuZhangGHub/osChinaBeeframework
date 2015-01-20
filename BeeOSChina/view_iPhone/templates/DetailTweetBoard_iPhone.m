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
//  DetailTweetBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/28.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "DetailTweetBoard_iPhone.h"
#import "CommentsBoard_iPhone.h"
#import "EditCommentBoard_iPhone.h"
#import "Tool.h"
#import "UserModel.h"
#import "PersonalBoard_iPhone.h"
#import "URLHandler.h"
#import "GGFullscreenImageViewController.h"

#pragma mark -

@interface DetailTweetBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation DetailTweetBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

@synthesize tabbar = _tabbar;

- (void)load
{
    self.tweetModel = [TweetModel modelWithObserver:self];
    self.isToolbarHiden = YES;
}

- (void)unload
{
    SAFE_RELEASE_MODEL(self.tweetModel);
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.navigationBarShown = YES;
    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    UIBarButtonItem *item = (UIBarButtonItem*)self.navigationBarLeft;
    self.navigationBarRight = @"评论";
    item.title = @"动弹";
    super.title = @"动弹详情";
    
    if (_tabbar == nil )
    {
        _tabbar = [[DetailTweetBoardTab_iPhone alloc] init];
        _tabbar.autoresizesSubviews = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _tabbar.tweettab_details.title = @"动弹详情";
        
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
    self.webView.delegate = self;
    
    self.navigationBarTitle = @"动弹";
    [self.tweetModel reload];
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
        
        alert.title = @"";
        alert.message = @"请登陆后再发评论。";
        
        [alert addButtonTitle:@"登陆" signal:PersonalBoard_iPhone.SIGNIN_NOW];
        [alert addCancelTitle:@"返回"];
        [alert presentForController:self];
    }
    
    
    EditCommentBoard_iPhone * board = [EditCommentBoard_iPhone board];
    board.source    = FromTweet;
    board.articleId = self.tweetModel.tweet._id;
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( DetailTweetBoardTab_iPhone, tweettab_details, signal )
{
    [_tabbar selectDetail];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
}

ON_SIGNAL3( DetailTweetBoardTab_iPhone, tweettab_comments, signal )
{
    [_tabbar selectComments];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    
    CommentsBoard_iPhone *board = [CommentsBoard_iPhone board];
    board.commentList._id       = self.tweetModel._id;
    board.commentList.catalog   = 3; //动弹
    board.type                  = NormalComment;
    board.source                = FromTweet;
    
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( TweetModel, RELOADED, signal )
{
    if ( self.tweetModel.tweet.body && self.tweetModel.tweet.body.length )
    {
        TWEET* tweet = self.tweetModel.tweet;
        
        _tabbar.tweettab_comments.title = [NSString stringWithFormat:@"评论（%d）", self.tweetModel.tweet.commentCount];
        
//        //通知已经获取了帖子回复数
//        Notification_CommentCount *notification = [[Notification_CommentCount alloc] initWithParameters:self andCommentCount:self.singleTweet.commentCount];
//        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_DetailCommentCount object:notification];
        NSString *pubTime = [NSString stringWithFormat:@"在%@ 更新了动态 %@", [Tool intervalSinceNow: tweet.pubDate], [Tool getAppClientString:tweet.appclient]];
        
        NSString *imgHtml = @"";
        if ([tweet.imgBig isEqualToString:@""] == NO) {
            imgHtml = [NSString stringWithFormat:@"<br/><a href='http://wangjuntom'><img style='max-width:300px;' src='%@'/></a>", tweet.imgBig];
        }
        
        //self.webView.backgroundColor = [Tool getBackgroundColor];
        
        //BOOL is_audio = tweet.attach.length > 0;
        
        //读取语音动弹相关html、js
        NSString *audio_html = @"";
        NSString *jquery_js = @"";
        
//        if(is_audio){
//            audio_html = [Tool readResouceFile:@"audio" andExt:@"html"];
//            audio_html = [NSString stringWithFormat:audio_html,singleTweet.attach,singleTweet.attach];
//            jquery_js = [Tool readResouceFile:@"jquery-1.7.1.min" andExt:@"js"];
//        }
        
        NSString *html = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><script type='text/javascript'>%@</script></head>%@<body style='background-color:#EBEBF3'><div id='oschina_title'><a href='http://my.oschina.net/u/%@'>%@</a></div><div id='oschina_outline'>%@</div><br/><div id='oschina_body' style='font-weight:bold;font-size:14px;line-height:21px;'>%@</div>%@%@%@</body></html>",jquery_js,[Tool getHtmlStyleString], tweet.authorid, tweet.author,pubTime,tweet.body,imgHtml,HTML_Bottom,audio_html];
        
        self.htmlString = html;
        
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
    if ([request.URL.absoluteString isEqualToString:@"http://wangjuntom/"])
    {
        //弹出大图
        //[Tool pushTweetImgDetail:singleTweet.imgBig andParent:self];
        TWEET* tweet = self.tweetModel.tweet;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(48,27, 68, 68)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        NSURL *photoUrl = [NSURL URLWithString:tweet.imgBig];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoUrl]];
        imageView.image = image;
        
        GGFullscreenImageViewController *vc = [[GGFullscreenImageViewController alloc] init];
        vc.liftedImageView = imageView;
        [self presentViewController:vc animated:YES completion:nil];
        
        return NO;
    }
    else
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
    return YES;
}

@end
