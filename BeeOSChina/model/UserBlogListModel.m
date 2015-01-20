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
//  UserBlogListModel.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/9.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "UserBlogListModel.h"
#import "oschina.h"
#import "UserModel.h"

#pragma mark -

@implementation UserBlogListModel
@synthesize authorid   = _authorid;
@synthesize authorname = _authorname;
@synthesize pages      = _pages;

- (void)load
{
    _authorid  = 0;
    _pages     = 0;
    self.more  = YES;
    self.blogs = [[NSMutableArray alloc] init];
    [self loadCache];
}

- (void)unload
{
    [self saveCache];
    self.blogs = nil;
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
    
    API_BLOG_LIST * api = [API_BLOG_LIST apiWithResponder:self];
    
    // config your pagination
    // api.req.paging.offset = @(0);
    // api.req.paging.limit = @(10);
    UserModel* userModel = [UserModel sharedInstance];
    api.INPUT( @"pageIndex", @"0" );
    api.INPUT( @"pageSize", @"20" );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", userModel.user.uid.intValue]);
    
    if(_authorid > 0)
    {
        api.INPUT( @"authorid", [NSString stringWithFormat:@"%d", self.authorid]);
    }
    else
    {
        api.INPUT( @"authorname", self.authorname );
    }
    
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
                _pages = 1;
                
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
    
    API_BLOG_LIST * api =[API_BLOG_LIST apiWithResponder:self];
    
    // api.req.paging.offset = @(self.blogs.count);
    // api.req.paging.limit = @(10);
    UserModel* userModel = [UserModel sharedInstance];
    int curBegin = self.pages * 20;
    int curEnd   = curBegin + 20;
    api.INPUT( @"pageIndex", [NSString stringWithFormat:@"%d", curBegin]);
    api.INPUT( @"pageSize", [NSString stringWithFormat:@"%d", curEnd] );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", userModel.user.uid.intValue]);
    
    if(_authorid > 0)
    {
        api.INPUT( @"authorid", [NSString stringWithFormat:@"%d", self.authorid]);
    }
    else
    {
        api.INPUT( @"authorname", self.authorname );
    }
    
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
                _pages += 1;
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