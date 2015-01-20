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
//  FriendListBoardTab_iPhoneCell.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/16.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface FriendListBoardTab_iPhone : BeeUICell

AS_OUTLET( BeeUIButton, MyFollow );
AS_OUTLET( BeeUIButton, MyFans );

- (void)selectFollowed;
- (void)selectFans;

@end
