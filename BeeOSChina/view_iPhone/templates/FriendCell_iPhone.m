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
//  FriendCell_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/16.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "FriendCell_iPhone.h"
#import "oschina.h"

#pragma mark -

@implementation FriendCell_iPhone

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
    FRIEND* frd = self.data;
    
    if ( frd != nil )
    {
        $(@"post_avatar").IMAGE(frd.portrait);
        
        if(frd.gender == 1)
        {
            $(@"image_gender").IMAGE(@"man.png");
        }
        else
        {
            $(@"image_gender").IMAGE(@"woman.png");
        }
        
        $(@"main_author").TEXT(frd.name);
        $(@"main_title").TEXT(frd.expertise);
    }
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

@end
