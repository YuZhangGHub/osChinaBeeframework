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
//  FavoritesListModel.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/9.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "FavoritesListModel.h"
#import "oschina.h"
#import "UserModel.h"

#pragma mark -

@implementation FavoritesListModel
@synthesize type  = _type;
@synthesize pages = _pages;

- (void)load
{
    _type         = 0;
    _pages        = 0;
    self.more     = YES;
    self.favorits = [[NSMutableArray alloc] init];
    [self loadCache];
}

- (void)unload
{
    [self saveCache];
    self.favorits = nil;
}

- (NSString *)cacheKey
{
    // You should set an identified key if this model is shared.
    return NSStringFromClass([self class]);
}

- (void)loadCache
{
    [self.favorits removeAllObjects];
    [self.favorits addObjectsFromArray:[FAVORITE readFromUserDefaults:[self cacheKey]]];
}

- (void)saveCache
{
    [FAVORITE userDefaultsWrite:[self.favorits objectToString] forKey:[self cacheKey]];
}

- (void)clearCache
{
    [FAVORITE userDefaultsRemove:[self cacheKey]];
    [self.favorits removeAllObjects];
    
    self.loaded = NO;
}

#pragma mark -

- (void)firstPage
{
    _pages = 0;
    
    [API_FAVORITE_LIST cancel];
    
    API_FAVORITE_LIST * api = [API_FAVORITE_LIST apiWithResponder:self];
    
    // config your pagination
    // api.req.paging.offset = @(0);
    // api.req.paging.limit = @(10);
    UserModel* userModel = [UserModel sharedInstance];
    
    api.INPUT( @"pageIndex", @"0" );
    api.INPUT( @"pageSize", @"20" );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", userModel.user.uid.intValue]);
    api.INPUT( @"type", [NSString stringWithFormat:@"%d", self.type]);
    
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
                [self.favorits removeAllObjects];
                [self.favorits addObjectsFromArray:api.resp.favorites];
                
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
    [API_FAVORITE_LIST cancel];
    
    API_FAVORITE_LIST * api =[API_FAVORITE_LIST apiWithResponder:self];
    
    // api.req.paging.offset = @(self.favorits.count);
    // api.req.paging.limit = @(10);
    UserModel* userModel = [UserModel sharedInstance];
    
    api.INPUT( @"pageIndex", [NSString stringWithFormat:@"%d", _pages]);
    api.INPUT( @"pageSize", [NSString stringWithFormat:@"%d", 20] );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", userModel.user.uid.intValue]);
    api.INPUT( @"type", [NSString stringWithFormat:@"%d", self.type]);
    
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
                [self.favorits removeAllObjects];
            }
                [self.favorits addObjectsFromArray:api.resp.favorites];
                
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