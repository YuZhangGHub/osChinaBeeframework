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
//  DetailTweetBoardTab_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/4.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface DetailTweetBoardTab_iPhone : BeeUICell

AS_OUTLET( BeeUIButton, tweettab_details );
AS_OUTLET( BeeUIButton, tweettab_comments );

- (void)selectDetail;
- (void)selectComments;

@end
