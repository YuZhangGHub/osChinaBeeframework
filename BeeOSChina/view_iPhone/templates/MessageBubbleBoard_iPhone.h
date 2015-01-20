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
//  MessageBubbleBoard_iPhone.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/22.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"
#import "CommentsModel.h"

#pragma mark -

@interface MessageBubbleBoard_iPhone : BeeUIBoard<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isLoading;
    BOOL isLoadOver;
    int  uid;
}

@property (strong, nonatomic) IBOutlet UITableView* tableBubbles;
@property (nonatomic) int                           friendID;
@property (copy,nonatomic) NSString *               friendName;

AS_MODEL(CommentsModel, commentsModel)

@end
