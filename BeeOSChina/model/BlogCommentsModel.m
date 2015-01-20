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
//  BlogCommentsModel.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/5.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "BlogCommentsModel.h"
#import "oschina.h"

#pragma mark -

@implementation BlogCommentsModel
@synthesize _id   = __id;
@synthesize pages = _pages;

- (void)load
{
    self.b_comments = [[NSMutableArray alloc] init];
    self.more  = YES;
    [self loadCache];
}

- (void)unload
{
    [self saveCache];
    self.b_comments = nil;
}

- (NSString *)cacheKey
{
    // You should set an identified key if this model is shared.
    return NSStringFromClass([self class]);
}

- (void)loadCache
{
    [self.b_comments removeAllObjects];
    [self.b_comments addObjectsFromArray:[COMMENT readFromUserDefaults:[self cacheKey]]];
}

- (void)saveCache
{
    [COMMENT userDefaultsWrite:[self.b_comments objectToString] forKey:[self cacheKey]];
}

- (void)clearCache
{
    [COMMENT userDefaultsRemove:[self cacheKey]];
    [self.b_comments removeAllObjects];
    
    self.loaded = NO;
}

#pragma mark -

- (void)firstPage
{
    _pages = 0;
    
    [API_BLOG_COMMENT_LIST cancel];
    
    API_BLOG_COMMENT_LIST * api = [API_BLOG_COMMENT_LIST apiWithResponder:self];
    
    // config your pagination
    api.INPUT( @"pageIndex", @"0" );
    api.INPUT( @"pageSize", @"20" );
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
//                [self sendUISignal:self.RELOADED];
//            }
//            else
            {
                [self.b_comments removeAllObjects];
                [self.b_comments addObjectsFromArray:api.resp.comments];
                
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
    [API_BLOG_COMMENT_LIST cancel];
    
    API_BLOG_COMMENT_LIST * api =[API_BLOG_COMMENT_LIST apiWithResponder:self];
    
    int curBegin = self.pages * 20;
    int curEnd   = curBegin + 20;
    api.INPUT( @"pageIndex", [NSString stringWithFormat:@"%d", curBegin]);
    api.INPUT( @"pageSize", [NSString stringWithFormat:@"%d", curEnd] );
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
            if(_pages == 0)
            {
                [self.b_comments removeAllObjects];
            }
            
                [self.b_comments addObjectsFromArray:api.resp.comments];
                
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