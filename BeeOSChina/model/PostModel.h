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
//  PostModel.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/25.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee_OnceViewModel.h"
#import "oschina.h"

#pragma mark -

@interface PostModel : BeeOnceViewModel
@property (nonatomic, retain) POST *	    post;
@property (nonatomic) int	                _id;
@end