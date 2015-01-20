//
//  FavoriteRoutine.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/11.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "FavoriteRoutine.h"
#import "UserModel.h"

@implementation FavoriteRoutine

DEF_NOTIFICATION( SENDING )
DEF_NOTIFICATION( SENDED )
DEF_NOTIFICATION( FAILED )

- (void) addFavorite:(int) objid type:(int) type
{
    UserModel* uModel = [UserModel sharedInstance];
    
    if(uModel == nil || uModel.user == nil || uModel.user.uid == nil)
    {
        return;
    }
    
    [API_FAVORITE_ADD cancel];
    
    API_FAVORITE_ADD * api = [API_FAVORITE_ADD apiWithResponder:self];
    
    int uid       = [UserModel sharedInstance].user.uid.intValue;
    
    api.INPUT( @"objid", [NSString stringWithFormat:@"%d", objid] );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", uid]);
    api.INPUT( @"type", [NSString stringWithFormat:@"%d", type]);
    
    @weakify( api );
    
    api.whenUpdate = ^
    {
        @normalize( api );
        
        if ( api.sending )
        {
            [self postNotification:self.SENDING];
        }
        else if ( api.succeed )
        {
            {
                //Need not update list ui.
                RESULT* res = api.result;
                if(res.errorCode == 1)
                {
                     [self postNotification:self.SENDED];
                }
                else
                {
                     [self postNotification:self.FAILED];
                }
            }
        }
        else if ( api.failed )
        {
            [self postNotification:self.FAILED];
        }
    };
    
    [api send];
}

- (void) deleteFavorite:(int) objid type:(int) type
{
    UserModel* uModel = [UserModel sharedInstance];
    
    if(uModel == nil || uModel.user == nil || uModel.user.uid == nil)
    {
        return;
    }
    
    [API_FAVORITE_DELETE cancel];
    
    API_FAVORITE_DELETE * api = [API_FAVORITE_DELETE apiWithResponder:self];
    
    int uid       = [UserModel sharedInstance].user.uid.intValue;
    
    api.INPUT( @"objid", [NSString stringWithFormat:@"%d", objid] );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", uid]);
    api.INPUT( @"type", [NSString stringWithFormat:@"%d", type]);
    
    @weakify( api );
    
    api.whenUpdate = ^
    {
        @normalize( api );
        
        if ( api.sending )
        {
            [self postNotification:self.SENDING];
        }
        else if ( api.succeed )
        {
            {
                //Need not update list ui.
                RESULT* res = api.result;
                if(res.errorCode == 1)
                {
                    [self postNotification:self.SENDED];
                }
                else
                {
                    [self postNotification:self.FAILED];
                }
            }
        }
        else if ( api.failed )
        {
            [self postNotification:self.FAILED];
        }
    };
    
    [api send];
}

@end