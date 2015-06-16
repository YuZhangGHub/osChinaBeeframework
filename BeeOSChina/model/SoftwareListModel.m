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
//  SoftwareListModel.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/24.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "SoftwareListModel.h"

#pragma mark -

@implementation SoftwareListModel

@synthesize softwares = _softwares;
@synthesize searchTag = _searchTag;
@synthesize pages     = _pages;

- (void)load
{
    self.softwares = [[NSMutableArray alloc] init];
    self.pages     = 0;
    self.more      = YES;
    [self loadCache];
}

- (void)unload
{
    [self saveCache];
}

- (NSString *)cacheKey
{
    // You should set an identified key if this model is shared.
    return NSStringFromClass([self class]);
}

- (void)loadCache
{
    [self.softwares removeAllObjects];
    [self.softwares addObjectsFromArray:[SOFTWARE_ITEM readFromUserDefaults:[self cacheKey]]];
}

- (void)saveCache
{
    [SOFTWARE_ITEM userDefaultsWrite:[self.softwares objectToString] forKey:[self cacheKey]];
}

- (void)clearCache
{
    [SOFTWARE_ITEM userDefaultsRemove:[self cacheKey]];
    [self.softwares removeAllObjects];
    
    self.loaded = NO;
}

#pragma mark -

- (void)firstPage
{
    BeeAPI* api = nil;
    _pages = 0;
    
    if(self.searchTag.intValue != 0)
    {
        [API_SOFTWARETAG_LIST cancel];
        api = [API_SOFTWARETAG_LIST api];
    }
    else
    {
        [API_SOFTWARE_LIST cancel];
        api = [API_SOFTWARE_LIST api];
    }
    
    api.INPUT( @"pageIndex", @"0" );
    api.INPUT( @"pageSize", @"20" );
    api.INPUT( @"searchTag", self.searchTag );
    
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
                [self.softwares removeAllObjects];
                
                if(self.searchTag.intValue != 0)
                {
                    API_SOFTWARETAG_LIST* subApi = (API_SOFTWARETAG_LIST*)api;
                    [self.softwares addObjectsFromArray:subApi.resp.items];
                    
                }
                else
                {
                    API_SOFTWARE_LIST* subApi = (API_SOFTWARE_LIST*)api;
                    [self.softwares addObjectsFromArray:subApi.resp.items];
                }
                
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
    BeeAPI* api = nil;
    
    if(self.searchTag.intValue != 0)
    {
        [API_SOFTWARETAG_LIST cancel];
        api = [API_SOFTWARETAG_LIST api];
    }
    else
    {
        [API_SOFTWARE_LIST cancel];
        api = [API_SOFTWARE_LIST api];
    }
    
    api.INPUT( @"pageIndex", [NSString stringWithFormat:@"%d", _pages]);
    api.INPUT( @"pageSize", [NSString stringWithFormat:@"%d", 20] );
    api.INPUT( @"searchTag", self.searchTag );
    
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
            
            if(self.searchTag.intValue != 0)
            {
                API_SOFTWARETAG_LIST* subApi = (API_SOFTWARETAG_LIST*)api;
                
                if( _pages == 0)
                {
                    [self.softwares removeAllObjects];
                }

                [self.softwares addObjectsFromArray:subApi.resp.items];
                
            }
            else
            {
                API_SOFTWARE_LIST* subApi = (API_SOFTWARE_LIST*)api;
                
                if( _pages == 0)
                {
                    [self.softwares removeAllObjects];
                }

                [self.softwares addObjectsFromArray:subApi.resp.items];
            }
            
                self.loaded = YES;
                [self sendUISignal:self.RELOADED];
                self.pages  = self.pages + 1;
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