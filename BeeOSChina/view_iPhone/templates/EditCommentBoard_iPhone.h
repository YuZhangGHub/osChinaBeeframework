//
//   ______    ______    ______    
//  /\  __ \  /\  ___\  /\  ___\   
//  \ \  __<  \ \  __\_ \ \  __\_ 
//   \ \_____\ \ \_____\ \ \_____\ 
//    \/_____/  \/_____/  \/_____/ 
//
//  Powered by BeeFramework
//
//
//  EditCommentBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/10.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "oschina.h"

#pragma mark -

@interface EditCommentBoard_iPhone : BeeUIBoard
@property (nonatomic) CommentSourceType    source;  
@property (nonatomic) int                  articleId;

AS_OUTLET(BeeUILabel, description)
AS_OUTLET(BeeUITextField, comment)
AS_OUTLET( BeeUISwitch,	switch_cell );

AS_NOTIFICATION( COMMENT_PUB )
AS_NOTIFICATION( BLOG_COMMENT_PUB )

@end
