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
//  TweetImageCell.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/4.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "TweetImageCell_iPhone.h"
#import "oschina.h"
#import "Tool.h"

#pragma mark -

@implementation TweetImageCell_iPhone

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
        
        if([tweet.imgSmall equal:@""] == NO)
        {
            $(@"image_small").IMAGE(tweet.imgSmall);
        }
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
