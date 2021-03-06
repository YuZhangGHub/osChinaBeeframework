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
//  DetailArticleBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/14.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "BrowserBoard_iPhone.h"
#import "DetailNewsModel.h"
#import "DetailBoardTab_iPhone.h"

#pragma mark -

@class FavoriteRoutine;
@class ShareRoutine;

@interface DetailArticleBoard_iPhone : BrowserBoard_iPhone<UIWebViewDelegate>

AS_MODEL( DetailNewsModel, articleModel )

/**
 * 分享-新浪微博，点击时触发该事件
 */
AS_SIGNAL( SHARE_TO_SINA )

/**
 * 分享-腾讯微博，点击时触发该事件
 */
AS_SIGNAL( SHARE_TO_TENCENT )

/**
 * 分享-微信朋友圈，点击时触发该事件
 */
AS_SIGNAL( SHARE_TO_WEIXIN_FRIEND )

/**
 * 分享-微信，点击时触发该事件
 */
AS_SIGNAL( SHARE_TO_WEIXIN_TIMELINE )

@property (nonatomic, retain) DetailBoardTab_iPhone* tabbar;
@property (nonatomic, retain) FavoriteRoutine*       favroutine;
@property (nonatomic, retain) ShareRoutine*          shareRoutine;

@end
