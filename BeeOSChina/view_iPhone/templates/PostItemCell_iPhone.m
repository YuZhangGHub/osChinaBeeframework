//
//	Powered by BeeFramework
//
//
//  PostItemCell_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/26.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "PostItemCell_iPhone.h"
#import "oschina.h"
#import "Tool.h"

#pragma mark -

@implementation PostItemCell_iPhone

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
    POST_ITEM * post = self.data;
    
    if ( post != nil )
    {
        NSString* answerType = post.catalog <= 1 ? @"回答" : @"回帖";
        NSString* subtitle = [NSString stringWithFormat:@"%@ 发布于%@", post.author, [Tool intervalSinceNow:post.pubDate]];
        
        $(@"main_title").TEXT(post.title);
        $(@"author_info").TEXT(subtitle);
        $(@"anwser_count").TEXT([NSString stringWithFormat:@"%d", post.answerCount]);
        $(@"anwser_type").TEXT(answerType);
        $(@"post_avatar").IMAGE(post.portrait);
    }
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

- (BOOL)dataWillChange:(id)newData
{
    return newData != self.data;
}

@end
