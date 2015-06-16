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
//  CommentsModel.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/5.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "CommentsModel.h"
#import "oschina.h"

#pragma mark -

@implementation CommentsModel
@synthesize catalog = _catalog;
@synthesize pages   = _pages;
@synthesize _id     = __id;

- (void)load
{
    self.comments = [[NSMutableArray alloc] init];
    self.more  = YES;
    [self loadCache];
}

- (void)unload
{
    [self saveCache];
    self.comments = nil;
}

- (NSString *)cacheKey
{
    // You should set an identified key if this model is shared.
    return NSStringFromClass([self class]);
}

- (void)loadCache
{
    [self.comments removeAllObjects];
    [self.comments addObjectsFromArray:[COMMENT readFromUserDefaults:[self cacheKey]]];
}

- (void)saveCache
{
    [COMMENT userDefaultsWrite:[self.comments objectToString] forKey:[self cacheKey]];
}

- (void)clearCache
{
    [COMMENT userDefaultsRemove:[self cacheKey]];
    [self.comments removeAllObjects];
    
    self.loaded = NO;
}

#pragma mark -

- (void)firstPage
{
    _pages = 0;
    
    [API_COMMENT_LIST cancel];
    
    API_COMMENT_LIST * api = [API_COMMENT_LIST apiWithResponder:self];
    
    // config your pagination
    api.INPUT( @"pageIndex", @"0" );
    api.INPUT( @"pageSize", @"20" );
    api.INPUT( @"id", [NSString stringWithFormat:@"%d", self._id]);
    api.INPUT( @"catalog", [NSString stringWithFormat:@"%d", self.catalog]);
    
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
                [self.comments removeAllObjects];
                [self.comments addObjectsFromArray:api.resp.comments];
                
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
    [API_COMMENT_LIST cancel];
    
    API_COMMENT_LIST * api =[API_COMMENT_LIST apiWithResponder:self];
    
    // api.req.paging.offset = @(self.comments.count);
    // api.req.paging.limit = @(10);
    api.INPUT( @"pageIndex", [NSString stringWithFormat:@"%d", _pages]);
    api.INPUT( @"pageSize", [NSString stringWithFormat:@"%d", 20] );
    api.INPUT( @"id", [NSString stringWithFormat:@"%d", self._id]);
    api.INPUT( @"catalog", [NSString stringWithFormat:@"%d", self.catalog]);
    
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
                    [self.comments removeAllObjects];
                }
            
                [self.comments addObjectsFromArray:api.resp.comments];
                
//                self.paged = api.resp.paged;
                self.pages = self.pages + 1;
                self.loaded = (self.comments.count) ? YES : NO;
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