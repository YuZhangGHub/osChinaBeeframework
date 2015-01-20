//
//  ShareRoutine.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/29.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareRoutine : NSObject

-(void) shareToSinaWeibo : (NSString*) url;
-(void) shareToTencentWeibo : (NSString*) url;
-(void) shareToWechat : (NSString*) url :(NSString*) title;
-(void) shareToWechatCircle : (NSString*) url :(NSString*) title;

@end
