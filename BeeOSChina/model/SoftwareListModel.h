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
//  SoftwareListModel.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/24.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee_StreamViewModel.h"
#import "oschina.h"

#pragma mark -

@interface SoftwareListModel : BeeStreamViewModel
@property (nonatomic, retain) NSMutableArray * softwares;
@property (nonatomic, retain) NSString*	       searchTag;
@property (nonatomic)         int              pages;
@end