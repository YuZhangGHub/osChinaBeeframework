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
//  FriendsListModel.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/9.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee_StreamViewModel.h"

#pragma mark -

@interface FriendsListModel : BeeStreamViewModel
@property (nonatomic, retain) NSMutableArray * friends;
@property (nonatomic) int                      relation;
@property (nonatomic) int                      pages;
@end