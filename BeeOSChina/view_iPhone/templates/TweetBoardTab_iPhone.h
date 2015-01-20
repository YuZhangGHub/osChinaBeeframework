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
//  TweetBoardTab_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/25.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface TweetBoardTab_iPhone : BeeUICell

AS_OUTLET( BeeUIButton, newtweet );
AS_OUTLET( BeeUIButton, hottweet );
AS_OUTLET( BeeUIButton, mytweet );

- (void)selectNewTweet;
- (void)selectHotTweet;
- (void)selectMyTweet;

@end
