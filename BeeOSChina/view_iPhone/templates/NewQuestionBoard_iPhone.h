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
//  NewQuestionBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/11.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "QuestionBoardTab_iPhone.h"
#import "oschina.h"

#pragma mark -

@interface NewQuestionBoard_iPhone : BeeUIBoard

AS_OUTLET( QuestionBoardTab_iPhone,	tabbar );
AS_OUTLET( BeeUISwitch,	switch_email );
@property (nonatomic) PostType           catalog;

@end
