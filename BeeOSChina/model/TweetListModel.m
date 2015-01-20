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
//  TweetListModel.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/28.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "TweetListModel.h"
#import "oschina.h"

#pragma mark -

@implementation TweetListModel

@synthesize pages     = _pages;
@synthesize feedArray = _feedArray;
@synthesize uid       = _uid;

- (void)load
{
    self.feedArray = [[NSMutableArray alloc] init];
    self.more  = YES;
    [self loadCache];
}

- (void)unload
{
    [self saveCache];
    self.feedArray = nil;
}

- (NSString *)cacheKey
{
    // You should set an identified key if this model is shared.
    return NSStringFromClass([self class]);
}

- (void)loadCache
{
    [self.feedArray removeAllObjects];
    [self.feedArray addObjectsFromArray:[TWEET_ITEM readFromUserDefaults:[self cacheKey]]];
}

- (void)saveCache
{
    [TWEET_ITEM userDefaultsWrite:[self.feedArray objectToString] forKey:[self cacheKey]];
}

- (void)clearCache
{
    [TWEET_ITEM userDefaultsRemove:[self cacheKey]];
    [self.feedArray removeAllObjects];
    
    self.loaded = NO;
}

#pragma mark -

- (void)firstPage
{
    _pages = 0;
    
    [API_TWEET_LIST cancel];
    
    API_TWEET_LIST * api = [API_TWEET_LIST apiWithResponder:self];
    
    // config your pagination
    
    api.INPUT( @"pageIndex", @"0" );
    api.INPUT( @"pageSize", @"20" );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", self.uid]);
    
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
            {
                [self.feedArray removeAllObjects];
                [self.feedArray addObjectsFromArray:api.resp.tweets];
                
                // self.paged = api.resp.paged;
                self.loaded = YES;
                self.pages  = 1;
                
                [self sendUISignal:self.RELOADED];
            }
        }
        else if ( api.failed )
        {
            [self sendUISignal:self.RELOADED];
        }
        //    else if ( api.cancelled )
        //    {
        //      [self sendUISignal:self.RELOADED];
        //    }
    };
    
    [api send];
}

- (void)nextPage
{
    [API_TWEET_LIST cancel];
    
    API_TWEET_LIST * api = [API_TWEET_LIST apiWithResponder:self];
    
    // config your pagination
    
    int curBegin = self.pages * 20;
    int curEnd   = curBegin + 20;
    api.INPUT( @"pageIndex", [NSString stringWithFormat:@"%d", curBegin]);
    api.INPUT( @"pageSize", [NSString stringWithFormat:@"%d", curEnd] );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", self.uid]);
    
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
            if(_pages == 0)
            {
                [self.feedArray removeAllObjects];
            }
                [self.feedArray addObjectsFromArray:api.resp.tweets];
                
//                self.paged = api.resp.paged;
            self.loaded = YES;
                self.pages  = self.pages + 1;
                [self sendUISignal:self.RELOADED];
//            }
        }
        else if ( api.failed )
        {
            [self sendUISignal:self.FAILED];
        }
        else if ( api.cancelled )
        {
            [self sendUISignal:self.CANCELLED];
        }
    };
    
    [api send];
}

@end