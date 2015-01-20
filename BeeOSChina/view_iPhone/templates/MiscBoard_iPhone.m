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
//  MiscBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/25.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "MiscBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "MiscBoardCell_iPhone.h"
#import "UserModel.h"
#import "ProfileBoard_iPhone.h"
#import "SoftwareBoard_iPhone.h"

#pragma mark -

@interface MiscBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation MiscBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView,			list );

- (void)load
{
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0x8e8e93 );
    
    self.navigationBarShown = YES;
    self.navigationBarTitle = @"更多";
    self.navigationBarLeft = [UIImage imageNamed:@"menu-button.png"];
    
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;
    self.list.baseInsets = bee.ui.config.baseInsets;
    
    self.list.whenReloading = ^
    {
        self.list.total = 1;
        
        BeeUIScrollItem * item = self.list.items[0];
        item.clazz = [MiscBoardCell_iPhone class];
    };
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self.list reloadData];
    
    bee.ui.router.view.pannable = YES;
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
     bee.ui.router.view.pannable = NO;
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
     [[AppBoard_iPhone sharedInstance] showMenu];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

ON_SIGNAL3( MiscBoardCell_iPhone, button_account, signal )
{
    if([UserModel online] == YES)
    {
        [self.stack pushBoard:[ProfileBoard_iPhone board] animated:YES];
    } else {
        [bee.ui.appBoard showLogin];
    }
}

//ON_SIGNAL3( MiscBoardCell_iPhone, btn_scan, signal )
//{
//    //scan
//}

ON_SIGNAL3( MiscBoardCell_iPhone, btn_signout, signal )
{
    UserModel* um = [UserModel sharedInstance];
    
    if(um == nil) return;
    
    [um signout];
}

ON_SIGNAL3( MiscBoardCell_iPhone, btn_software, signal )
{
    //software
    [self.stack pushBoard:[SoftwareBoard_iPhone board] animated:YES];
}

ON_SIGNAL3( MiscBoardCell_iPhone, btn_weibo, signal )
{
    NSURL * url = [NSURL URLWithString:@"http://www.weibo.com/oschina2010"];
    [[UIApplication sharedApplication] openURL:url];
}

ON_SIGNAL3( MiscBoardCell_iPhone, btn_update, signal )
{
    [bee.ui.appBoard presentSuccessTips:@"您现在使用的是最新版本。"];
}

ON_SIGNAL3( MiscBoardCell_iPhone, btn_about, signal )
{
    //about
}


@end
