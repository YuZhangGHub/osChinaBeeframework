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
//  SoftwareDetailBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/24.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "BrowserBoard_iPhone.h"
#import "DetailSoftwareModel.h"

@class FavoriteRoutine;

#pragma mark -

@interface SoftwareDetailBoard_iPhone : BrowserBoard_iPhone<UIWebViewDelegate>
{
}
AS_MODEL( DetailSoftwareModel,  detailSoftwareModel)
@property (nonatomic, retain) FavoriteRoutine*       favroutine;
@end
