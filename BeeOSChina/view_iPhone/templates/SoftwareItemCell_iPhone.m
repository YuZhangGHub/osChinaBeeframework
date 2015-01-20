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
//  SoftwareItemCell_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/24.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "SoftwareItemCell_iPhone.h"
#import "oschina.h"
#import "Tool.h"

#pragma mark -

@implementation SoftwareItemCell_iPhone

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
    SOFTWARE_ITEM * item = self.data;
    
    if ( item )
    {
        $(@"title").TEXT(item.name);
        $(@"author").TEXT(item.description);
    }
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

@end
