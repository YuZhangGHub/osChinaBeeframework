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
//  EditMessageBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/10.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "EditMessageBoard_iPhone.h"
#import "UserModel.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@interface EditMessageBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation EditMessageBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )
@synthesize receiverName = _receiverName;
@synthesize receiverId   = _receiverId;

- (void)load
{
    _receiverId = 0;
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0xdfdfdf );
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
    $(@"label_receiver").TEXT([NSString stringWithFormat:@"发给：%@", _receiverName]);
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
    
    NSString* msg = $(@"comment").text;
    
    if ([msg isEqualToString:@""]) {
        [bee.ui.appBoard presentSuccessTips:@"错误 留言内容不能为空!"];
        return;
    }
    if ([msg length]>250) {
        [bee.ui.appBoard presentSuccessTips:@"错误 留言内容不能超过250个字符"];
        return;
    }
    
    [API_MESSAGE_PUB cancel];
    
    API_MESSAGE_PUB * api = [API_MESSAGE_PUB apiWithResponder:self];
    
    int uid       = [UserModel sharedInstance].user.uid.intValue;
    
    api.INPUT( @"content", msg );
    api.INPUT( @"uid", [NSString stringWithFormat:@"%d", uid]);
    api.INPUT( @"receiver", [NSString stringWithFormat:@"%d", _receiverId]);
    
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
                    [bee.ui.appBoard presentSuccessTips:@"发送消息成功!"];
                    [self.stack popBoardAnimated:YES];
                }
                else
                {
                    [bee.ui.appBoard presentSuccessTips:@"发送消息失败!"];
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
