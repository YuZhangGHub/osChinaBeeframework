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
//  PostModel.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/25.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "PostModel.h"

#pragma mark -

@implementation PostModel

@synthesize _id  = __id;
@synthesize post = _post;

- (void)load
{
    [self loadCache];
}

- (void)unload
{
    [self saveCache];
    self.post = nil;
}

#pragma mark -

- (NSString *)cacheKey
{
    // You should set an identified key if this model is shared.
    return NSStringFromClass([self class]);
}

- (void)loadCache
{
    self.post = [POST readFromUserDefaults:[self cacheKey]];
}

- (void)saveCache
{
    [POST userDefaultsWrite:[self.post objectToString] forKey:[self cacheKey]];
}

- (void)clearCache
{
    [POST removeFromUserDefaults:[self cacheKey]];
    self.post = nil;
    
    self.loaded = NO;
}

- (void)reload
{
    [API_POST_DETAIL cancel];
    
    API_POST_DETAIL * api = [API_POST_DETAIL api];
    
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
            self.post = api.resp;
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