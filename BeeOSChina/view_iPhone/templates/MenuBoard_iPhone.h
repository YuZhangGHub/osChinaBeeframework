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
//  MenuBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/22.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface MenuBoard_iPhone : BeeUIBoard

AS_SINGLETON( MenuBoard_iPhone )

- (void)selectItem:(NSString *)item animated:(BOOL)animated;

@end
