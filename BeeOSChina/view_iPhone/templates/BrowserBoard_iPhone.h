//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  BrowserBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/13.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface BrowserBoard_iPhone : BeeUIBoard<UIWebViewDelegate>

AS_SINGLETON( BrowserBoard_iPhone )

@property (nonatomic, assign) BOOL				showLoading;
@property (nonatomic, assign) BOOL				useHTMLTitle;
@property (nonatomic, copy)NSString*            URLJudge;
@property (nonatomic, retain) UIToolbar *		toolbar;
@property (nonatomic, retain) BeeUIWebView *	webView;
@property (nonatomic, copy) NSString *			urlString;
@property (nonatomic, copy) NSString *          htmlString;
@property (nonatomic, copy) NSString *			defaultTitle;
@property (nonatomic, copy) NSString *          payString;

@property (nonatomic, assign) BOOL              isToolbarHiden;

@property (nonatomic, assign) id				backBoard;

- (void)refresh;

@end
