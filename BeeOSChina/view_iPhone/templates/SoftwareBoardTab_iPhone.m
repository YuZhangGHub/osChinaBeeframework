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
//  SoftwareBoardTab_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/24.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "SoftwareBoardTab_iPhone.h"

#pragma mark -

@implementation SoftwareBoardTab_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIButton, software_category );
DEF_OUTLET( BeeUIButton, software_recommend );
DEF_OUTLET( BeeUIButton, software_recent );
DEF_OUTLET( BeeUIButton, software_hot );
DEF_OUTLET( BeeUIButton, software_cn );

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

- (void)selectCategory
{
    $(self.software_category).ADD_CLASS( @"active" );
    $(self.software_recommend).REMOVE_CLASS( @"active" );
    $(self.software_recent).REMOVE_CLASS( @"active" );
    $(self.software_hot).REMOVE_CLASS( @"active" );
    $(self.software_cn).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectRecommend
{
    $(self.software_category).REMOVE_CLASS( @"active" );
    $(self.software_recommend).ADD_CLASS( @"active" );
    $(self.software_recent).REMOVE_CLASS( @"active" );
    $(self.software_hot).REMOVE_CLASS( @"active" );
    $(self.software_cn).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectRecent
{
    $(self.software_category).REMOVE_CLASS( @"active" );
    $(self.software_recommend).REMOVE_CLASS( @"active" );
    $(self.software_recent).ADD_CLASS( @"active" );
    $(self.software_hot).REMOVE_CLASS( @"active" );
    $(self.software_cn).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectHot
{
    $(self.software_category).REMOVE_CLASS( @"active" );
    $(self.software_recommend).REMOVE_CLASS( @"active" );
    $(self.software_recent).REMOVE_CLASS( @"active" );
    $(self.software_hot).ADD_CLASS( @"active" );
    $(self.software_cn).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectCn
{
    $(self.software_category).REMOVE_CLASS( @"active" );
    $(self.software_recommend).REMOVE_CLASS( @"active" );
    $(self.software_recent).REMOVE_CLASS( @"active" );
    $(self.software_hot).REMOVE_CLASS( @"active" );
    $(self.software_cn).ADD_CLASS( @"active" );
    
    self.RELAYOUT();
}

@end
