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
//  FriendBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/15.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "UserBlogListModel.h"
#import "UserDetailBoardTab_iPhone.h"
#import "UserInfoModel.h"

#pragma mark -

@interface UserDetailBoard_iPhone : BeeUIBoard

AS_OUTLET( BeeUIScrollView, list )
AS_OUTLET( UserDetailBoardTab_iPhone,	tabbar );

AS_MODEL(UserBlogListModel, userBlogs)
AS_MODEL(UserInfoModel, userInfo)

@property (nonatomic)  int         isBlog;

@end
