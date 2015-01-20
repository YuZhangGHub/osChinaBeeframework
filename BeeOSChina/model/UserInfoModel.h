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
//  UserInfoModel.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/9.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee_StreamViewModel.h"
#import "oschina.h"

#pragma mark -

@interface UserInfoModel : BeeStreamViewModel
@property (nonatomic, retain) USER_INFO *      user;
@property (nonatomic) int                      hisuid;
@property (nonatomic) NSString*                hisname;
@property (nonatomic) int                      pages;
@end