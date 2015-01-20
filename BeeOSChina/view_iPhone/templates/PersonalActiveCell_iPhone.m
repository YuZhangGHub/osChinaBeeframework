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
//  PersonalActiveCell_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/13.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "PersonalActiveCell_iPhone.h"
#import "Tool.h"
#import "oschina.h"

#pragma mark -

@implementation PersonalActiveCell_iPhone

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
    ACTIVITY * activity = self.data;
    
    if ( activity != nil )
    {
        NSString* viewString = [Tool getTextViewString2:activity.author andObjectType:activity.objecttype andObjectCatalog:activity.objectcatalog andObjectTitle:activity.objecttitle andMessage:@"" andPubDate:activity.pubDate];
        
        $(@"main_author").TEXT(viewString);
        $(@"main_title").TEXT(activity.message);
        $(@"main_time").TEXT([Tool intervalSinceNow:activity.pubDate]);
        $(@"post_avatar").IMAGE(activity.portrait);
    }
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

@end
