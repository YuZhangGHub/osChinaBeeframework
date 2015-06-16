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
//  SearchListModel.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/26.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "SearchListModel.h"

#pragma mark -

@implementation SearchListModel
@synthesize items   = _items;
@synthesize type    = _type;
@synthesize pages   = _pages;
@synthesize content = _content;

- (void)load
{
    self.items = [[NSMutableArray alloc] init];
    self.pages = 0;
    self.more  = YES;
    //Search result need not save to cache
    //[self loadCache];
}

- (void)unload
{
    //[self saveCache];
    self.items = nil;
}

- (NSString *)cacheKey
{
    // You should set an identified key if this model is shared.
    return NSStringFromClass([self class]);
}

- (void)loadCache
{
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:[SEARCH_ITEM readFromUserDefaults:[self cacheKey]]];
}

- (void)saveCache
{
    [SEARCH_ITEM userDefaultsWrite:[self.items objectToString] forKey:[self cacheKey]];
}

- (void)clearCache
{
    [SEARCH_ITEM userDefaultsRemove:[self cacheKey]];
    [self.items removeAllObjects];
    
    self.loaded = NO;
}

#pragma mark -

- (void)firstPage
{
    _pages = 0;
    
    [API_SEARCH_LIST cancel];
    
    API_SEARCH_LIST * api = [API_SEARCH_LIST apiWithResponder:self];
    
    api.type = self.type;
    api.INPUT( @"pageIndex", @"0" );
    api.INPUT( @"pageSize", @"20" );
    
    NSString* catalog = [[NSString alloc] init];
    
    if(self.type == SearchTypeNews)
    {
        catalog = @"news";
    }
    else if(self.type == SearchTypePost)
    {
        catalog = @"post";
    }
    else if(self.type == SearchTypeBlog)
    {
        catalog = @"blog";
    }
    else if(self.type == SearchTypeSoftware)
    {
        catalog = @"software";
    }
    
    api.INPUT( @"catalog", catalog );
    api.INPUT( @"content", self.content);
    
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
                [self.items removeAllObjects];
                [self.items addObjectsFromArray:api.resp.search_items];
                
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
    [API_SEARCH_LIST cancel];
    
    API_SEARCH_LIST * api = [API_SEARCH_LIST apiWithResponder:self];
    
    api.type = self.type;
    api.INPUT( @"pageIndex", [NSString stringWithFormat:@"%d", _pages]);
    api.INPUT( @"pageSize", [NSString stringWithFormat:@"%d", 20] );
    
    NSString* catalog = [[NSString alloc] init];
    
    if(self.type == SearchTypeNews)
    {
        catalog = @"news";
    }
    else if(self.type == SearchTypePost)
    {
        catalog = @"post";
    }
    else if(self.type == SearchTypeBlog)
    {
        catalog = @"blog";
    }
    else if(self.type == SearchTypeSoftware)
    {
        catalog = @"software";
    }
    
    api.INPUT( @"catalog", catalog );
    
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
                [self.items removeAllObjects];
            }
                [self.items addObjectsFromArray:api.resp.search_items];
                
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