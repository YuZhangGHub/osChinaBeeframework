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
//  NewsBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/22.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "NewsBoardTab_iPhone.h"
#import "NewsListModel.h"
#import "BlogListModel.h"
#import "oschina.h"

#pragma mark -

@interface NewsBoard_iPhone : BeeUIBoard

AS_OUTLET( BeeUIScrollView, list );
AS_OUTLET( NewsBoardTab_iPhone,	tabbar );

AS_MODEL( NewsListModel,	news )
AS_MODEL( BlogListModel, blogList)

@property (nonatomic)      NewsType      type;

@end
