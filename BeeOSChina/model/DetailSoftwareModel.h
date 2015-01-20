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
//  DetailSoftwareModel.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/24.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee_OnceViewModel.h"
#import "oschina.h"

#pragma mark -

@interface DetailSoftwareModel : BeeOnceViewModel
@property (nonatomic, retain) SOFTWARE *	software;
@property (nonatomic, retain) NSString *	softwareName;
@end