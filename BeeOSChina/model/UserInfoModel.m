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
//  UserInfoModel.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/9.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "UserInfoModel.h"
#import "UserModel.h"

#pragma mark -

@implementation UserInfoModel
@synthesize hisuid  = _hisuid;
@synthesize hisname = _hisname;
@synthesize pages   = _pages;

- (void)load
{
    _hisuid   = 0;
    _pages    = 0;
    self.more = YES;
    [self loadCache];
}

- (void)unload
{
    [self saveCache];
    self.user.activities = nil;
    self.user            = nil;
}

- (NSString *)cacheKey
{
    // You should set an identified key if this model is shared.
    return NSStringFromClass([self class]);
}

- (void)loadCache
{
    //self.user = [USER_INFO readFromUserDefaults:[self cacheKey]];
}

- (void)saveCache
{
    //[USER_INFO userDefaultsWrite:[self.user objectToString] forKey:[self cacheKey]];
}

- (void)clearCache
{
    [USER_INFO removeFromUserDefaults:[self cacheKey]];
    self.user = nil;
    
    self.loaded = NO;
}

#pragma mark -

- (void)firstPage
{
    _pages = 0;
    [API_USER_INFO cancel];
    
    API_USER_INFO * api = [API_USER_INFO apiWithResponder:self];
    
    // config your pagination
    // api.req.paging.offset = @(0);
    // api.req.paging.limit = @(10);
    UserModel* userModel = [UserModel sharedInstance];
    
    api.INPUT( @"pageIndex", @"0" );
    api.INPUT( @"pageSize", @"20" );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", userModel.user.uid.intValue]);
    
    if(_hisuid > 0)
    {
        api.INPUT( @"hisuid", [NSString stringWithFormat:@"%d", self.hisuid]);
    }
    else
    {
        api.INPUT( @"hisname", self.hisname );
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
                self.user = api.resp;
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
    [API_USER_INFO cancel];
    
    API_USER_INFO * api =[API_USER_INFO apiWithResponder:self];
    
    // api.req.paging.offset = @(self.user.count);
    // api.req.paging.limit = @(10);
    UserModel* userModel = [UserModel sharedInstance];
    
    api.INPUT( @"pageIndex", [NSString stringWithFormat:@"%d", _pages]);
    api.INPUT( @"pageSize", [NSString stringWithFormat:@"%d", 20] );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", userModel.user.uid.intValue]);
    
    if(_hisuid > 0)
    {
        api.INPUT( @"hisuid", [NSString stringWithFormat:@"%d", self.hisuid]);
    }
    else
    {
        api.INPUT( @"hisname", self.hisname );
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
            
                [self.user.activities addObjectsFromArray:api.resp.activities];
                self.user.relation     = api.resp.relation;
                self.user.fans         = api.resp.fans;
                self.user.followers    = api.resp.followers;
                self.user.latestonline = api.resp.latestonline;
                self.user.name         = api.resp.name;
                self.user.portrait     = api.resp.portrait;
                self.user.joindate     = api.resp.joindate;
                self.user.gender       = api.resp.gender;
                self.user.from         = api.resp.from;
                self.user.devplatform  = api.resp.devplatform;
                self.user.expertise    = api.resp.expertise;
                self.user.uid          = api.resp.uid;
                self.user.score        = api.resp.score;
                self.user.user_notice  = api.resp.user_notice;
            
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