//
//  NoticeRoutine.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/22.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "NoticeRoutine.h"
#import "UserModel.h"
#import "oschina.h"

@implementation NoticeRoutine

DEF_NOTIFICATION( SENDING )
DEF_NOTIFICATION( SENDED )
DEF_NOTIFICATION( FAILED )
DEF_NOTIFICATION( CLEARED )

- (void) getNotice
{
    UserModel* uModel = [UserModel sharedInstance];
    
    if(uModel == nil || uModel.user == nil || uModel.user.uid == nil)
    {
        return;
    }
    
    [API_USER_NOTICE cancel];
    
    API_USER_NOTICE * api = [API_USER_NOTICE apiWithResponder:self];
    
    int uid       = [UserModel sharedInstance].user.uid.intValue;
    
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", uid]);
    
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
                USER_NOTICE* notice = api.resp;

                [self postNotification:self.SENDED withObject:notice];
            }
        }
        else if ( api.failed )
        {
            [self postNotification:self.FAILED];
        }
    };
    
    [api send];
}

- (void) clearNotice:(int) type
{
    UserModel* uModel = [UserModel sharedInstance];
    
    if(uModel == nil || uModel.user == nil || uModel.user.uid == nil)
    {
        return;
    }
    
    [API_NOTICE_CLEAR cancel];
    
    API_NOTICE_CLEAR * api = [API_NOTICE_CLEAR apiWithResponder:self];
    
    int uid       = [UserModel sharedInstance].user.uid.intValue;
    
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
                [self postNotification:self.CLEARED withObject:[NSString stringWithFormat:@"%d", type]];
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
