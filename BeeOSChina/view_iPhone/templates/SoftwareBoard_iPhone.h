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
//  SoftwareBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/24.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "SoftwareBoardTab_iPhone.h"
#import "SoftwareTypeListModel.h"
#import "SoftwareListModel.h"

#pragma mark -

@interface SoftwareBoard_iPhone : BeeUIBoard

AS_OUTLET( BeeUIScrollView, list );
AS_OUTLET( SoftwareBoardTab_iPhone,	tabbar );

AS_MODEL( SoftwareTypeListModel,	types )
AS_MODEL( SoftwareListModel,	items )

@property BOOL                    isTagList;
@property int                     currentTag;
@property int                     parentTag;
@end
