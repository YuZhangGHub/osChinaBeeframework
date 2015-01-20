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
//  ActiveListModel.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/9.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee_StreamViewModel.h"

#pragma mark -

@interface ActiveListModel : BeeStreamViewModel
@property (nonatomic, retain) NSMutableArray * actives;
@property (nonatomic) int                      catalog;
@property (nonatomic) int                      pages;

@end