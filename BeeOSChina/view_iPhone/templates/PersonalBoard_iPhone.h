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
//  PersonalBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/25.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "PersonalBoardTab_iPhone.h"
#import "ActiveListModel.h"
#import "MessageListModel.h"
#import "oschina.h"

@class NoticeRoutine;
#pragma mark -

@interface PersonalBoard_iPhone : BeeUIBoard

AS_OUTLET( BeeUIScrollView, list );
AS_OUTLET( PersonalBoardTab_iPhone,	tabbar );
AS_SIGNAL( SIGNIN_NOW )

AS_MODEL( ActiveListModel, activeModel)
AS_MODEL( MessageListModel, messageModel)

@property (nonatomic)         PersonalSelType    type;
@property (nonatomic, retain) NoticeRoutine*     noticeRoutine;
@property (nonatomic)         BOOL               updatingNotice;

@end
