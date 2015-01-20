//
//	Powered by BeeFramework
//
//
//  MessageBubbleBoard_iPhone.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/22.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "MessageBubbleBoard_iPhone.h"
#import "EditMessageBoard_iPhone.h"
#import "oschina.h"
#import "Tool.h"
#import "ChatPopView.h"
#import "UserModel.h"

#pragma mark -

@interface MessageBubbleBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation MessageBubbleBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_MODEL(CommentsModel, commentsModel)

@synthesize tableBubbles = _tableBubbles;
@synthesize friendID     = _friendID;
@synthesize friendName   = _friendName;

- (void)load
{
    self.commentsModel = [CommentsModel modelWithObserver:self];
    self.commentsModel.catalog = 4;
    isLoading  = NO;
    isLoadOver = NO;
    uid        = 0;
}

- (void)unload
{
    [self.commentsModel removeAllObservers];
    self.commentsModel = nil;
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.navigationBarShown = YES;
    self.navigationBarTitle = self.friendName;
    
    self.tableBubbles = [[UITableView alloc] init];
    [self.tableBubbles setDataSource:self];
    [self.tableBubbles setDelegate:self];
    
    CGRect frame   = self.frame;
    frame.origin.y = -35;
    self.tableBubbles = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    [self.tableBubbles setDelegate:self];
    [self.tableBubbles setDataSource:self];
    [self.tableBubbles setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [[self view] addSubview:self.tableBubbles];
    
    self.tableBubbles.separatorStyle = UITableViewCellSeparatorStyleNone;
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    bee.ui.router.view.pannable = NO;
    
    self.commentsModel._id = _friendID;
    [self.commentsModel firstPage];
    
    uid = [UserModel sharedInstance].user.uid.intValue;
}

ON_DID_APPEAR( signal )
{
    bee.ui.router.view.pannable = NO;
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL3( CommentsModel, RELOADING, signal )
{
//    self.list.headerLoading = self.messageModel.loaded;
//    self.list.footerLoading = YES;
}

ON_SIGNAL3( CommentsModel, RELOADED, signal )
{
//    self.list.headerLoading = NO;
//    self.list.footerLoading = NO;
//    self.list.footerMore = self.messageModel.more;
//    
//    //	[self transitionFade];
    
    [self.tableBubbles reloadData];
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
    EditMessageBoard_iPhone* board = [EditMessageBoard_iPhone board];
    board.receiverId               = _friendID;
    board.receiverName             = _friendName;
    
    [self.stack pushBoard:board animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isLoadOver) {
        return self.commentsModel.comments.count == 0 ? 1 :self.commentsModel.comments.count;
    }
    else
        return self.commentsModel.comments.count + 1;
}

//In 64bit, float will fail and here it will return 0, need use CGFloat
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.row;
    if (index < self.commentsModel.comments.count) {
        COMMENT *m = (COMMENT *)[self.commentsModel.comments objectAtIndex:index];
        int height = 0;
        UITextView *txt = [[UITextView alloc] initWithFrame:CGRectMake(170, 474, 260, 922)];
        height = [Tool getTextViewHeight:txt andUIFont:[UIFont fontWithName:@"arial" size:14.0] andText:m.content];
        if (m.replies && [m.replies count] > 0 ) {
            height += 13+19+[m.replies count]*35;
        }
        else
        {
            height += 13;
        }
        return height + 8;
    }
    else
        return 600; //occupy all the white spaces
}

#define NormalCellIdentifier @"NormalCellIdentifier"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    //如果有数据
    if (self.commentsModel.comments.count > 0) {
        if (indexPath.row < self.commentsModel.comments.count)
        {
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NormalCellIdentifier];
            COMMENT *c = [self.commentsModel.comments objectAtIndex:indexPath.row];
            UILabel * lblTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
            lblTime.font = [UIFont boldSystemFontOfSize:12.0];
            lblTime.textColor = [UIColor lightGrayColor];
            lblTime.textAlignment = UITextAlignmentCenter;
            lblTime.backgroundColor = [UIColor clearColor];
            lblTime.text = [Tool intervalSinceNow:c.pubDate];
            [cell.contentView addSubview:lblTime];
            ChatPopView *p;
            if (c.authorid.intValue == uid) {
                //                p = [[ChatPopView alloc] initWithFrame:CGRectMake(58, 23, 250, 80) popDirection:ePopDirectionRight];
                float origin = 58;
                
                UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 250-15, 80)];
                l.font = [UIFont fontWithName:@"Arial" size:14];
                l.numberOfLines = 0;
                l.text = c.content;
                [l sizeToFit];
                
                if (l.frame.size.width < 220) {
                    origin = 58 + (220 - l.frame.size.width);
                }
                
                CGRect rect = l.frame;
                p = [[ChatPopView alloc] initWithFrame:CGRectMake(origin, 23, 250, 80) popDirection:ePopDirectionRight];
            }
            else
            {
                p = [[ChatPopView alloc] initWithFrame:CGRectMake(2, 23, 250, 80) popDirection:ePopDirectionLeft];
            }
            [p setText:c.content];

            [cell.contentView addSubview:p];
            return  cell;
        }
        else
        {
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NormalCellIdentifier];
            return cell;
        }
    }
    //如果没有数据
    else
    {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NormalCellIdentifier];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = [indexPath row];
    if (row >= self.commentsModel.comments.count)
    {
        [self.commentsModel firstPage];
    }
}

@end
