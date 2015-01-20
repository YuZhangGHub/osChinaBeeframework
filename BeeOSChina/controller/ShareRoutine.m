//
//  ShareRoutine.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/29.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "ShareRoutine.h"
#import "bee.services.share.sinaweibo.h"
#import "bee.services.share.tencentweibo.h"
//#import "bee.services.share.weixin.h"

@implementation ShareRoutine

-(void) shareToSinaWeibo : (NSString*) url
{
    NSString * text = [NSString stringWithFormat:@"%@ %@", (@"share_blog :"), url];
    
    ALIAS( bee.services.share.sinaweibo, sweibo );
    
    sweibo.post.text = text;
    
    @weakify(self);
    
    sweibo.whenShareBegin = ^
    {
        @normalize(self);
        
        [self presentLoadingTips:(@"uploading")];
    };
    sweibo.whenShareSucceed = ^
    {
        @normalize(self);
        
        [self presentSuccessTips:(@"share_succeed")];
    };
    sweibo.whenShareFailed = ^
    {
        @normalize(self);
        
        //[self presentFailureTips:sweibo.errorDesc];
        [self presentFailureTips:(@"share_failed")];
    };
    
    sweibo.SHARE();
}

-(void) shareToTencentWeibo : (NSString*) url
{
    NSString * text = [NSString stringWithFormat:@"%@ %@", (@"share_blog :"), url];
    
    ALIAS( bee.services.share.tencentweibo, tweibo );
    
    tweibo.post.text = text;

    @weakify(self);
    
    tweibo.whenShareBegin = ^
    {
        @normalize(self);
        
        [self presentLoadingTips:(@"uploading")];
    };
    tweibo.whenShareSucceed = ^
    {
        @normalize(self);
        
        [self presentSuccessTips:(@"share_succeed")];
    };
    tweibo.whenShareFailed = ^
    {
        @normalize(self);
        
        //[self presentFailureTips:tweibo.errorMsg];
        [self presentFailureTips:(@"share_failed")];
    };
    
    tweibo.SHARE();
}

-(void) shareToWechat : (NSString*) url :(NSString*) title
{
//    ALIAS( bee.services.share.weixin, weixin );
//    
//    NSString * text = [NSString stringWithFormat:@"%@ %@", (@"share_wechat :"), url];
//    
//    weixin.post.text = text;
//    weixin.post.title = title;
//    
//    @weakify(self);
//    
//    weixin.whenShareSucceed = ^
//    {
//        @normalize(self);
//        
//        [self presentSuccessTips:(@"share_succeed")];
//    };
//    
//    weixin.whenShareFailed = ^
//    {
//        @normalize(self);
//        
//        //[self presentFailureTips:weixin.errorDesc];
//        [self presentFailureTips:(@"share_failed")];
//    };
//    
//    weixin.SHARE_TO_FRIEND();
}

-(void) shareToWechatCircle : (NSString*) url :(NSString*) title
{
//    NSString * text = [NSString stringWithFormat:@"%@ %@", (@"share_wechat_timeline :"), url];
//    
//    ALIAS( bee.services.share.weixin, weixin );
//
//    weixin.post.text = text;
//    weixin.post.title = title;
//    
//    @weakify(self);
//    
//    weixin.whenShareSucceed = ^
//    {
//        @normalize(self);
//        
//        [self presentSuccessTips:(@"share_succeed")];
//    };
//    
//    weixin.whenShareFailed = ^
//    {
//        @normalize(self);
//        
//        //[self presentFailureTips:weixin.errorDesc];
//        [self presentFailureTips:(@"share_failed")];
//    };
//    
//    weixin.SHARE_TO_TIMELINE();
}

@end
