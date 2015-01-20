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
//  NewTweetBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/10.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface NewTweetBoard_iPhone : BeeUIBoard
AS_OUTLET(BeeUIImageView, title_face)

@property (nonatomic, retain) NSString* atSomebody;
@end
