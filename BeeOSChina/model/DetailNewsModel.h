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
//  DetailNewsModel.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/13.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee_OnceViewModel.h"

#pragma mark -

@interface DetailNewsModel : BeeOnceViewModel
@property (nonatomic)         int	            article_id;
@property (nonatomic, retain) NSString *	    article_title;
@property (nonatomic, retain) NSString *	    html;
@property (nonatomic, retain) NSString *        url;
@property (nonatomic)         int        	    comment_count;
@property (nonatomic, retain) NSString *	    author;
@property (nonatomic, retain) NSString *	    pub_date;
@property (nonatomic)         int               author_id;
@property (retain,nonatomic)  NSMutableArray *  relativies;
@property (retain,nonatomic)  NSString *        softwarelink;
@property (retain,nonatomic)  NSString *        softwarename;
@property BOOL                                  favorite;
@end