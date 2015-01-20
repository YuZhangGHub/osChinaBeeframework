//
//  URLHandler.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/31.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "URLHandler.h"
#import "DetailArticleBoard_iPhone.h"
#import "DetailBlogBoard_iPhone.h"
#import "DetailQuestionBoard_iPhone.h"
#import "DetailTweetBoard_iPhone.h"
#import "SoftwareDetailBoard_iPhone.h"
#import "QuestionBoard_iPhone.h"
#import "UserDetailBoard_iPhone.h"
#import "oschina.h"
#import "Tool.h"

@implementation URLHandler

+(BOOL) handleURL : (NSString*) url parentBoard: (BeeUIBoard*) parent
{
    if(parent == nil)
    {
        return NO;
    }
    
    NSString *search = @"oschina.net";
    //判断是否包含 oschina.net 来确定是不是站内链接
    NSRange rng = [url rangeOfString:search];
    if (rng.length <= 0) {
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return NO;
    }
    
    URL_ITEM* urlItem     = [Tool resolveUrl:url];
    
    switch (urlItem.type)
    {
        case NewsDetail:
        {
            DetailArticleBoard_iPhone* board = [DetailArticleBoard_iPhone board];
            board.articleModel.article_id = urlItem.attachment.intValue;
            
            [parent.stack pushBoard:board animated:YES];
            break;
        }
        case BlogDetail:
        {
            DetailBlogBoard_iPhone* board = [DetailBlogBoard_iPhone board];
            board.articleModel._id = urlItem.attachment.intValue;
            
            [parent.stack pushBoard:board animated:YES];
            break;
        }
        case TweetDetail:
        {
            DetailTweetBoard_iPhone* board = [DetailTweetBoard_iPhone board];
            board.tweetModel._id = urlItem.attachment.intValue;
            
            [parent.stack pushBoard:board animated:YES];
            break;
        }
        case QuestionDetail:
        {
            DetailQuestionBoard_iPhone* board = [DetailQuestionBoard_iPhone board];
            board.articleModel._id = urlItem.attachment.intValue;
            
            [parent.stack pushBoard:board animated:YES];
            break;
        }
        case SoftwareDetail:
        {
            SoftwareDetailBoard_iPhone* board = [SoftwareDetailBoard_iPhone board];
            board.detailSoftwareModel.softwareName = urlItem.attachment;
            
            [parent.stack pushBoard:board animated:YES];
            break;
        }
        case PostList:
        {
            QuestionBoard_iPhone* board = [QuestionBoard_iPhone board];
            board.postModel.catalog = urlItem.attachment.intValue;
            
            [parent.stack pushBoard:board animated:YES];
            break;
        }
        case UserDetail:
        {
            UserDetailBoard_iPhone* board = [UserDetailBoard_iPhone board];
            
            if(urlItem.reserved) //by name
            {
                board.userInfo.hisuid      = 0;
                board.userBlogs.authorid   = 0;
                board.userInfo.hisname     = urlItem.attachment;
                board.userBlogs.authorname = urlItem.attachment;
            }
            else{
                board.userInfo.hisuid      = urlItem.attachment.intValue;
                board.userBlogs.authorid   = urlItem.attachment.intValue;
            }
            
            [parent.stack pushBoard:board animated:YES];
            
            break;
        }
        case WebLink:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", url]]];
            break;
        }
        default:
            break;
    }
    
    return NO;
}
@end
