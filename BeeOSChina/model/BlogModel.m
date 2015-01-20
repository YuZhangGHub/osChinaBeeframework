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
//  BlogModel.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/26.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "BlogModel.h"

#pragma mark -

@implementation BlogModel

@synthesize blog = _blog;
@synthesize _id  = __id;

- (void)load
{
    [self loadCache];
}

- (void)unload
{
    [self saveCache];
    self.blog = nil;
}

- (NSString *)cacheKey
{
    // You should set an identified key if this model is shared.
    return NSStringFromClass([self class]);
}

- (void)loadCache
{
    self.blog = [BLOG readFromUserDefaults:[self cacheKey]];
}

- (void)saveCache
{
    [BLOG userDefaultsWrite:[self.blog objectToString] forKey:[self cacheKey]];
}

- (void)clearCache
{
    [BLOG removeFromUserDefaults:[self cacheKey]];
    self.blog = nil;
    
    self.loaded = NO;
}

#pragma mark -

- (void)reload
{
    [API_BLOG_DETAIL cancel];
    
    API_BLOG_DETAIL * api = [API_BLOG_DETAIL api];
    
    // TODO: config your req
    api.INPUT( @"id", [NSString stringWithFormat:@"%d", self._id] );
    
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
            self.blog = api.resp;
            self.loaded   = YES;
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