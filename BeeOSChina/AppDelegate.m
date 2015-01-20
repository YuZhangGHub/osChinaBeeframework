//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "AppDelegate.h"
#import "AppBoard_iPhone.h"
//#import "bee.services.share.weixin.h"
#import "bee.services.share.sinaweibo.h"
#import "bee.services.share.tencentweibo.h"

#pragma mark -

@implementation AppDelegate

- (void)load
{
  bee.ui.config.ASR = YES;
  bee.ui.config.iOS6Mode = YES;
    
  //[BeeUINavigationBar setBackgroundImage:[UIImage imageNamed:@"navigation-bar.png"]];
    [BeeUINavigationBar setButtonColor:[UIColor blackColor]];
    [BeeUINavigationBar setButtonFont:[UIFont systemFontOfSize:16.0]];
  
     //[UIFont systemFontOfSize:13.0f];
//	if ( [BeeSystemInfo isDevicePad] )
//	{
//		self.window.rootViewController = [AppBoard_iPad sharedInstance];
//	}
//	else
	{
		self.window.rootViewController = [AppBoard_iPhone sharedInstance];
	}
    
    [self updateConfig];
}

//- (void)load
//{
//[UIApplication sharedApplication].statusBarHidden = NO;
//
//    bee.ui.config.ASR = YES;
//    bee.ui.config.iOS7Mode = YES;
////	bee.ui.config.highPerformance = YES;
////	bee.ui.config.cacheAsyncLoad = YES;
////	bee.ui.config.cacheAsyncSave = YES;
//
//    if ( IOS7_OR_LATER )
//    {
//        [BeeUINavigationBar setTitleColor:[UIColor whiteColor]];
//        [BeeUINavigationBar setBackgroundImage:[UIImage imageNamed:@"navigation-bar-64.png"]];
//    }
//    else
//    {
//        [BeeUINavigationBar setTitleColor:[UIColor whiteColor]];
//    //		[BeeUINavigationBar setBackgroundColor:[UIColor blackColor]];
//    //		[BeeUINavigationBar setBackgroundTintColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.6f]];
//        [BeeUINavigationBar setBackgroundImage:[UIImage imageNamed:@"navigation-bar.png"]];
//    }
//
//    self.window.rootViewController = [BeeUIStack stackWithFirstBoardClass:[AppBoard_iPhone class]];
//}


- (void)unload
{
	
}

- (void)updateConfig
{
    //ALIAS( bee.services.share.weixin,		weixin );
    ALIAS( bee.services.share.tencentweibo,	tweibo );
    ALIAS( bee.services.share.sinaweibo,	sweibo );
    
    // 配置微信
//    weixin.config.appId			= @"<Your weixinID>";
//    weixin.config.appKey		= @"<Your weixinKey>";
    
    // 配置新浪
    sweibo.config.appKey		= @"<Your sinaWeiboKey>";
    sweibo.config.appSecret		= @"<Your sinaWeiboSecret>";
    sweibo.config.redirectURI	= @"<Your sinaWeiboCallback>";
    
    // 配置腾讯
    tweibo.config.appKey		= @"<Your tencentWeiboKey>";
    tweibo.config.appSecret		= @"<Your tencentWeiboSecret>";
    tweibo.config.redirectURI	= @"<Your tencentWeiboCallback>";
}

@end
