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
//  SearchBoardTab_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/27.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface SearchBoardTab_iPhone : BeeUICell

AS_OUTLET( BeeUIButton, software );
AS_OUTLET( BeeUIButton, question );
AS_OUTLET( BeeUIButton, blog );
AS_OUTLET( BeeUIButton, news );

- (void)selectSoftware;
- (void)selectQuestion;
- (void)selectBlog;
- (void)selectNews;

@end
