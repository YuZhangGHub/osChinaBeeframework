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
//  ItemBoardCell_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/6.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "oschina.h"

#pragma mark -

@interface ItemBoardCell_iPhone : BeeUICell

AS_OUTLET( BeeUILabel,		title )
AS_OUTLET( BeeUILabel,		author )

@property NewsType                sourceType;
@end
