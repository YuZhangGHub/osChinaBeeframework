//
//  RalationRoutine.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/21.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "RelationRoutine.h"
#import "UserModel.h"

@implementation RelationRoutine

DEF_NOTIFICATION( SENDING )
DEF_NOTIFICATION( SENDED )
DEF_NOTIFICATION( FAILED )

- (void) addFollow:(int) hisuid
{
    UserModel* uModel = [UserModel sharedInstance];
    
    if(uModel == nil || uModel.user == nil || uModel.user.uid == nil)
    {
        return;
    }
    
    [API_USER_UPDATERELATION cancel];
    
    API_USER_UPDATERELATION * api = [API_USER_UPDATERELATION apiWithResponder:self];
    
    int uid       = [UserModel sharedInstance].user.uid.intValue;
    
    api.INPUT( @"hisuid", [NSString stringWithFormat:@"%d", hisuid] );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", uid]);
    api.INPUT( @"newrelation", [NSString stringWithFormat:@"%d", 1]);
    
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
                    [self postNotification:self.SENDED withObject:@"2"];
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

- (void) removeFollow:(int) hisuid
{
    UserModel* uModel = [UserModel sharedInstance];
    
    if(uModel == nil || uModel.user == nil || uModel.user.uid == nil)
    {
        return;
    }
    
    [API_USER_UPDATERELATION cancel];
    
    API_USER_UPDATERELATION * api = [API_USER_UPDATERELATION apiWithResponder:self];
    
    int uid       = [UserModel sharedInstance].user.uid.intValue;
    
    api.INPUT( @"hisuid", [NSString stringWithFormat:@"%d", hisuid] );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", uid]);
    api.INPUT( @"newrelation", [NSString stringWithFormat:@"%d", 0]);
    
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
                    [self postNotification:self.SENDED withObject:@"3"];
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
