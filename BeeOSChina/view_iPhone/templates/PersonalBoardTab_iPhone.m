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
//  PersonalBoardTab_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/25.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "PersonalBoardTab_iPhone.h"

#pragma mark -

@implementation PersonalBoardTab_iPhone

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

- (void)selectAll
{
    $(self.all).ADD_CLASS( @"active" );
    $(self.at).REMOVE_CLASS( @"active" );
    $(self.comments).REMOVE_CLASS( @"active" );
    $(self.selfstuff).REMOVE_CLASS( @"active" );
    $(self.message).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectAt
{
    $(self.all).REMOVE_CLASS( @"active" );
    $(self.at).ADD_CLASS( @"active" );
    $(self.comments).REMOVE_CLASS( @"active" );
    $(self.selfstuff).REMOVE_CLASS( @"active" );
    $(self.message).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectComments
{
    $(self.all).REMOVE_CLASS( @"active" );
    $(self.at).REMOVE_CLASS( @"active" );
    $(self.comments).ADD_CLASS( @"active" );
    $(self.selfstuff).REMOVE_CLASS( @"active" );
    $(self.message).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectSelfStuff
{
    $(self.all).REMOVE_CLASS( @"active" );
    $(self.at).REMOVE_CLASS( @"active" );
    $(self.comments).REMOVE_CLASS( @"active" );
    $(self.selfstuff).ADD_CLASS( @"active" );
    $(self.message).REMOVE_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)selectMessage
{
    $(self.all).REMOVE_CLASS( @"active" );
    $(self.at).REMOVE_CLASS( @"active" );
    $(self.comments).REMOVE_CLASS( @"active" );
    $(self.selfstuff).REMOVE_CLASS( @"active" );
    $(self.message).ADD_CLASS( @"active" );
    
    self.RELAYOUT();
}

- (void)setAtCount : (int)count
{
    if(count <= 0)
    {
        $(self.at).TEXT(@"@我");
    }
    else
    {
        $(self.at).TEXT([NSString stringWithFormat:@"@我(%d)", count]);
    }
}

- (void)setCommentCount : (int)count
{
    if(count <= 0)
    {
        $(self.comments).TEXT(@"评论");
    }
    else
    {
        $(self.at).TEXT([NSString stringWithFormat:@"@评论(%d)", count]);
    }
}

- (void)setMessageCount : (int)count
{
    if(count <= 0)
    {
        $(self.at).TEXT(@"留言");
    }
    else
    {
        $(self.at).TEXT([NSString stringWithFormat:@"@留言(%d)", count]);
    }
}

@end
