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
//  MiscBoardCell_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/22.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "UserModel.h"

#pragma mark -

@interface MiscBoardCell_iPhone : BeeUICell

AS_OUTLET( BeeUILabel,	label_account );
AS_MODEL( UserModel, userModel )

@end
