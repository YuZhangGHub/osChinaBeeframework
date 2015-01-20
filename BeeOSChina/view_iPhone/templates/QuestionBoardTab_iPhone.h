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
//  QuestionBoardTab_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/25.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface QuestionBoardTab_iPhone : BeeUICell

AS_OUTLET( BeeUIButton, question );
AS_OUTLET( BeeUIButton, sharing );
AS_OUTLET( BeeUIButton, synthesis );
AS_OUTLET( BeeUIButton, career );
AS_OUTLET( BeeUIButton, site );

- (void)selectQuestion;
- (void)selectSharing;
- (void)selectSynthesis;
- (void)selectCareer;
- (void)selectSite;

@end
