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
//  UserDetailBoardTab_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/21.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface UserDetailBoardTab_iPhone : BeeUICell

AS_OUTLET( BeeUIButton, activities );
AS_OUTLET( BeeUIButton, blogs );

- (void)selectActivities;
- (void)selectBlogs;

@end
