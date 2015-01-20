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
//  PullLoader.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/30.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface PullLoader : BeeUIPullLoader

AS_OUTLET( BeeUILabel,					status )
AS_OUTLET( BeeUILabel,					date )
AS_OUTLET( BeeUIImageView,				arrow )
AS_OUTLET( BeeUIActivityIndicatorView,	indicator )

@end
