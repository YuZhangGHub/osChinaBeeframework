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
//  BlogCommentsModel.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/5.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee_StreamViewModel.h"

#pragma mark -

@interface BlogCommentsModel : BeeStreamViewModel
@property (nonatomic, retain) NSMutableArray * b_comments;
@property (nonatomic)         int              _id;
@property (nonatomic)         int              pages;
@end