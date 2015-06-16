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
//  PostListModel.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/25.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "PostListModel.h"
#import "oschina.h"

#pragma mark -

@implementation PostListModel
@synthesize posts    = _posts;
@synthesize catalog  = _catalog;
@synthesize pages    = _pages;

- (void)load
{
    self.posts = [[NSMutableArray alloc] init];
    self.more  = true;
    [self loadCache];
}

- (void)unload
{
    self.posts = nil;
    [self saveCache];
}

- (NSString *)cacheKey
{
    // You should set an identified key if this model is shared.
    return NSStringFromClass([self class]);
}

- (void)loadCache
{
    [self.posts removeAllObjects];
    [self.posts addObjectsFromArray:[POST_ITEM readFromUserDefaults:[self cacheKey]]];
}

- (void)saveCache
{
    [POST_ITEM userDefaultsWrite:[self.posts objectToString] forKey:[self cacheKey]];
}

- (void)clearCache
{
    [POST_ITEM userDefaultsRemove:[self cacheKey]];
    [self.posts removeAllObjects];
    
    self.loaded = NO;
}

#pragma mark -

- (void)firstPage
{
    _pages = 0;
    
    [API_POST_LIST cancel];
    
    API_POST_LIST *api = [API_POST_LIST api];
    
    api.INPUT( @"pageIndex", @"0" );
    api.INPUT( @"pageSize", @"20" );
    api.INPUT( @"catalog", [NSString stringWithFormat:@"%d", self.catalog] );
    
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
            //                [self sendUISignal:self.RELOADED];
            //            }
            //            else
            {
                [self.posts removeAllObjects];
                
                [self.posts addObjectsFromArray:api.resp.posts];
                
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
    [API_POST_LIST cancel];
    
    API_POST_LIST *api = [API_POST_LIST api];
    
    api.INPUT( @"pageIndex", [NSString stringWithFormat:@"%d", _pages]);
    api.INPUT( @"pageSize", [NSString stringWithFormat:@"%d", 20] );
    api.INPUT( @"catalog", [NSString stringWithFormat:@"%d", self.catalog] );
    
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
            if( _pages == 0)
            {
                [self.posts removeAllObjects];
            }
            
            [self.posts addObjectsFromArray:api.resp.posts];
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