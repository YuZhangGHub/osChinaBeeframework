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
//  SoftwareBoardTab_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/24.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface SoftwareBoardTab_iPhone : BeeUICell

AS_OUTLET( BeeUIButton, software_category );
AS_OUTLET( BeeUIButton, software_recommend );
AS_OUTLET( BeeUIButton, software_recent );
AS_OUTLET( BeeUIButton, software_hot );
AS_OUTLET( BeeUIButton, software_cn );

- (void)selectCategory;
- (void)selectRecommend;
- (void)selectRecent;
- (void)selectHot;
- (void)selectCn;

@end
