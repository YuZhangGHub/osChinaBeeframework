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
//  SearchBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/27.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "SearchBoardTab_iPhone.h"
#import "SearchListModel.h"

#pragma mark -

@interface SearchBoard_iPhone : BeeUIBoard

AS_OUTLET( BeeUIScrollView, list );
AS_OUTLET( SearchBoardTab_iPhone,	tabbar );

AS_MODEL(SearchListModel, searchList)

@end
