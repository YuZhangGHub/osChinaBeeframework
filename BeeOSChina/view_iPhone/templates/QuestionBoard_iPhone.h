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
//  QuestionBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/22.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "QuestionBoardTab_iPhone.h"
#import "PostListModel.h"
#import "oschina.h"

#pragma mark -

@interface QuestionBoard_iPhone : BeeUIBoard

AS_OUTLET( BeeUIScrollView, list );
AS_OUTLET( QuestionBoardTab_iPhone,	tabbar );

AS_MODEL(PostListModel, postModel)

@end
