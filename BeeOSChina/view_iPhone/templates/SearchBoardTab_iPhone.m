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
//  SearchBoardTab_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/27.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "SearchBoardTab_iPhone.h"

#pragma mark -

@implementation SearchBoardTab_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

//DEF_OUTLET( BeeUIButton, software);
//DEF_OUTLET( BeeUIButton, question );
//DEF_OUTLET( BeeUIButton, blog );
//DEF_OUTLET( BeeUIButton, news );

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
    $(self.question).REMOVE_CLASS( @"active" );
    $(self.blog).REMOVE_CLASS( @"active" );
    $(self.news).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectQuestion
{
    $(self.software).REMOVE_CLASS( @"active" );
    $(self.question).ADD_CLASS( @"active" );
    $(self.blog).REMOVE_CLASS( @"active" );
    $(self.news).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectBlog
{
    $(self.software).REMOVE_CLASS( @"active" );
    $(self.question).REMOVE_CLASS( @"active" );
    $(self.blog).ADD_CLASS( @"active" );
    $(self.news).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectNews
{
    $(self.software).REMOVE_CLASS( @"active" );
    $(self.question).REMOVE_CLASS( @"active" );
    $(self.blog).REMOVE_CLASS( @"active" );
    $(self.news).ADD_CLASS( @"active" );
    
    self.RELAYOUT();
}

@end
