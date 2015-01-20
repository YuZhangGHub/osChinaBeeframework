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
//  PersonalBoardTab_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/25.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface PersonalBoardTab_iPhone : BeeUICell

AS_OUTLET( BeeUIButton, all );
AS_OUTLET( BeeUIButton, at );
AS_OUTLET( BeeUIButton, comments );
AS_OUTLET( BeeUIButton, selfstuff );
AS_OUTLET( BeeUIButton, message );

- (void)selectAll;
- (void)selectAt;
- (void)selectComments;
- (void)selectSelfStuff;
- (void)selectMessage;

- (void)setAtCount : (int)count;
- (void)setCommentCount : (int)count;
- (void)setMessageCount : (int)count;
@end
