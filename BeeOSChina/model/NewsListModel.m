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
//  NewsListModel.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/5.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "NewsListModel.h"
#import "oschina.h"

#pragma mark -

#undef	PER_PAGE
#define PER_PAGE	(20)

@implementation NewsListModel

@synthesize news = _news;

- (void)load
{
    self.news = [[NSMutableArray alloc] init];
    //由于oschina的协议特殊，more每次都会返回no, 每次取的单页，所以要手动设置more为true
    self.more = YES;
    [self loadCache];
}

- (void)unload
{
    self.news = nil;
    [self saveCache];
}

- (NSString *)cacheKey
{
    // You should set an identified key if this model is shared.
    return NSStringFromClass([self class]);
}

- (void)loadCache
{
    [self.news removeAllObjects];
    [self.news addObjectsFromArray:[NEWS readFromUserDefaults:[self cacheKey]]];
}

- (void)saveCache
{
    [NEWS userDefaultsWrite:[self.news objectToString] forKey:[self cacheKey]];
}

- (void)clearCache
{
    [NEWS userDefaultsRemove:[self cacheKey]];
    [self.news removeAllObjects];
    
    self.loaded = NO;
}

#pragma mark -

- (void)firstPage
{
    [self gotoPage:0];
}

- (void)nextPage
{
    if ( NO == self.more )
        return;
    
    if ( self.news.count )
    {
        [self gotoPage:(self.news.count / PER_PAGE + 1)];
    }
}

- (void)gotoPage:(NSUInteger)page
{
    [API_NEWS_LIST cancel];
    
    API_NEWS_LIST * api = [API_NEWS_LIST api];
    
    @weakify(api);
    @weakify(self);
    
    api.whenUpdate = ^
    {
        @normalize(api);
        @normalize(self);
        
        if ( api.sending )
        {
            [self sendUISignal:self.RELOADING];
        }
        else if(api.succeed)
        {
            if ( nil == api.resp )
            {
                api.failed = YES;
            }
            else
            {
                if ( page == 0 )
                {
                    [self.news removeAllObjects];
                }
                
                [self.news addObjectsFromArray:api.resp.news];
                    
                self.loaded = YES;
            }
            
            [self sendUISignal:self.RELOADED];
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