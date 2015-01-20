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
//  CommentsBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/5.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "CommentsModel.h"
#import "BlogCommentsModel.h"
#import "oschina.h"

#pragma mark -

@interface CommentsBoard_iPhone : BeeUIBoard

AS_MODEL( CommentsModel,	 commentList )
AS_MODEL( BlogCommentsModel, blogCommentList)

AS_OUTLET( BeeUIScrollView,			list );

@property (nonatomic) CommentType        type;
@property (nonatomic) CommentSourceType  source;

@end
