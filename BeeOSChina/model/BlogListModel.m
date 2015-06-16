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
//  BlogListModel.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/25.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "BlogListModel.h"
#import "oschina.h"

#pragma mark -

@implementation BlogListModel
@synthesize blogs = _blogs;
@synthesize type  = _type;
@synthesize pages = _pages;

- (void)load
{
    self.blogs = [[NSMutableArray alloc] init];
    self.more  = YES;
    [self loadCache];
}

- (void)unload
{
    self.blogs = nil;
    [self saveCache];
}

- (NSString *)cacheKey
{
    // You should set an identified key if this model is shared.
    return NSStringFromClass([self class]);
}

- (void)loadCache
{
    [self.blogs removeAllObjects];
    [self.blogs addObjectsFromArray:[BLOG_ITEM readFromUserDefaults:[self cacheKey]]];
}

- (void)saveCache
{
    [BLOG_ITEM userDefaultsWrite:[self.blogs objectToString] forKey:[self cacheKey]];
}

- (void)clearCache
{
    [BLOG_ITEM userDefaultsRemove:[self cacheKey]];
    [self.blogs removeAllObjects];
    
    self.loaded = NO;
}

#pragma mark -

- (void)firstPage
{
    _pages = 0;
    
    [API_BLOG_LIST cancel];
    
    API_BLOG_LIST *api = [API_BLOG_LIST api];
    
    api.INPUT( @"pageIndex", @"0" );
    api.INPUT( @"pageSize", @"20" );
    
    NSString* typeString = [[NSString alloc] init];
    if(self.type == Blog)
    {
        typeString = @"latest";
    }
    else if(self.type == Recommend)
    {
        typeString = @"recommend";
    }
    
    api.INPUT( @"type", typeString);
    
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
                [self.blogs removeAllObjects];
                
                [self.blogs addObjectsFromArray:api.resp.blogs];
                
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
    [API_BLOG_LIST cancel];
    
    API_BLOG_LIST *api = [API_BLOG_LIST api];
    
    api.INPUT( @"pageIndex", [NSString stringWithFormat:@"%d", _pages]);
    api.INPUT( @"pageSize", [NSString stringWithFormat:@"%d", 20] );
    
    NSString* typeString = [[NSString alloc] init];
    if(self.type == Blog)
    {
        typeString = @"latest";
    }
    else if(self.type == Recommend)
    {
        typeString = @"recommend";
    }
    
    api.INPUT( @"type", typeString);
    
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
                [self.blogs removeAllObjects];
            }
            
            [self.blogs addObjectsFromArray:api.resp.blogs];
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