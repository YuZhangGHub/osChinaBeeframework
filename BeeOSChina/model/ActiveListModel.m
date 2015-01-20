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
//  ActiveListModel.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/9.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "ActiveListModel.h"
#import "oschina.h"
#import "UserModel.h"

#pragma mark -

@implementation ActiveListModel
@synthesize catalog = _catalog;
@synthesize pages   = _pages;

- (void)load
{
    _catalog     = 1;
    _pages       = 0;
    self.more    = YES;
    self.actives = [[NSMutableArray alloc] init];
    [self loadCache];
}

- (void)unload
{
    [self saveCache];
    self.actives = nil;
}

- (NSString *)cacheKey
{
    // You should set an identified key if this model is shared.
    return NSStringFromClass([self class]);
}

- (void)loadCache
{
    //[self.actives removeAllObjects];
    //[self.actives addObjectsFromArray:[ACTIVITY readFromUserDefaults:[self cacheKey]]];
}

- (void)saveCache
{
    [ACTIVITY userDefaultsWrite:[self.actives objectToString] forKey:[self cacheKey]];
}

- (void)clearCache
{
    [ACTIVITY userDefaultsRemove:[self cacheKey]];
    [self.actives removeAllObjects];
    
    self.loaded = NO;
}

#pragma mark -

- (void)firstPage
{
    _pages = 0;
    
    [API_ACTIVITY_LIST cancel];
    
    API_ACTIVITY_LIST * api = [API_ACTIVITY_LIST apiWithResponder:self];
    
    // config your pagination
    // api.req.paging.offset = @(0);
    // api.req.paging.limit = @(10);
    UserModel* userModel = [UserModel sharedInstance];
    
    api.INPUT( @"pageIndex", @"0" );
    api.INPUT( @"pageSize", @"20" );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", userModel.user.uid.intValue]);
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
                [self.actives removeAllObjects];
                [self.actives addObjectsFromArray:api.resp.activities];
                
                // self.paged = api.resp.paged;
                self.loaded = YES;
                _pages      = 1;
                
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
    [API_ACTIVITY_LIST cancel];
    
    API_ACTIVITY_LIST * api =[API_ACTIVITY_LIST apiWithResponder:self];
    
    // api.req.paging.offset = @(self.actives.count);
    // api.req.paging.limit = @(10);
    UserModel* userModel = [UserModel sharedInstance];
    
    int curBegin = self.pages * 20;
    int curEnd   = curBegin + 20;
    api.INPUT( @"pageIndex", [NSString stringWithFormat:@"%d", curBegin]);
    api.INPUT( @"pageSize", [NSString stringWithFormat:@"%d", curEnd] );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", userModel.user.uid.intValue]);
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
                [self.actives removeAllObjects];
            }
                [self.actives addObjectsFromArray:api.resp.activities];
                
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