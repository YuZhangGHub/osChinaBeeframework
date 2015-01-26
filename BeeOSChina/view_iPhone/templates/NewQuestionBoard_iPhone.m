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
//  NewQuestionBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/11.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "NewQuestionBoard_iPhone.h"
#import "UserModel.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@interface NewQuestionBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation NewQuestionBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( QuestionBoardTab_iPhone, tabbar );
DEF_OUTLET( BeeUISwitch,	switch_email );
@synthesize catalog = _catalog;

- (void)load
{
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0xdfdfdf );
    self.navigationBarShown = YES;
    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.navigationBarRight = @"发送";
    _catalog = 1;
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [_switch_email setOn:YES animated:NO];
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

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
    UserModel* uModel = [UserModel sharedInstance];
    
    if(uModel == nil || uModel.user == nil || uModel.user.uid == nil)
    {
        return;
    }
    
    if([UserModel online] == NO)
    {
        [bee.ui.appBoard presentSuccessTips:@"请先登录!"];
    }
    
    [API_POST_PUB cancel];
    
    API_POST_PUB * api = [API_POST_PUB apiWithResponder:self];
    
    int uid       = [UserModel sharedInstance].user.uid.intValue;
    NSString* content = $(@"comment").text;
    NSString* title   = $(@"question_title").text;
    BOOL    noticeMe   = _switch_email.on;
    
    api.INPUT( @"content", content );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", uid]);
    api.INPUT( @"title", title );
    api.INPUT( @"catalog", [NSString stringWithFormat:@"%d", _catalog]);
    api.INPUT( @"noticeMe", [NSString stringWithFormat:@"%d", noticeMe] );
    
    @weakify( api );
    
    api.whenUpdate = ^
    {
        @normalize( api );
        
        if ( api.sending )
        {
        }
        else if ( api.succeed )
        {
            //            if ( ERROR_CODE_OK != api.resp.resultCode.intValue )
            //            {
            //                [self sendUISignal:self.RELOADED];
            //            }
            //            else
            {
                //Need not update list ui.
                RESULT* res = api.result;
                if(res.errorCode == 1)
                {
                    [bee.ui.appBoard presentSuccessTips:@"发送问答成功!"];
                    [self.stack popBoardAnimated:YES];
                }
                else
                {
                    [bee.ui.appBoard presentSuccessTips:@"发送问答失败!"];
                }
            }
        }
        else if ( api.failed )
        {
        }
        //    else if ( api.cancelled )
        //    {
        //      [self sendUISignal:self.RELOADED];
        //    }
    };
    
    [api send];

}

ON_SIGNAL3( QuestionBoardTab_iPhone, question, signal )
{
    [self.tabbar selectQuestion];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    _catalog = Question;
}

ON_SIGNAL3( QuestionBoardTab_iPhone, sharing, signal )
{
    [self.tabbar selectSharing];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    _catalog = Sharing;
}

ON_SIGNAL3( QuestionBoardTab_iPhone, synthesis, signal )
{
    [self.tabbar selectSynthesis];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    _catalog = Synthesize;
}

ON_SIGNAL3( QuestionBoardTab_iPhone, career, signal )
{
    [self.tabbar selectCareer];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    _catalog = Carrer;
}

ON_SIGNAL3( QuestionBoardTab_iPhone, site, signal )
{
    [self.tabbar selectSite];
    
    //_selectedIndex = -1;
    
    [self transitionFade];
    _catalog = Site;
}


@end
