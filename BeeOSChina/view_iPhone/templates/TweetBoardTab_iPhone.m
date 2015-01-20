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
//  TweetBoardTab_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/25.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "TweetBoardTab_iPhone.h"

#pragma mark -

@implementation TweetBoardTab_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIButton, newtweet );
DEF_OUTLET( BeeUIButton, hottweet );
DEF_OUTLET( BeeUIButton, mytweet );

- (void)load
{
}

- (void)unload
{
}

- (void)dataDidChanged
{
    // TODO: fill data
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

- (void)selectNewTweet
{
    $(self.newtweet).ADD_CLASS( @"active" );
    $(self.hottweet).REMOVE_CLASS( @"active" );
    $(self.mytweet).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectHotTweet
{
    $(self.newtweet).REMOVE_CLASS( @"active" );
    $(self.hottweet).ADD_CLASS( @"active" );
    $(self.mytweet).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectMyTweet
{
    $(self.newtweet).REMOVE_CLASS( @"active" );
    $(self.hottweet).REMOVE_CLASS( @"active" );
    $(self.mytweet).ADD_CLASS( @"active" );
    
    self.RELAYOUT();
}

@end
