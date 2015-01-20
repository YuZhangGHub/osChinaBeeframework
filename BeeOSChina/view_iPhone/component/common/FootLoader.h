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
//  FootLoader.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/30.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface FootLoader : BeeUIFootLoader

AS_OUTLET( BeeUILabel,					state )
AS_OUTLET( BeeUIActivityIndicatorView,	indicator )

@end
