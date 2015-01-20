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
//  ItemBoardCell_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/6.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "ItemBoardCell_iPhone.h"
#import "oschina.h"
#import "Tool.h"

#pragma mark -

@implementation ItemBoardCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUILabel,		title )
DEF_OUTLET( BeeUILabel,		author )

@synthesize sourceType = _sourceType;

- (void)load
{
}

- (void)unload
{
}

- (void)dataDidChanged
{
    // TODO: fill data
    id obj = self.data;
    
    if([obj isKindOfClass:[NEWS class]])
    {
        NEWS * news = self.data;
        
        if ( news )
        {
            self.title.data    = news.title;
            NSString* sinceNow = [Tool intervalSinceNow:news.pubDate];
            NSString* subTitle = [NSString stringWithFormat:@"%@ 发布于%@（%d评)", news.author, sinceNow, news.commentCount];
            self.author.data = subTitle;
        }
    }
    else if([obj isKindOfClass:[BLOG_ITEM class]])
    {
        BLOG_ITEM * blog = self.data;
        self.title.data    = blog.title;
        
        NSString* sinceNow = [Tool intervalSinceNow:blog.pubDate];
        NSString* subTitle = [NSString stringWithFormat:@"%@ %@ %@ (%d评)", blog.authorname, blog.docType==1?@"原创":@"转载", sinceNow, blog.commentCount];
        self.author.data = subTitle;
    }
    else if([obj isKindOfClass:[SEARCH_ITEM class]])
    {
        SEARCH_ITEM * item = self.data;
        self.title.data    = item.title;
        
        NSString* sinceNow = [Tool intervalSinceNow:item.pubDate];
        NSString* subTitle = [NSString stringWithFormat:@"%@ %@", item.author,  sinceNow];
        
        self.author.data = subTitle;
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
