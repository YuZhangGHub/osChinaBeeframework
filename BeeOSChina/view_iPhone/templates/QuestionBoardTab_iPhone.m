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
//  QuestionBoardTab_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/25.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "QuestionBoardTab_iPhone.h"

#pragma mark -

@implementation QuestionBoardTab_iPhone

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

- (void)selectQuestion
{
    $(self.question).ADD_CLASS( @"active" );
    $(self.sharing).REMOVE_CLASS( @"active" );
    $(self.synthesis).REMOVE_CLASS( @"active" );
    $(self.career).REMOVE_CLASS( @"active" );
    $(self.site).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectSharing
{
    $(self.sharing).ADD_CLASS( @"active" );
    $(self.question).REMOVE_CLASS( @"active" );
    $(self.synthesis).REMOVE_CLASS( @"active" );
    $(self.career).REMOVE_CLASS( @"active" );
    $(self.site).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectSynthesis
{
    $(self.question).REMOVE_CLASS( @"active" );
    $(self.sharing).REMOVE_CLASS( @"active" );
    $(self.synthesis).ADD_CLASS( @"active" );
    $(self.career).REMOVE_CLASS( @"active" );
    $(self.site).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectCareer
{
    $(self.question).REMOVE_CLASS( @"active" );
    $(self.sharing).REMOVE_CLASS( @"active" );
    $(self.synthesis).REMOVE_CLASS( @"active" );
    $(self.career).ADD_CLASS( @"active" );
    $(self.site).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectSite
{
    $(self.question).REMOVE_CLASS( @"active" );
    $(self.sharing).REMOVE_CLASS( @"active" );
    $(self.synthesis).REMOVE_CLASS( @"active" );
    $(self.career).REMOVE_CLASS( @"active" );
    $(self.site).ADD_CLASS( @"active" );
    
    self.RELAYOUT();
}

@end
