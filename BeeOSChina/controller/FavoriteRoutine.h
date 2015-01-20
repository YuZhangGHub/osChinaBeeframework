//
//  FavoriteRoutine.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/11.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteRoutine : NSObject

- (void) addFavorite:(int) objid type:(int) type;
- (void) deleteFavorite:(int) objid type:(int) type;

AS_NOTIFICATION( SENDING )
AS_NOTIFICATION( SENDED )
AS_NOTIFICATION( FAILED )

@end
