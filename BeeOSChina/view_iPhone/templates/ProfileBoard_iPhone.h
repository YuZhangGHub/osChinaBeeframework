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
//  ProfileBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/23.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "UserModel.h"

#pragma mark -

@interface ProfileBoard_iPhone : BeeUIBoard<UIImagePickerControllerDelegate>

AS_SIGNAL( PHOTO_FROM_CAMERA )
AS_SIGNAL( PHOTO_FROM_LIBRARY )

AS_MODEL( UserModel, userModel )
AS_OUTLET( BeeUIImageView,	header_avatar )

@end
