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
//  SoftwareDetailBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/24.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "SoftwareDetailBoard_iPhone.h"
#import "SoftwareItemCell_iPhone.h"
#import "FavoriteRoutine.h"
#import "AppBoard_iPhone.h"
#import "URLHandler.h"
#import "Tool.h"

#pragma mark -

@interface SoftwareDetailBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation SoftwareDetailBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_MODEL(DetailSoftwareModel, detailSoftwareModel)

- (void)load
{
    self.detailSoftwareModel = [DetailSoftwareModel modelWithObserver:self];
    self.isToolbarHiden = YES;
    _favroutine         = [[FavoriteRoutine alloc] init];
    [self observeNotification:_favroutine.FAILED];
    [self observeNotification:_favroutine.SENDED];
    [self observeNotification:_favroutine.SENDING];
}

- (void)unload
{
    [self.detailSoftwareModel removeAllObservers];
    SAFE_RELEASE_MODEL(self.detailSoftwareModel);
    [self unobserveAllNotifications];
    _favroutine         = nil;
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.navigationBarShown = YES;
    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.navigationBarRight  = [UIImage imageNamed:@"item_info_collection_btn.png"];
    UIBarButtonItem *item = (UIBarButtonItem*)self.navigationBarLeft;
    item.title = @"软件";
    super.title = @"软件详情";
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    self.navigationBarTitle = self.detailSoftwareModel.software.title;
    [self.webView setDelegate:self];
    [self.detailSoftwareModel reload];
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
    SOFTWARE* software = self.detailSoftwareModel.software;
    BOOL lastStatus = software.favorite;
    
    if(lastStatus)
    {
        [bee.ui.appBoard presentSuccessTips:@"取消收藏成功!"];
        software.favorite = NO;
    }
    else
    {
        [bee.ui.appBoard presentSuccessTips:@"收藏成功!"];
        software.favorite = YES;
    }
    
    [self refreshFavorite:software];
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
    SOFTWARE* software = self.detailSoftwareModel.software;
    
    if(software == nil) return;
    
    if(software.favorite)
    {
        [_favroutine deleteFavorite:software._id type:1];
    }
    else
    {
        [_favroutine addFavorite:software._id type:1];
    }
}

- (void)refreshFavorite:(SOFTWARE *)s
{
    if(s.favorite)
    {
        self.navigationBarRight  = [UIImage imageNamed:@"item_info_pushed_collect_btn.png"];
    }
    else
    {
        self.navigationBarRight  = [UIImage imageNamed:@"item_info_collection_btn.png"];
    }
}

- (NSString *)getButtonString:(NSString *)homePage andDocument:(NSString *)document andDownload:(NSString *)download
{
    NSString *strHomePage = @"";
    NSString *strDocument = @"";
    NSString *strDownload = @"";
    if ([homePage isEqualToString:@""] == NO) {
        strHomePage = [NSString stringWithFormat:@"<a href=%@><input type='button' value='软件首页' style='font-size:14px;'/></a>", homePage];
    }
    if ([document isEqualToString:@""] == NO) {
        strDocument = [NSString stringWithFormat:@"<a href=%@><input type='button' value='软件文档' style='font-size:14px;'/></a>", document];
    }
    if ([download isEqualToString:@""] == NO) {
        strDownload = [NSString stringWithFormat:@"<a href=%@><input type='button' value='软件下载' style='font-size:14px;'/></a>", download];
    }
    return [NSString stringWithFormat:@"<p>%@&nbsp;&nbsp;%@&nbsp;&nbsp;%@</p>", strHomePage, strDocument, strDownload];
}

ON_SIGNAL3( DetailSoftwareModel, RELOADED, signal )
{
    if ( self.detailSoftwareModel.software.body && self.detailSoftwareModel.software.body.length )
    {
        SOFTWARE* software = self.detailSoftwareModel.software;
        
        NSString *str_title = [NSString stringWithFormat:@"%@ %@", software.extensionTitle,software.title];
//        NSString *tail = [NSString stringWithFormat:@"<div>授权协议: %@</div><div>开发语言: %@</div><div>操作系统: %@</div><div>收录时间: %@</div>",
//                          software.license,software.language,software.os,software.recordTime];
        NSString* tail = [NSString stringWithFormat:@"<div><table><tr><td style='font-weight:bold'>授权协议:&nbsp;</td><td>%@</td></tr><tr><td style='font-weight:bold'>开发语言:</td><td>%@</td></tr><tr><td style='font-weight:bold'>操作系统:</td><td>%@</td></tr><tr><td style='font-weight:bold'>收录时间:</td><td>%@</td></tr></table></div>",software.license,software.language,software.os,software.recordTime];
        
        NSString *html = [NSString stringWithFormat:@"<body style='background-color:#EBEBF3'>%@<div id='oschina_title'><img src='%@' width='34' height='34'/>%@</div><hr/><div id='oschina_body'>%@</div><div>%@</div>%@%@</body>",[Tool getHtmlStyleString],software.logo,str_title,software.body,tail, [self getButtonString:software.homePage andDocument:software.document andDownload:software.download],HTML_Bottom];
        
        self.htmlString = html;
        
        [self refreshFavorite:software];
        
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
