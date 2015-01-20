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
//  PostListModel.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/25.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee_StreamViewModel.h"
#import "oschina.h"

#pragma mark -

@interface PostListModel : BeeStreamViewModel
@property (nonatomic, retain) NSMutableArray * posts;
@property (nonatomic)         PostType         catalog;
@property (nonatomic)         int              pages;
@end