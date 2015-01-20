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
//  BlogListModel.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/25.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee_StreamViewModel.h"
#import "oschina.h"

#pragma mark -

@interface BlogListModel : BeeStreamViewModel
@property (nonatomic, retain) NSMutableArray * blogs;
@property (nonatomic)         NewsType         type;
@property (nonatomic)         int              pages;
@end