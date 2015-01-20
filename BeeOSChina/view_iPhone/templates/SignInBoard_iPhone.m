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
//  SignInBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/20.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "SignInBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "UIViewController+ErrorTips.h"

#pragma mark -

@interface SignInBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation SignInBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_MODEL( UserModel, userModel )

- (void)load
{
    self.userModel = [UserModel modelWithObserver:self];
}

- (void)unload
{
    SAFE_RELEASE_MODEL( self.userModel );
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor =  HEX_RGB( 0x24b5ed );
    self.navigationBarTitle = @"用户登陆";
    //	[self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];
    [self showBarButton:BeeUINavigationBar.LEFT title:@"取消" image:[[UIImage imageNamed:@"nav_right.png"] stretched]];
    [self showBarButton:BeeUINavigationBar.RIGHT title:@"登陆" image:[[UIImage imageNamed:@"nav_right.png"] stretched]];
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self showNavigationBarAnimated:NO];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
    [[AppBoard_iPhone sharedInstance] hideLogin];
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
    [self doLogin];
}

#pragma mark - BeeUITextField

ON_SIGNAL3( BeeUITextField, RETURN, signal )
{
    if ( $(@"username").focusing )
    {
        $(@"password").FOCUS();
        return;
    }
    else
    {
        [self doLogin];
    }
    
    [self.view endEditing:YES];
}

#pragma mark - SigninBoard_iPhone

- (void)doLogin
{
    NSString * userName = $(@"username").text.trim;
    NSString * password = $(@"password").text.trim;
    
    //	if ( 0 == userName.length || NO == [userName isChineseUserName] )
    //	{
    //		[self presentMessageTips:__TEXT(@"wrong_username")];
    //		return;
    //	}
    
    if ( userName.length < 2 )
    {
        [self presentMessageTips:@"用户名长度太短。"];
        return;
    }
    
    if ( userName.length > 20 )
    {
        [self presentMessageTips:@"用户名长度太长。"];
        return;
    }
    
    if ( 0 == password.length || NO == [password isPassword] )
    {
        [self presentMessageTips:@"密码格式不正确。"];
        return;
    }
    
    //	if ( password.length < 6 )
    //	{
    //		[self presentMessageTips:__TEXT(@"password_too_short")];
    //		return;
    //	}
    //
    //	if ( password.length > 20 )
    //	{
    //		[self presentMessageTips:__TEXT(@"password_too_long")];
    //		return;
    //	}
    
    [self.userModel signinWithUser:userName password:password];
}

#pragma mark -

ON_SIGNAL3( UserModel, RELOADED, signal )
{
    [bee.ui.appBoard presentSuccessTips:@"欢迎回来!"];
    
    [bee.ui.appBoard hideLogin];
}

ON_SIGNAL3( UserModel, RELOADING, signal )
{
    [self presentLoadingTips:@"正在登陆..."];
}

ON_SIGNAL3( UserModel, FAILED, signal )
{
    BeeMessage* msg = signal.object;
    [self showErrorTips:msg];
}

ON_SIGNAL3( SignInBoard_iPhone, btn_singup, signal )
{
    NSURL * url = [NSURL URLWithString:@"http://www.oschina.net"];
    [[UIApplication sharedApplication] openURL:url];
}

ON_SIGNAL3( SignInBoard_iPhone, btn_login_more, signal )
{
    NSURL * url = [NSURL URLWithString:@"http://www.oschina.net/question/12_52232"];
    [[UIApplication sharedApplication] openURL:url];
}

@end
