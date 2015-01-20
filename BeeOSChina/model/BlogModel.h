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
//  BlogModel.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/26.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee_OnceViewModel.h"
#import "oschina.h"

#pragma mark -

@interface BlogModel : BeeOnceViewModel
@property (nonatomic, retain) BLOG *	    blog;
@property (nonatomic) int	                _id;
@end