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
//  NewTweetBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/10.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "NewTweetBoard_iPhone.h"
#import "oschina.h"
#import "UserModel.h"
#import "Bee.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@interface NewTweetBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation NewTweetBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET(BeeUIImageView, title_face)

@synthesize atSomebody = _atSomebody;

- (void)load
{
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0xebebf3 );
    self.navigationBarShown = YES;
    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.navigationBarRight = @"发送";
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    if(_atSomebody != nil && [_atSomebody length] > 0)
    {
        $(@"comment").TEXT(_atSomebody);
    }
    
    $(@"label_image").HIDE();
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
       
    [API_TWEET_PUB cancel];
    
    API_TWEET_PUB * api = [API_TWEET_PUB apiWithResponder:self];
    
    int uid       = [UserModel sharedInstance].user.uid.intValue;
    NSString* msg = $(@"comment").text;
    
    api.INPUT( @"msg", msg );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", uid]);
    
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
                    [bee.ui.appBoard presentSuccessTips:@"发送动弹成功!"];
                    [self.stack popBoardAnimated:YES];
                }
                else
                {
                    [bee.ui.appBoard presentSuccessTips:@"发送动弹失败!"];
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

@end
