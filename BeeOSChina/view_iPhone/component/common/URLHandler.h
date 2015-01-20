//
//  URLHandler.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/31.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLHandler : NSObject
+(BOOL) handleURL : (NSString*) url parentBoard: (BeeUIBoard*) parent;
@end
