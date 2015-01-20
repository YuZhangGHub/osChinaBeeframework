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
//  FavoriteBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/15.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "FavoritesListModel.h"
#import "FavoriteBoardTab_iPhone.h"
#import "oschina.h"

#pragma mark -

@interface FavoriteBoard_iPhone : BeeUIBoard

AS_OUTLET( BeeUIScrollView, list );
AS_OUTLET( FavoriteBoardTab_iPhone,	tabbar );

AS_MODEL(FavoritesListModel, favoriteList)

@property (nonatomic) FavoriteType         type;

@end
