//
//  RalationRoutine.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/21.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RelationRoutine : NSObject

- (void) addFollow:(int) hisuid;
- (void) removeFollow:(int) hisuid;

AS_NOTIFICATION( SENDING )
AS_NOTIFICATION( SENDED )
AS_NOTIFICATION( FAILED )

@end
