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
//  TweetCell_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/28.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "TweetCell_iPhone.h"
#import "oschina.h"
#import "Tool.h"

#pragma mark -

@implementation TweetCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
}

- (void)unload
{
}

- (void)dataDidChanged
{
    // TODO: fill data
    TWEET_ITEM * tweet = self.data;
    
    if ( tweet != nil )
    {
        NSString* author = [NSString stringWithFormat:@"%@：", tweet.author];
        
        $(@"main_author").TEXT(author);
        $(@"post_avatar").IMAGE(tweet.portrait);
        $(@"anwser_image").IMAGE([UIImage imageNamed:@"comment.png"]);
        $(@"main_title").TEXT(tweet.body);
        $(@"time_info").TEXT([Tool intervalSinceNow:tweet.pubDate]);
        $(@"anwser_count").TEXT([NSString stringWithFormat:@"%d", tweet.commentCount]);
        
    }
    else{
        self.frame = CGRectZero;
    }
    
    self.RELAYOUT();
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

@end
