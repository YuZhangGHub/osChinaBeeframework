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
//  UserModel.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/19.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "UserModel.h"

#pragma mark -

@implementation UserModel

DEF_SINGLETON( UserModel )

//@synthesize session = _session;
@synthesize user = _user;
@dynamic    avatar;

DEF_NOTIFICATION( LOGIN )
DEF_NOTIFICATION( LOGOUT )
DEF_NOTIFICATION( UPDATED )
DEF_NOTIFICATION( GET_PROFILE )

- (void)load
{
    [self loadCache];
}

- (void)unload
{
    [self saveCache];
    
    self.user = nil;
}

- (UIImage *)avatar
{
    NSString * avatarPath = [NSString stringWithFormat:@"%@/avatar-u-%@.png", [BeeSandbox libCachePath], self.user.uid];
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:avatarPath] )
    {
        NSData * data = [NSData dataWithContentsOfFile:avatarPath];
        
        if ( data )
        {
            return [UIImage imageWithData:data];
        }
    }
    
    return nil;
}

- (void)setAvatar:(UIImage *)avatar
{
    NSString * avatarPath = [NSString stringWithFormat:@"%@/avatar-u-%@.png", [BeeSandbox libCachePath], self.user.uid];
    
    
    if ( nil == avatar )
    {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:avatarPath] )
        {
            [[NSFileManager defaultManager] removeItemAtPath:avatarPath error:nil];
        }
    }
    else
    {
        [[avatar dataWithExt:@"png"] writeToFile:avatarPath atomically:YES];
    }
    
    //Todo: post the avatar to the server
}

#pragma mark -

- (void)loadCache
{
    self.user = [USER readFromUserDefaults:@"UserModel.user"];
   // self.session = [SESSION readFromUserDefaults:@"UserModel.session"];
    
    if ( self.user )
    {
        [self setOnline:YES];
    }
//    	else
//    	{
//    		[self setOffline:NO];
//    	}
}

- (void)saveCache
{
    [USER userDefaultsWrite:[self.user objectToString] forKey:@"UserModel.user"];
    //[SESSION userDefaultsWrite:[self.session objectToString] forKey:@"UserModel.session"];
}

- (void)clearCache
{
    [USER removeFromUserDefaults:@"UserModel.user"];
    //[SESSION removeFromUserDefaults:@"UserModel.session"];
    
    //self.session = nil;
    self.user = nil;
    
    self.loaded = NO;
}

#pragma mark -

+ (BOOL)online
{
    if ( [UserModel sharedInstance].user )
        return YES;
    
    return NO;
}

- (void)setOnline:(BOOL)notify
{
    [USER userDefaultsWrite:[self.user objectToString] forKey:@"UserModel.user"];
    //[SESSION userDefaultsWrite:[self.session objectToString] forKey:@"UserModel.session"];
    
//    [BeeMessage setHeader:self.session forKey:@"session"];
//    [BeeMessage setHeader:self.user forKey:@"user"];
    
    if ( notify )
    {
        [self postNotification:self.LOGIN];
    }
}

- (void)setOffline:(BOOL)notify
{
    [USER removeFromUserDefaults:@"UserModel.user"];
    //[SESSION removeFromUserDefaults:@"UserModel.session"];
    
//    [BeeMessage removeHeaderForKey:@"session"];
//    [BeeMessage removeHeaderForKey:@"user"];
    
    //self.session = nil;
    self.user = nil;
    
    [self clearCookie];
    
    if ( notify )
    {
        [self postNotification:self.LOGOUT];
    }
}

//- (void)openDatabase
//{
//	if ( self.user )
//	{
//		[BeeDatabase openSharedDatabase:[NSString stringWithFormat:@"%@.sqlite", self.user.id]];
//	}
//	else
//	{
//		[BeeDatabase openSharedDatabase:@"default.sqlite"];
//	}
//}

//清除cookies
- (void)clearCookie
{
    NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray * cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/user/signin", [ServerConfig sharedInstance].url] ]];
    
    for ( NSHTTPCookie * cookie in cookies )
    {
        [cookieStorage deleteCookie:cookie];
    }
}

#pragma mark -

- (void)signinWithUser:(NSString *)user
              password:(NSString *)password
{
    [API_LOGIN cancel];
    [API_USER_PROFILE cancel];
    
    API_LOGIN* api = [API_LOGIN api];
    
    api.INPUT( @"username", user );
    api.INPUT( @"pwd", password );
    api.INPUT( @"keep_login", @"1" );
    
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
            self.loaded = YES;
            USER* user               = api.resp;
            
            self.user                = nil;
            self.user                = [[USER alloc] init];
            
            self.user.uid            = user.uid;
            self.user.from           = user.from;
            self.user.name           = user.name;
            self.user.follow_num     = user.follow_num;
            self.user.fan_num        = user.fan_num;
            self.user.score          = user.score;
            self.user.portrait       = user.portrait;
            self.user.user_notice    = user.user_notice;
            
            [self setOnline:YES];
            [self sendUISignal:self.RELOADED];
            [self postNotification:self.LOGIN];
            //            }
        }
        else if ( api.failed )
        {
            [self sendUISignal :self.FAILED withObject:api];
        }
        else if ( api.cancelled )
        {
            [self sendUISignal:self.RELOADED];
        }
    };
    
    [api send];
}

- (void)signout
{
    [API_LOGIN cancel];
    [API_USER_PROFILE cancel];
    
    [self setOffline:YES];
    //[self sendUISignal:self.LOGOUT];
    [self postNotification:self.LOGOUT];
}

- (void)getProfile
{
    [API_LOGIN cancel];
    [API_USER_PROFILE cancel];
    
    API_USER_PROFILE* api = [API_USER_PROFILE api];
    
    api.INPUT( @"uid", self.user.uid );
    
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
            self.loaded = YES;
            //Update local user object with user profile
            USER_PROFILE* profile    = api.resp;
            self.user.name           = profile.name;
            self.user.portrait       = profile.portrait;
            self.user.joindate       = profile.joindate;
            self.user.gender         = profile.gender;
            self.user.from           = profile.from;
            self.user.devplatform    = profile.devplatform;
            self.user.expertise      = profile.expertise;
            self.user.fan_num        = profile.fan_num;
            self.user.favorite_count = profile.favorite_count;
            self.user.follow_num     = profile.follow_num;
            self.user.user_notice    = profile.user_notice;
            
            [self sendUISignal:self.RELOADED];
            [self postNotification:self.GET_PROFILE];
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

- (void)updateProfile
{
//    self.CANCEL_MSG( API.user_info );
//    self.MSG( API.user_info );
}

@end
