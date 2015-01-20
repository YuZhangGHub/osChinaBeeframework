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
//  SoftwareCatalogCell_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/24.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "SoftwareCatalogCell_iPhone.h"
#import "oschina.h"
#import "Tool.h"

#pragma mark -

@implementation SoftwareCatalogCell_iPhone

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
    SOFTWARE_TYPE * type = self.data;
    
    if ( type )
    {
        $(@"catalog_name").TEXT(type.name);
    }
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

@end
