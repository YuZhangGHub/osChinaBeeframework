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
//  SoftwareTypeList.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/24.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "SoftwareTypeListModel.h"

#pragma mark -

@implementation SoftwareTypeListModel

@synthesize types = _types;
@synthesize tag   = _tag;

- (void)load
{
    self.tag   = 0;
    self.more = YES;
    self.types = [[NSMutableArray alloc] init];
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
    [self.types removeAllObjects];
    [self.types addObjectsFromArray:[SOFTWARE_TYPE readFromUserDefaults:[self cacheKey]]];
}

- (void)saveCache
{
    [SOFTWARE_TYPE userDefaultsWrite:[self.types objectToString] forKey:[self cacheKey]];
}

- (void)clearCache
{
    [SOFTWARE_TYPE userDefaultsRemove:[self cacheKey]];
    [self.types removeAllObjects];
    
    self.loaded = NO;
}

#pragma mark -

- (void)firstPage
{
    [API_SOFTWARE_CATALOGS cancel];
    
    API_SOFTWARE_CATALOGS * api = [API_SOFTWARE_CATALOGS api];
    
    api.INPUT( @"tag", [NSString stringWithFormat:@"%d", self.tag] );
    
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
                [self.types removeAllObjects];
                [self.types addObjectsFromArray:api.resp.types];
                
                // self.paged = api.resp.paged;
                self.loaded = YES;
                
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
    [API_SOFTWARE_CATALOGS cancel];
    
    API_SOFTWARE_CATALOGS * api =[API_SOFTWARE_CATALOGS api];
    
    api.INPUT( @"tag", [NSString stringWithFormat:@"%d", self.tag] );
    
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
                [self.types removeAllObjects];
                [self.types addObjectsFromArray:api.resp.types];
                
//                self.paged = api.resp.paged;
                self.more = (self.types.count >= api.resp.total.intValue) ? NO : YES;
                self.loaded = YES;
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