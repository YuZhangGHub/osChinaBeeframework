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
//  SearchListModel.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/26.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee_StreamViewModel.h"
#import "oschina.h"

#pragma mark -

@interface SearchListModel : BeeStreamViewModel
@property (nonatomic, retain) NSMutableArray * items;
@property (nonatomic)         SearchType       type;
@property (nonatomic)         int              pages;
@property (nonatomic, retain) NSString*        content;
@end