//
//	Powered by BeeFramework
//
//
//  AppBoardTab_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/23.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "NewsBoardTab_iPhone.h"

#pragma mark -

@interface NewsBoardTab_iPhone()
{
	//<#@private var#>
}
@end

@implementation NewsBoardTab_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIButton, uptodatenews );
DEF_OUTLET( BeeUIButton, uptodateblog );
DEF_OUTLET( BeeUIButton, recommendation );

- (void)selectNews
{
    $(self.uptodatenews).ADD_CLASS( @"active" );
    $(self.uptodateblog).REMOVE_CLASS( @"active" );
    $(self.recommendation).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectBlogs
{
    $(self.uptodatenews).REMOVE_CLASS( @"active" );
    $(self.uptodateblog).ADD_CLASS( @"active" );
    $(self.recommendation).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectRecommendations
{
    $(self.uptodatenews).REMOVE_CLASS( @"active" );
    $(self.uptodateblog).REMOVE_CLASS( @"active" );
    $(self.recommendation).ADD_CLASS( @"active" );
    
    self.RELAYOUT();
}

@end
