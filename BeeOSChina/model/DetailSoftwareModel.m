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
//  DetailSoftwareModel.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/24.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "DetailSoftwareModel.h"

#pragma mark -

@implementation DetailSoftwareModel

@synthesize software     = _software;
@synthesize softwareName = _softwareName;

- (void)load
{
    [self loadCache];
}

- (void)unload
{
    [self saveCache];
    self.software     = nil;
    self.softwareName = nil;
}

#pragma mark -

- (NSString *)cacheKey
{
    // You should set an identified key if this model is shared.
    return NSStringFromClass([self class]);
}

- (void)loadCache
{
    self.software = [SOFTWARE readFromUserDefaults:[self cacheKey]];
}

- (void)saveCache
{
    [SOFTWARE userDefaultsWrite:[self.software objectToString] forKey:[self cacheKey]];
    //[SESSION userDefaultsWrite:[self.session objectToString] forKey:@"UserModel.session"];
}

- (void)clearCache
{
    [SOFTWARE removeFromUserDefaults:[self cacheKey]];
    self.software = nil;
    
    self.loaded = NO;
}

- (void)reload
{
    [API_SOFTWARE_DETAIL cancel];
    
    API_SOFTWARE_DETAIL * api = [API_SOFTWARE_DETAIL api];
    
    // TODO: config your req
    api.INPUT( @"ident", self.softwareName );
    
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
//                // TODO: handle resp
            self.software = api.resp;
                self.loaded   = YES;
                [self sendUISignal:self.RELOADED];
//            }
        }
        else if ( api.failed )
        {
            [self sendUISignal:self.FAILED];
        }
        else if ( api.cancelled )
        {
            [self sendUISignal:self.RELOADED];
        }
    };
    
    [api send];
}

@end