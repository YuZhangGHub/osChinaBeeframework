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
//  AppBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/21.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"

AS_UI( AppBoard_iPhone, appBoard )

@interface AppBoard_iPhone : BeeUIBoard

AS_SINGLETON( AppBoard_iPhone )
AS_NOTIFICATION(NOTICE_UPDATE)

@property (nonatomic, retain) dispatch_source_t timer;

- (void)showMenu;
- (void)hideMenu;

- (void)showLogin;
- (void)hideLogin;

- (void)startNoticeUpdate;

@end
