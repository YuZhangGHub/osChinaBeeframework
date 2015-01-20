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
//  FriendListBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/16.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "FriendListBoardTab_iPhone.h"
#import "FriendsListModel.h"

#pragma mark -

@interface FriendListBoard_iPhone : BeeUIBoard

AS_OUTLET( BeeUIScrollView, list );
AS_OUTLET( FriendListBoardTab_iPhone,	tabbar );

AS_MODEL(FriendsListModel, friendsList)

@property (nonatomic) int                 relation;  //0 关注 1 粉丝

@end
