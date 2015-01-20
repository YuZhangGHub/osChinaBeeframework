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
//  UserModel.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/19.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee_OnceViewModel.h"
#import "oschina.h"

#pragma mark -

@interface UserModel : BeeOnceViewModel

AS_SINGLETON( UserModel )

//@property (nonatomic, retain) SESSION *	session;
@property (nonatomic, retain) UIImage *	avatar;
@property (nonatomic, retain) USER *	user;

AS_NOTIFICATION( LOGIN )
AS_NOTIFICATION( LOGOUT )
AS_NOTIFICATION( GET_PROFILE )
AS_NOTIFICATION( UPDATED )

+ (BOOL)online;

- (void)setOnline:(BOOL)flag;
- (void)setOffline:(BOOL)flag;

- (void)signinWithUser:(NSString *)user
              password:(NSString *)password;

- (void)signout;

- (void)getProfile;

- (void)updateProfile;

@end