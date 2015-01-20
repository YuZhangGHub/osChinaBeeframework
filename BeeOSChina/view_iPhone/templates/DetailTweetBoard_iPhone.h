//
//   ______    ______    ______    
//  /\  __ \  /\  ___\  /\  ___\   
//  \ \  __<  \ \  __\_ \ \  __\_ 
//   \ \_____\ \ \_____\ \ \_____\ 
//    \/_____/  \/_____/  \/_____/ 
//
//  Powered by BeeFramework
//
//
//  DetailTweetBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/28.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "TweetModel.h"
#import "BrowserBoard_iPhone.h"
#import "DetailTweetBoardTab_iPhone.h"

#pragma mark -

@interface DetailTweetBoard_iPhone :  BrowserBoard_iPhone<UIWebViewDelegate>
{
    UIBarButtonItem * btnFavorite;
}

AS_MODEL( TweetModel, tweetModel )
@property (nonatomic, retain) DetailTweetBoardTab_iPhone* tabbar;

@end
