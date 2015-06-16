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
//  FriendsListModel.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/9.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "FriendsListModel.h"
#import "oschina.h"
#import "UserModel.h"

#pragma mark -

@implementation FriendsListModel

@synthesize relation = _relation;
@synthesize pages    = _pages;

- (void)load
{
    self.relation = 1;
    self.pages    = 0;
    self.more     = YES;
    self.friends  = [[NSMutableArray alloc] init];
    [self loadCache];
}

- (void)unload
{
    [self saveCache];
    self.friends  = nil;
}

- (NSString *)cacheKey
{
    // You should set an identified key if this model is shared.
    return NSStringFromClass([self class]);
}

- (void)loadCache
{
    [self.friends removeAllObjects];
    [self.friends addObjectsFromArray:[FRIEND readFromUserDefaults:[self cacheKey]]];
}

- (void)saveCache
{
    [FRIEND userDefaultsWrite:[self.friends objectToString] forKey:[self cacheKey]];
}

- (void)clearCache
{
    [FRIEND userDefaultsRemove:[self cacheKey]];
    [self.friends removeAllObjects];
    
    self.loaded = NO;
}

#pragma mark -

- (void)firstPage
{
    _pages = 0;
    
    [API_FRIEND_LIST cancel];
    
    API_FRIEND_LIST * api = [API_FRIEND_LIST apiWithResponder:self];
    
    // config your pagination
    // api.req.paging.offset = @(0);
    // api.req.paging.limit = @(10);
    UserModel* userModel = [UserModel sharedInstance];
    
    api.INPUT( @"pageIndex", @"0" );
    api.INPUT( @"pageSize", @"20" );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", userModel.user.uid.intValue]);
    api.INPUT( @"relation", [NSString stringWithFormat:@"%d", self.relation]);
    
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
                [self.friends removeAllObjects];
                [self.friends addObjectsFromArray:api.resp.friends];
                
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
    [API_FRIEND_LIST cancel];
    
    API_FRIEND_LIST * api =[API_FRIEND_LIST apiWithResponder:self];
    
    // api.req.paging.offset = @(self.friends.count);
    // api.req.paging.limit = @(10);
    UserModel* userModel = [UserModel sharedInstance];
    
    api.INPUT( @"pageIndex", [NSString stringWithFormat:@"%d", _pages]);
    api.INPUT( @"pageSize", [NSString stringWithFormat:@"%d", 20] );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", userModel.user.uid.intValue]);
    api.INPUT( @"relation", [NSString stringWithFormat:@"%d", self.relation]);
    
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
                [self.friends removeAllObjects];
            }
                [self.friends addObjectsFromArray:api.resp.friends];
                
//                self.paged = api.resp.paged;
                self.loaded = YES;
                self.pages += 1;
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