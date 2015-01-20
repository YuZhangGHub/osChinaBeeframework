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
//  NewsListModel.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/5.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee_StreamViewModel.h"

#pragma mark -

@interface NewsListModel : BeeStreamViewModel
@property (nonatomic, retain) NSMutableArray * news;
@end