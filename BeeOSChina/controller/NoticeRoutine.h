//
//  NoticeRoutine.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/22.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeRoutine : NSObject

- (void) getNotice;
- (void) clearNotice:(int) type;

AS_NOTIFICATION( SENDING )
AS_NOTIFICATION( SENDED )
AS_NOTIFICATION( CLEARED )
AS_NOTIFICATION( FAILED )

@end
