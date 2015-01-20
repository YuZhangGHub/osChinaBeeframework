//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  PersonalMessageCell_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/13.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "PersonalMessageCell_iPhone.h"
#import "Tool.h"
#import "oschina.h"
#import "UserModel.h"

#pragma mark -

@implementation PersonalMessageCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
}

- (void)unload
{
}

- (void)dataDidChanged
{
    // TODO: fill data
    MESSAGE * message = self.data;
    
    if ( message != nil )
    {
        UserModel* u = [UserModel sharedInstance];
        int uid      = u.user.uid.intValue;
        
        NSString* fromTo = (uid == message.senderid) ? @"发给" : @"来自";
    
        $(@"main_author").TEXT([NSString stringWithFormat:@"%@ %@", fromTo, message.friendname]);
        $(@"main_title").TEXT(message.content);
        $(@"main_time").TEXT([Tool intervalSinceNow:message.pubDate]);
        $(@"post_avatar").IMAGE(message.portrait);
        $(@"message_count").TEXT([NSString stringWithFormat:@"%d", message.messageCount]);
    }
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

@end
