//
//   ______    ______    ______    
//  /\  __ \  /\  ___\  /\  ___\   
//  \ \  __<  \ \  __\_ \ \  __\_ 
//   \ \_____\ \ \_____\ \ \_____\ 
//    \/_____/  \/_____/  \/_____/ 
//
//  Powered by BeeFramework
//
//
//  AppBoardTab_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/23.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface NewsBoardTab_iPhone : BeeUICell

AS_OUTLET( BeeUIButton, uptodatenews );
AS_OUTLET( BeeUIButton, uptodateblog );
AS_OUTLET( BeeUIButton, recommendation );

- (void)selectNews;
- (void)selectBlogs;
- (void)selectRecommendations;

@end
