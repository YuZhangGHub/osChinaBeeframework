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
//  FavoriteCell_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/15.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "FavoriteCell_iPhone.h"
#import "oschina.h"

#pragma mark -

@implementation FavoriteCell_iPhone

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
    FAVORITE* fav = self.data;
    
    if ( fav != nil )
    {
        $(@"catalog_name").TEXT(fav.title);
    }
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

@end
