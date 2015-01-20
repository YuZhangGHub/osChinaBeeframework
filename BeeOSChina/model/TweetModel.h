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
//  TweetModel.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/28.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee_OnceViewModel.h"
#import "oschina.h"

#pragma mark -

@interface TweetModel : BeeOnceViewModel
@property (nonatomic, retain) TWEET *    tweet;
@property (nonatomic) int	             _id;
@property (nonatomic) int                commentCount;
@end