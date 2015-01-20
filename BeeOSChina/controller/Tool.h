//
//  Tool.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/12.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "oschina.h"

@interface Tool : NSObject

+ (NSString *)intervalSinceNow: (NSString *) theDate;
+ (NSString *)generateRelativeNewsString:(NSArray *)array;
+ (NSString *)GenerateTags:(NSMutableArray *)tags;
+ (NSString *)getAppClientString:(int)appClient;
+ (NSString *)MyRegularExpressions:(NSString *)url;
+ (URL_ITEM *)resolveUrl: (NSString *) url;
+ (NSString *)getTextViewString2:(NSString *)author andObjectType:(int)objectType andObjectCatalog:(int)objectCatalog andObjectTitle:(NSString *)title andMessage:(NSString *)message andPubDate:(NSString *)pubDate;
+(int)getTextViewHeight:(UITextView *)txtView andUIFont:(UIFont *)font andText:(NSString *)txt;
+ (NSString*)getHtmlStyleString;


@end
