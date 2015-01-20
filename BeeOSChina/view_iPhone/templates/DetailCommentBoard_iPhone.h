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
//  DetailCommentBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/5.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "TextInputCell_iPhone.h"
#import "BrowserBoard_iPhone.h"
#import "oschina.h"

#pragma mark -

@interface DetailCommentBoard_iPhone : BrowserBoard_iPhone

@property (nonatomic, retain) COMMENT*              comment;
@property (nonatomic)         CommentType           type;
@property (nonatomic)         int                   articleId;
@property (nonatomic)         CommentSourceType     source;
@property (nonatomic, retain) TextInputCell_iPhone* inputCell;

AS_NOTIFICATION( COMMENT_REPLY )
AS_NOTIFICATION( BLOG_COMMENT_REPLY )

@end
