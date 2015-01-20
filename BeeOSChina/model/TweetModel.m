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
//  TweetModel.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/28.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "TweetModel.h"

#pragma mark -

@implementation TweetModel
@synthesize tweet        = _tweet;
@synthesize _id          = __id;
@synthesize commentCount = _commentCount;

- (void)load
{
    [self loadCache];
}

- (void)unload
{
    [self saveCache];
    self.tweet = nil;
}

- (NSString *)cacheKey
{
    // You should set an identified key if this model is shared.
    return NSStringFromClass([self class]);
}

- (void)loadCache
{
    self.tweet = [TWEET readFromUserDefaults:[self cacheKey]];
}

- (void)saveCache
{
    [TWEET userDefaultsWrite:[self.tweet objectToString] forKey:[self cacheKey]];
}

- (void)clearCache
{
    [TWEET removeFromUserDefaults:[self cacheKey]];
    self.tweet = nil;
    
    self.loaded = NO;
}

#pragma mark -

- (void)reload
{
    [API_TWEET_DETAIL cancel];
    
    API_TWEET_DETAIL * api = [API_TWEET_DETAIL apiWithResponder:self];
    
    // TODO: config your req
    api.INPUT( @"id", [NSString stringWithFormat:@"%d", self._id]);
    
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
                self.tweet = api.resp;
            
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