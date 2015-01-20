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
//  FavoriteBoardTab_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/16.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface FavoriteBoardTab_iPhone : BeeUICell

AS_OUTLET( BeeUIButton, software );
AS_OUTLET( BeeUIButton, topic );
AS_OUTLET( BeeUIButton, code );
AS_OUTLET( BeeUIButton, blog );
AS_OUTLET( BeeUIButton, news );

- (void)selectSoftware;
- (void)selectTopic;
- (void)selectCode;
- (void)selectBlog;
- (void)selectNews;

@end
