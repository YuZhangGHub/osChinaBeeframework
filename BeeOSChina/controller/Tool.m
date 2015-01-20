//
//  Tool.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/12.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Tool.h"
#import "oschina.h"

@implementation Tool

+ (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        if (cha/60<1) {
            timeString = @"1";
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
        }
        
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    else if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    else if (cha/86400>1&&cha/864000<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    else
    {
        //        timeString = [NSString stringWithFormat:@"%d-%"]
        NSArray *array = [theDate componentsSeparatedByString:@" "];
        //        return [array objectAtIndex:0];
        timeString = [array objectAtIndex:0];
    }
    return timeString;
}

+ (NSString *)generateRelativeNewsString:(NSArray *)array
{
    if (array == nil || [array count] == 0) {
        return @"";
    }
    NSString *middle = @"";
    for (RELATIVE_NEWS *r in array) {
        middle = [NSString stringWithFormat:@"%@<a href=%@ style='text-decoration:none'>%@</a><p/>",middle, r.url, r.title];
    }
    return [NSString stringWithFormat:@"<hr/>相关文章<div style='font-size:14px'><p/>%@</div>", middle];
}

+ (NSString *)GenerateTags:(NSMutableArray *)tags
{
    if (tags == nil || tags.count == 0) {
        return @"";
    }
    else
    {
        NSString *result = @"";
        for (NSString *t in tags) {
            result = [NSString stringWithFormat:@"%@<a style='background-color: #BBD6F3;border-bottom: 1px solid #3E6D8E;border-right: 1px solid #7F9FB6;color: #284A7B;font-size: 12pt;-webkit-text-size-adjust: none;line-height: 2.4;margin: 2px 2px 2px 0;padding: 2px 4px;text-decoration: none;white-space: nowrap;' href='http://www.oschina.net/question/tag/%@' >&nbsp;%@&nbsp;</a>&nbsp;&nbsp;",result,t,t];
        }
        return result;
    }
}

+ (NSString *)getAppClientString:(int)appClient
{
    switch (appClient) {
        case 1:
            return @"";
        case 2:
            return @"来自手机";
        case 3:
            return @"来自Android";
        case 4:
            return @"来自iPhone";
        case 5:
            return @"来自Windows Phone";
        case 6:
            return @"来自微信";
        default:
            return @"";
    }
}

+ (NSString *)MyRegularExpressions:(NSString *)url
{
    //remove <script></script> from comment content
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<script[^>]*?>.*?</script>" options:0 error:&error];
    NSString *lowercaseString = [url lowercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *modifedContent = [regex stringByReplacingMatchesInString:lowercaseString options:0 range:NSMakeRange(0,[lowercaseString length]) withTemplate:@""];
    
    NSString *finalUrl = nil;
    
    if (modifedContent.length < lowercaseString.length)
    {
        finalUrl = modifedContent;
    }else
    {
        finalUrl = url;
    }
    return finalUrl;
}

+ (URL_ITEM *)resolveUrl: (NSString *) url
{
    URL_ITEM* url_item = [[URL_ITEM alloc] init];
    
    url_item.type       = WebLink;
    url_item.attachment = nil;
    url_item.reserved   = 0;
    
    NSString *search = @"oschina.net";
    //判断是否包含 oschina.net 来确定是不是站内链接
    NSRange rng = [url rangeOfString:search];
    if (rng.length <= 0) {
        return url_item;
    }
    //站内链接
    else
    {
        url = [url substringFromIndex:7];
        NSString *prefix = [url substringToIndex:3];
        //此情况为 博客,动弹,个人专页
        if ([prefix isEqualToString:@"my."])
        {
            NSArray *array = [url componentsSeparatedByString:@"/"];
            //个人专页 用户名形式
            if ([array count] <= 2) {
                url_item.type = UserDetail;
                url_item.attachment = [array objectAtIndex:1];
                url_item.reserved   = 1;
               
                return url_item;
            }
            //个人专页 uid形式
            else if([array count] <= 3)
            {
                if ([[array objectAtIndex:1] isEqualToString:@"u"]) {
                    url_item.type = UserDetail;
                    url_item.attachment = [array objectAtIndex:2];
                    url_item.reserved   = 0;
                    
                    return url_item;
                }
            }
            else if([array count] <= 4)
            {
                NSString *type = [array objectAtIndex:2];
                if ([type isEqualToString:@"blog"]) {
                    url_item.type       = BlogDetail;
                    url_item.attachment = [array objectAtIndex:3];

                    return url_item;
                }
                else if([type isEqualToString:@"tweet"]){
                    url_item.type       = TweetDetail;
                    url_item.attachment = [array objectAtIndex:3];

                    return url_item;
                }
            }
            else if(array.count <= 5)
            {
                NSString *type = [array objectAtIndex:3];
                if ([type isEqualToString:@"blog"]) {
                    url_item.type       = BlogDetail;
                    url_item.attachment = [array objectAtIndex:4];
                    
                    return url_item;
                }
            }
        }
        //此情况为 新闻,软件,问答
        else if([prefix isEqualToString:@"www"])
        {
            NSArray *array = [url componentsSeparatedByString:@"/"];
            int count = [array count];
            if (count>=3) {
                NSString *type = [array objectAtIndex:1];
                if ([type isEqualToString:@"news"]) {
                    
                    url_item.type = NewsDetail;
                    url_item.attachment = [array objectAtIndex:2] ;

                    return url_item;
                }
                else if([type isEqualToString:@"p"]){
                    
                    url_item.type = SoftwareDetail;
                    url_item.attachment = [array objectAtIndex:2] ;
                    
                    return url_item;
                }
                else if([type isEqualToString:@"question"]){
                    if (count == 3) {
                        NSArray *array2 = [[array objectAtIndex:2] componentsSeparatedByString:@"_"];
                        if ([array2 count] >= 2) {
                            url_item.type = QuestionDetail;
                            url_item.attachment = [array objectAtIndex:1] ;
                            
                            return url_item;
                        }
                    }
                    else if(count >= 4)
                    {
                        //                        NSString *tag = [array objectAtIndex:3];
                        NSString *tag = @"";
                        if (array.count == 4) {
                            tag = [array objectAtIndex:3];
                        }
                        else
                        {
                            for (int i=3; i<count-1; i++) {
                                tag = [NSString stringWithFormat:@"%@/%@", [array objectAtIndex:i],[array objectAtIndex:i+1]];
                            }
                        }
                        
                        url_item.type = PostList;
                        url_item.attachment = tag;
                        
                        return url_item;
                    }
                }
            }
        }
        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", url]]];

        //Normal weblink
        return url_item;
    }
}

+ (NSString *)getTextViewString2:(NSString *)author andObjectType:(int)objectType andObjectCatalog:(int)objectCatalog andObjectTitle:(NSString *)title andMessage:(NSString *)message andPubDate:(NSString *)pubDate /*andReply:(ObjectReply *)reply*/
{
    NSString *_author = @"";
    if (author != nil) {
        _author = [NSString stringWithFormat:@"%@",author];
    }
    NSString *_message = @"";
//    NSString *_pubDate = @"";
//    if (pubDate != nil) {
//        _pubDate = [NSString stringWithFormat:@"%@",pubDate];
//    }
    //NSString *_reply = @"";
    switch (objectType) {
        case 6:
        {
            _message = [NSString stringWithFormat:@" 发布了一个职位 %@ %@",title,message];
        }
            break;
        case 20:
        {
            _message = [NSString stringWithFormat:@" 在职位 %@ 发表评论:%@",title,message];
        }
            break;
        case 32:
        {
            if (objectCatalog == 0) {
                _message = @" 加入了开源中国";
            }
        }
            break;
        case 1:
        {
            if (objectCatalog == 0) {
                _message = [NSString stringWithFormat:@" 添加了开源项目 %@ %@",title,message];
            }
        }
            break;
        case 2:
        {
            if (objectCatalog == 1) {
                _message = [NSString stringWithFormat:@" 在讨论区提问 %@ %@",title,message];
            }
            else if(objectCatalog == 2){
                _message = [NSString stringWithFormat:@" 发表了新话题: %@ %@",title,message];
            }
        }
            break;
        case 3:
        {
            if (objectCatalog == 0) {
                _message = [NSString stringWithFormat:@" 发表了博客 %@ %@",title,message];
            }
        }
            break;
        case 4:
        {
            if (objectCatalog == 0) {
                _message = [NSString stringWithFormat:@" 发表一篇新闻 %@ %@",title,message];
            }
        }
            break;
        case 5:
        {
            if (objectCatalog == 0) {
                _message = [NSString stringWithFormat:@" 分享了一段代码 %@ %@",title,message];
            }
        }
            break;
        case 16:
        {
            if (objectCatalog == 0) {
                _message = [NSString stringWithFormat:@" 在新闻 %@ 发表评论 %@",title,message];
            }
        }
            break;
            //锁定 objectCataog = 1
        case 17:
        {
            if (objectCatalog == 1) {
                _message = [NSString stringWithFormat:@" 回答了问题:%@ %@",title,message];
            }
            else if(objectCatalog == 2){
                _message = [NSString stringWithFormat:@" 回复了话题:%@ %@",title,message];
            }
            else if(objectCatalog == 3){
                _message = [NSString stringWithFormat:@" 在 %@ 对回帖发表评论%@",title,message];
            }
        }
            break;
        case 18:
        {
            if (objectCatalog == 0) {
                _message = [NSString stringWithFormat:@" 在博客 %@ 发表评论 %@",title,message];
            }
        }
            break;
        case 19:
        {
            if (objectCatalog == 0) {
                _message = [NSString stringWithFormat:@" 在代码 %@ 发表评论 %@",title,message];
            }
        }
            break;
        case 100:
        {
            if (objectCatalog == 0) {
                _message = [NSString stringWithFormat:@" 更新了动态"];
            }
        }
            break;
        case 101:
        {
            if (objectCatalog == 0) {
                _message = [NSString stringWithFormat:@" 回复了动态"];
            }
        }
            break;
    }
//    //计算reply
//    if (reply) {
//        _reply = [NSString stringWithFormat:@"<font size=6>\n\n</font><font size=13 color='#FF4600'>@%@: %@</font>", reply.objectname, reply.objectbody];
//    }
    
    NSString *result = [NSString stringWithFormat:@"%@%@",_author,_message /*_reply,_pubDate*/];
    return result;
}

+(int)getTextViewHeight:(UITextView *)txtView andUIFont:(UIFont *)font andText:(NSString *)txt
{
    float fPadding = 16.0;
    CGSize constraint = CGSizeMake(txtView.contentSize.width - 10 - fPadding, CGFLOAT_MAX);
    CGSize size = [txt sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    float fHeight = size.height + 16.0;
    return fHeight;
}

+ (NSString*)getHtmlStyleString
{
    CGRect rectScreen  = [[UIScreen mainScreen]bounds];
    CGFloat bodyWidth  = rectScreen.size.width - 25;
    
    NSString *style = [NSString stringWithFormat:@"<style>#oschina_title {color: #000000; margin-bottom: 6px; font-weight:bold;}#oschina_title img{vertical-align:middle;margin-right:6px;}#oschina_title a{color:#0D6DA8;}#oschina_outline {color: #707070; font-size: 12px;}#oschina_outline a{color:#0D6DA8;}#oschina_software{color:#808080;font-size:12px}#oschina_body img {max-width: %dpx;}#oschina_body {font-size:16px;max-width:%dpx;line-height:24px;} #oschina_body table{max-width:%dpx;}#oschina_body pre { font-size:9pt;font-family:Courier New,Arial;border:1px solid #ddd;border-left:5px solid #6CE26C;background:#f6f6f6;padding:5px;}</style>", (int)bodyWidth,(int)bodyWidth, (int)bodyWidth];
    
    return style;
}

@end
