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
//  FavoriteBoardTab_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/16.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "FavoriteBoardTab_iPhone.h"

#pragma mark -

@implementation FavoriteBoardTab_iPhone

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
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

- (void)selectSoftware
{
    $(self.software).ADD_CLASS( @"active" );
    $(self.topic).REMOVE_CLASS( @"active" );
    $(self.code).REMOVE_CLASS( @"active" );
    $(self.blog).REMOVE_CLASS( @"active" );
    $(self.news).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectTopic
{
    $(self.software).REMOVE_CLASS( @"active" );
    $(self.topic).ADD_CLASS( @"active" );
    $(self.code).REMOVE_CLASS( @"active" );
    $(self.blog).REMOVE_CLASS( @"active" );
    $(self.news).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectCode
{
    $(self.software).REMOVE_CLASS( @"active" );
    $(self.topic).REMOVE_CLASS( @"active" );
    $(self.code).ADD_CLASS( @"active" );
    $(self.blog).REMOVE_CLASS( @"active" );
    $(self.news).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectBlog
{
    $(self.software).REMOVE_CLASS( @"active" );
    $(self.topic).REMOVE_CLASS( @"active" );
    $(self.code).REMOVE_CLASS( @"active" );
    $(self.blog).ADD_CLASS( @"active" );
    $(self.news).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectNews
{
    $(self.software).REMOVE_CLASS( @"active" );
    $(self.topic).REMOVE_CLASS( @"active" );
    $(self.code).REMOVE_CLASS( @"active" );
    $(self.blog).REMOVE_CLASS( @"active" );
    $(self.news).ADD_CLASS( @"active" );
    
    self.RELAYOUT();
}

@end
