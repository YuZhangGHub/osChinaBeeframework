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
//  SimpleCommentCell_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/5.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "SimpleCommentCell_iPhone.h"
#import "oschina.h"

#pragma mark -

@implementation SimpleCommentCell_iPhone

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
    COMMENT * comment = self.data;
    
    if ( comment != nil )
    {
        NSString* author = [NSString stringWithFormat:@"%@：", comment.author];
        
        $(@"main_author").TEXT(author);
        $(@"post_avatar").IMAGE(comment.portrait);
        $(@"main_title").TEXT(comment.content);
    }
    else{
        self.frame = CGRectZero;
    }
    
    self.RELAYOUT();
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

@end
