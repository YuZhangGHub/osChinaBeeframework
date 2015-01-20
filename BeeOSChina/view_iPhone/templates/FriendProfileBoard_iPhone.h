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
//  FriendProfileBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/15.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "oschina.h"

#pragma mark -

@class RelationRoutine;

@interface FriendProfileBoard_iPhone : BeeUIBoard

@property (nonatomic, retain)   USER_INFO*       user;
@property (nonatomic, retain)   RelationRoutine* relationRoutine;

@end
