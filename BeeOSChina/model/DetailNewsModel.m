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
//  DetailNewsModel.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/13.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "DetailNewsModel.h"
#import "oschina.h"

#pragma mark -

@implementation DetailNewsModel

@synthesize article_id    = _article_id;
@synthesize article_title = _article_title;
@synthesize html          = _html;
@synthesize author        = _author;
@synthesize comment_count = _comment_count;
@synthesize pub_date      = _pub_date;
@synthesize author_id     = _author_id;
@synthesize relativies    = _relativies;
@synthesize softwarelink  = _softwarelink;
@synthesize softwarename  = _softwarename;
@synthesize url           = _url;

- (void)load
{
    self.relativies = [[NSMutableArray alloc] init];
    [self loadCache];
}

- (void)unload
{
    [self saveCache];
    self.html          = nil;
    self.article_id    = 0;
    self.article_title = nil;
    self.comment_count = 0;
    self.pub_date      = nil;
    self.author        = nil;
    self.relativies    = nil;
    self.softwarelink  = nil;
    self.softwarename  = nil;
}

- (NSString *)cacheKey
{
    // You should set an identified key if this model is shared.
    return NSStringFromClass([self class]);
}

//No cache, for details new didn't wrap to an object

#pragma mark -

- (void)reload
{
    [API_NEWS_DETAIL cancel];
    
    API_NEWS_DETAIL * api = [API_NEWS_DETAIL api];
    NSString* articleId = [NSString stringWithFormat:@"%d", self.article_id];
    api.INPUT(@"id", articleId);
    
    @weakify( api );
    
    api.whenUpdate = ^
    {
        @normalize( api );
        
        if ( api.sending )
        {
            [self sendUISignal:self.RELOADING];
        }
        else if ( api.succeed )
        {
//            if ( ERROR_CODE_OK != api.resp.resultCode.intValue )
//            {
//                [self sendUISignal:self.FAILED];
//            }
//            else
//            {
//                // TODO: handle resp
                NEWS_DETAIL* nd    = api.resp;
                self.article_id    = nd._id;
                self.article_title = nd.title;
                self.author        = nd.author;
                self.pub_date      = nd.pubDate;
                self.html          = nd.body;
                self.comment_count = nd.commentCount;
                self.softwarename  = nd.softwarename;
                self.softwarelink  = nd.softwarelink;
                self.author_id     = nd.authorid;
                self.favorite      = nd.favorite;
                self.url           = nd.url;
                [self.relativies removeAllObjects];
                [self.relativies addObjectsFromArray:nd.relativies];
            
                self.loaded = YES;
                [self sendUISignal:self.RELOADED];
//            }
        }
        else if ( api.failed )
        {
            [self sendUISignal:self.FAILED];
        }
        else if ( api.cancelled )
        {
            [self sendUISignal:self.RELOADED];
        }
    };
    
    [api send];
}

@end