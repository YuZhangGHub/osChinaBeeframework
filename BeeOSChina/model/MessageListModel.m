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
//  MessageListModel.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/9.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "MessageListModel.h"
#import "oschina.h"
#import "UserModel.h"

#pragma mark -

@implementation MessageListModel

- (void)load
{
    self.pages    = 0;
    self.more     = YES;
    self.messages = [[NSMutableArray alloc] init];
    [self loadCache];
}

- (void)unload
{
    [self saveCache];
    self.messages = nil;
}

- (NSString *)cacheKey
{
    // You should set an identified key if this model is shared.
    return NSStringFromClass([self class]);
}

- (void)loadCache
{
    [self.messages removeAllObjects];
    [self.messages addObjectsFromArray:[MESSAGE readFromUserDefaults:[self cacheKey]]];
}

- (void)saveCache
{
    [MESSAGE userDefaultsWrite:[self.messages objectToString] forKey:[self cacheKey]];
}

- (void)clearCache
{
    [MESSAGE userDefaultsRemove:[self cacheKey]];
    [self.messages removeAllObjects];
    
    self.loaded = NO;
}

#pragma mark -

- (void)firstPage
{
    _pages = 0;
    [API_MESSAGE_LIST cancel];
    
    API_MESSAGE_LIST * api = [API_MESSAGE_LIST apiWithResponder:self];
    
    // config your pagination
    // api.req.paging.offset = @(0);
    // api.req.paging.limit = @(10);
    UserModel* userModel = [UserModel sharedInstance];
    
    api.INPUT( @"pageIndex", @"0" );
    api.INPUT( @"pageSize", @"20" );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", userModel.user.uid.intValue]);
    
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
                [self.messages removeAllObjects];
                [self.messages addObjectsFromArray:api.resp.messages];
                
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
    [API_MESSAGE_LIST cancel];
    
    API_MESSAGE_LIST * api =[API_MESSAGE_LIST apiWithResponder:self];
    
    // api.req.paging.offset = @(self.messages.count);
    // api.req.paging.limit = @(10);
    UserModel* userModel = [UserModel sharedInstance];
    
    api.INPUT( @"pageIndex", [NSString stringWithFormat:@"%d", _pages]);
    api.INPUT( @"pageSize", [NSString stringWithFormat:@"%d", 20] );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", userModel.user.uid.intValue]);
    
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
                [self.messages removeAllObjects];
            }
                [self.messages addObjectsFromArray:api.resp.messages];
                
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