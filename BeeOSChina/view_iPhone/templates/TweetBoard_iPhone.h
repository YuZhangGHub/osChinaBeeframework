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
//  TweetBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/25.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "TweetBoardTab_iPhone.h"
#import "oschina.h"
#import "TweetListModel.h"

#pragma mark -

@interface TweetBoard_iPhone : BeeUIBoard

AS_OUTLET( BeeUIScrollView, list );
AS_OUTLET( TweetBoardTab_iPhone,	tabbar );

AS_MODEL(TweetListModel, tweetListModel)

@end
