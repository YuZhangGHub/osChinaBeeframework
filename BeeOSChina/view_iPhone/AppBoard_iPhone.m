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
//  AppBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/10/21.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "AppBoard_iPhone.h"
#import "MenuBoard_iPhone.h"
#import "NewsBoard_iPhone.h"
#import "QuestionBoard_iPhone.h"
#import "TweetBoard_iPhone.h"
#import "PersonalBoard_iPhone.h"
#import "MiscBoard_iPhone.h"
#import "SignInBoard_iPhone.h"
#import "NoticeRoutine.h"

#pragma mark -

#undef	MENU_BOUNDS
#define	MENU_BOUNDS	(80.0f)

#pragma mark -

DEF_UI( AppBoard_iPhone, appBoard )

#pragma mark -

@implementation AppBoard_iPhone
{
    MenuBoard_iPhone *	_menu;
    BeeUIRouter *		_router;
    BeeUIButton *		_mask;
    UIWindow *			_splash;
    CGRect				_origFrame;
}

DEF_SINGLETON( AppBoard_iPhone )

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

DEF_NOTIFICATION(NOTICE_UPDATE)

@synthesize timer = _timer;

- (void)load
{
    [self startNoticeUpdate];
}

- (void)unload
{
    dispatch_suspend(_timer);
    _timer = nil;
}

#pragma mark Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _menu = [MenuBoard_iPhone sharedInstance];
    _menu.parentBoard = self;
    _menu.view.backgroundColor = RGB(15, 15, 15);
    _menu.view.hidden = YES;
    [self.view addSubview:_menu.view];
    
    _router = [BeeUIRouter sharedInstance];
    _router.parentBoard = self;
    _router.view.alpha = 0.0f;
    [_router map:@"news" toClass:[NewsBoard_iPhone class]];
    [_router map:@"question" toClass:[QuestionBoard_iPhone class]];
    [_router map:@"tweet" toClass:[TweetBoard_iPhone class]];
    [_router map:@"personal" toClass:[PersonalBoard_iPhone class]];
    [_router map:@"misc" toClass:[MiscBoard_iPhone class]];
    [self.view addSubview:_router.view];
    
    _mask = [BeeUIButton new];
    _mask.hidden = YES;
    _mask.signal = @"mask";
    [self.view addSubview:_mask];
    
    //_menu.view.frame = self.bounds;
    //_router.view.frame = self.bounds;
//    
    _router.view.backgroundColor = [UIColor blackColor];
    _router.view.alpha = 0.0f;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ready)];
    
    _router.view.backgroundColor = [UIColor whiteColor];
    _router.view.alpha = 1.0f;
    
    [UIView commitAnimations];
    
    [_router open:@"news" animated:NO];
}

ON_DELETE_VIEWS( signal )
{
    _menu = nil;
    _router = nil;
    _mask = nil;
    
    [self unobserveAllNotifications];
}

ON_SIGNAL2( UIView, signal )
{
    if ( [signal is:UIView.PAN_START]  )
    {
        _origFrame = _router.view.frame;
        
        [self syncPanPosition];
    }
    else if ( [signal is:UIView.PAN_CHANGED]  )
    {
        [self syncPanPosition];
    }
    else if ( [signal is:UIView.PAN_STOP] || [signal is:UIView.PAN_CANCELLED] )
    {
        [self syncPanPosition];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3f];
        
        CGFloat left = _router.view.left;
        CGFloat edge = MENU_BOUNDS;
        
        if ( left <= edge )
        {
            _router.view.left = 0;
            
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(didMenuHidden)];
        }
        else
        {
            _router.view.left = 62.0f;
            
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(didMenuShown)];
        }
        
        [UIView commitAnimations];
    }
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
}

ON_DID_APPEAR( signal )
{
    _router.view.pannable = YES;
}

ON_WILL_DISAPPEAR( signal )
{
    _router.view.pannable = NO;
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL2( mask, signal )
{
    [self hideMenu];
}

ON_SIGNAL3( BeeUIRouter, WILL_CHANGE, signal )
{
}

ON_SIGNAL3( BeeUIRouter, DID_CHANGED, signal )
{
    [_menu selectItem:_router.currentStack.name animated:YES];
}

ON_SIGNAL3( MenuBoard_iPhone, news, signal )
{
    [_router open:@"news" animated:YES];
    
    [self hideMenu];
}

ON_SIGNAL3( MenuBoard_iPhone, question, signal )
{
    [_router open:@"question" animated:YES];
    
    [self hideMenu];
}

ON_SIGNAL3( MenuBoard_iPhone, tweet, signal )
{
    [_router open:@"tweet" animated:YES];
    
    [self hideMenu];
}

ON_SIGNAL3( MenuBoard_iPhone, personal, signal )
{
    [_router open:@"personal" animated:YES];
    
    [self hideMenu];
}

ON_SIGNAL3( MenuBoard_iPhone, misc, signal )
{
    [_router open:@"misc" animated:YES];
    
    [self hideMenu];
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

- (void)didMenuHidden
{
    _mask.hidden = YES;
}

- (void)didMenuShown
{
    _mask.frame = CGRectMake( 60, 0.0, _router.bounds.size.width - 60.0f, _router.bounds.size.height );
    _mask.hidden = NO;
}

- (void)syncPanPosition
{
    _router.view.frame = CGRectOffset( _origFrame, _router.view.panOffset.x, 0 );
}

- (void)showMenu
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didMenuShown)];
    
    _router.view.left = 62.0f;
    
    [UIView commitAnimations];
}

- (void)hideMenu
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didMenuHidden)];
    
    _router.view.left = 0.0f;
    
    [UIView commitAnimations];
}

- (void)showLogin
{
    if ( self.modalStack )
    {
        return;
    }
    
    [self presentModalStack:[BeeUIStack stackWithFirstBoard:[SignInBoard_iPhone board]] animated:YES];
}

- (void)hideLogin
{
    if ( nil == self.modalStack )
    {
        return;
    }
    
    [self dismissModalStackAnimated:YES];
}

- (void)ready
{
    _menu.view.hidden = NO;
    
    [self showMenu];
}

- (void)startNoticeUpdate
{    
    //间隔还是120秒
    
    uint64_t interval = 120 * NSEC_PER_SEC;
    
    //创建一个专门执行timer回调的GCD队列
    
    dispatch_queue_t queue = dispatch_queue_create("notice queue", 0);
    
    //创建Timer
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //使用dispatch_source_set_timer函数设置timer参数
    
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
    
    //设置回调
    
    dispatch_source_set_event_handler(_timer, ^()
                                      
    {
        NSLog(@"Update notice");
        [self postNotification:self.NOTICE_UPDATE];
    });
    
    //dispatch_source默认是Suspended状态，通过dispatch_resume函数开始它
    dispatch_resume(_timer);
}

@end
