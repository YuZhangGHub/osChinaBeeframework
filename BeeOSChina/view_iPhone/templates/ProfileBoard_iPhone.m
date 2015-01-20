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
//  ProfileBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/23.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "ProfileBoard_iPhone.h"
#import "oschina.h"
#import "FavoriteBoard_iPhone.h"
#import "FriendListBoard_iPhone.h"

#pragma mark -

@interface ProfileBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation ProfileBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_MODEL( UserModel, userModel )
DEF_OUTLET( BeeUIImageView,	header_avatar )

DEF_SIGNAL( PHOTO_FROM_CAMERA )
DEF_SIGNAL( PHOTO_FROM_LIBRARY )

- (void)load
{
    self.userModel = [UserModel modelWithObserver:self];
    [self observeNotification:self.userModel.GET_PROFILE];
}

- (void)unload
{
    SAFE_RELEASE_MODEL( self.userModel );
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.navigationBarShown = YES;
    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    UIBarButtonItem *item = (UIBarButtonItem*)self.navigationBarLeft;
    item.title = @"更多";
    self.navigationBarTitle = @"我的资料";
    
    [self getProfile];
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    //[self updateUI];
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
}

ON_SIGNAL3( ProfileBoard_iPhone, carema_photo, signal )
{
    BeeUIActionSheet * confirm = [BeeUIActionSheet spawn];
    
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
    {
        [confirm addButtonTitle:@"相机" signal:self.PHOTO_FROM_CAMERA];
    }
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] )
    {
        [confirm addButtonTitle:@"图库" signal:self.PHOTO_FROM_LIBRARY];
    }
    
    [confirm addCancelTitle:@"取消"];
    [confirm showInViewController:self];
}

ON_SIGNAL3( ProfileBoard_iPhone, profile_favorites, signal )
{
    FavoriteBoard_iPhone * board = [FavoriteBoard_iPhone board];
    
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( ProfileBoard_iPhone, profile_fans, signal )
{
    FriendListBoard_iPhone * board = [FriendListBoard_iPhone board];
    board.relation = 0;
    
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( ProfileBoard_iPhone, profile_follows, signal )
{
    FriendListBoard_iPhone * board = [FriendListBoard_iPhone board];
    board.relation = 1;
    
    [self.stack pushBoard:board animated:YES];
}

ON_NOTIFICATION3( UserModel, GET_PROFILE, notification )
{
    [self updateUI];
}

- (void)getProfile
{
    [self.userModel getProfile];
}

- (void) updateUI
{
    USER* user = self.userModel.user;
    
    if(user == nil) return;
    
    $(@"label_favorite_count").TEXT([NSString stringWithFormat:@"(%d)", user.favorite_count.intValue]);
    $(@"label_fans_count").TEXT([NSString stringWithFormat:@"(%d)", user.fan_num.intValue]);
    $(@"label_follows_count").TEXT([NSString stringWithFormat:@"(%d)", user.follow_num.intValue]);
    
    $(@"#dev_platform").TEXT(user.devplatform);
    $(@"#dev_joindate").TEXT(user.joindate);
    $(@"#dev_location").TEXT(user.from);
    $(@"#dev_domain").TEXT(user.expertise);
    
    self.header_avatar.data = user.portrait;
}

#pragma mark - E0_ProfileBoard_iPhone

ON_SIGNAL3( ProfileBoard_iPhone, PHOTO_FROM_CAMERA, signal )
{
    //Take Photo with Camera
    @try
    {
        if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
        {
            UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
            [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
            [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
            [cameraVC setDelegate:self];
            [cameraVC setAllowsEditing:YES];
            [self presentModalViewController:cameraVC animated:YES];
            //[cameraVC release];
        }
        else
        {
            CC(@"Camera is not available.");
        }
    }
    @catch ( NSException * exception )
    {
        CC(@"Camera is not available.");
    }
}

ON_SIGNAL3( ProfileBoard_iPhone, PHOTO_FROM_LIBRARY, signal )
{
    //Show Photo Library
    @try
    {
        if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] )
        {
            UIImagePickerController *imgPickerVC = [[UIImagePickerController alloc] init];
            [imgPickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imgPickerVC.navigationBar setBarStyle:UIBarStyleBlack];
            [imgPickerVC setDelegate:self];
            [imgPickerVC setAllowsEditing:YES];
            [self presentModalViewController:imgPickerVC animated:YES];
            //[imgPickerVC release];
        }
        else
        {
            CC(@"Album is not available.");
        }
    }
    @catch ( NSException * exception )
    {
        //Error
        CC(@"Album is not available.");
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if ( image )
    {
        UIView * item = self.view;
        if ( nil == item )
            return;
        
        $(item).FIND(@"#header_avatar").IMAGE( image );
        
        [[UserModel sharedInstance] setAvatar:image];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
