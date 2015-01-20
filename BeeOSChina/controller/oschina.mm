//
//  oschina.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/5.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "oschina.h"
#import "TouchXML.h"

#pragma mark - Data Entities

@implementation URL_ITEM
@synthesize type         = _type;
@synthesize attachment   = _attachment;
@synthesize reserved     = _reserved;
@end

//News
@implementation NEWS
@synthesize id           = _id;
@synthesize title        = _title;
@synthesize url          = _url;
@synthesize author       = _author;
@synthesize authorid     = _authorid;
@synthesize pubDate      = _pubDate;
@synthesize commentCount = _commentCount;
@synthesize newsType     = _newsType;
@synthesize attachment   = _attachment;
@synthesize authoruid2   = _authoruid2;

+ (NEWS*)createByXML:(CXMLElement *) elem
{
    if(elem == nil) return nil;
    
    NSArray* fields = [elem children];
    
    if(fields == nil) return nil;
    
    NEWS* news = [[NEWS alloc] init];
        
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"id"]) {
            news.id = [[NSNumber alloc ] initWithInt:field.stringValue.intValue];
        } else if ([name equal:@"title"]) {
            news.title = field.stringValue;
        } else if ([name equal:@"commentCount"]) {
            news.commentCount = field.stringValue.intValue;
        } else if ([name equal:@"author"]) {
            news.author = field.stringValue;
        } else if ([name equal:@"authorID"]) {
            news.authorid = field.stringValue.intValue;
        } else if ([name equal:@"pubDate"]) {
            news.pubDate = field.stringValue;
        } else if ([name equal:@"newstype"]) {
            NSArray* childrenTypes = [field children];
            
            for(CXMLElement* subType in childrenTypes)
            {
                NSString* subTypeName = [subType name];
                
                if ([subTypeName equal:@"attachment"]) {
                    news.attachment = subType.stringValue;
                } else if ([subTypeName equal:@"authoruid2"]) {
                    news.authoruid2 = subType.stringValue.intValue;
                } else if ([subTypeName equal:@"type"]) {
                    news.newsType   = subType.stringValue.intValue;
                }
            }
            
        } else if ([name equal:@"url"]) {
            news.url = field.stringValue;
        }
    }

    return news;
}

@end

//Relative news
@implementation RELATIVE_NEWS
@synthesize title = _title;
@synthesize url   = _url;
@end

//Details news
@implementation NEWS_DETAIL
@synthesize _id          = __id;
@synthesize title        = _title;
@synthesize url          = _url;
@synthesize body         = _body;
@synthesize author       = _author;
@synthesize authorid     = _authorid;
@synthesize pubDate      = _pubDate;
@synthesize commentCount = _commentCount;
@synthesize relativies   = _relativies;
@synthesize softwarelink = _softwarelink;
@synthesize softwarename = _softwarename;
@synthesize favorite     = _favorite;

+ (NEWS_DETAIL*)createByXML:(CXMLElement *) elem
{
    if(elem == nil) return nil;
    
    NSArray* fields = [elem children];
    
    if(fields == nil) return nil;
    
    NEWS_DETAIL* detail = [[NEWS_DETAIL alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"id"]) {
            detail._id = field.stringValue.intValue;
        } else if ([name equal:@"title"]) {
            detail.title = field.stringValue;
        } else if ([name equal:@"commentCount"]) {
            detail.commentCount = field.stringValue.intValue;
        } else if ([name equal:@"author"]) {
            detail.author = field.stringValue;
        } else if ([name equal:@"authorid"]) {
            detail.authorid = field.stringValue.intValue;
        } else if ([name equal:@"pubDate"]) {
            detail.pubDate = field.stringValue;
        } else if( [name equal:@"body"]) {
            detail.body = field.stringValue;
        } else if ([name equal:@"relativies"]) {
            detail.relativies = [[NSMutableArray alloc] initWithCapacity:10];
            
            NSArray* items = [field children];
            for(CXMLElement* item in items)
            {
                if(item == nil) continue;
                if([item.name equal:@"relative"])
                {
                    NSArray* relFields      = [item children];
                    RELATIVE_NEWS* relative = [[RELATIVE_NEWS alloc] init];
                    for(CXMLElement* relField in relFields)
                    {
                        NSString* fieldName = relField.name;
                        if ([fieldName equal:@"rtitle"]) {
                            relative.title = relField.stringValue;
                        } else if ([fieldName equal:@"rurl"]) {
                            relative.url   = relField.stringValue;
                        }
                    }
                    [detail.relativies addObject:relative];
                }
            }
            
        } else if ([name equal:@"url"]) {
            detail.url = field.stringValue;
        } else if ([name equal:@"softwarelink"]) {
            detail.softwarelink = field.stringValue;
        } else if ([name equal:@"softwarename"]) {
            detail.softwarename = field.stringValue;
        } else if ([name equal:@"favorite"]) {
            detail.favorite = field.stringValue.boolValue;
        }
    }
    
    return detail;
}

@end
//User notice
@implementation USER_NOTICE
@synthesize atmeCount      = _atmeCount;
@synthesize msgCount       = _msgCount;
@synthesize reviewCount    = _reviewCount;
@synthesize newfansCount   = _newfansCount;

+ (USER_NOTICE*)createByXML:(CXMLElement *) noticeEle
{
    if(noticeEle == nil) return nil;
    
    NSArray* fields = [noticeEle children];
    
    if(fields == nil || [fields count] == 0) return nil;
    
    USER_NOTICE* notice = [[USER_NOTICE alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"atmeCount"]) {
            notice.atmeCount   = [[NSNumber alloc ] initWithInt:field.stringValue.intValue];
        } else if ([name equal:@"msgCount"]) {
            notice.msgCount    = [[NSNumber alloc ] initWithInt:field.stringValue.intValue];
        } else if ([name equal:@"reviewCount"]) {
            notice.reviewCount = [[NSNumber alloc ] initWithInt:field.stringValue.intValue];
        } else if ([name equal:@"newFansCount"]) {
            notice.newfansCount= [[NSNumber alloc ] initWithInt:field.stringValue.intValue];
        }
    }
    
    return notice;
}
@end

//User profile
@implementation USER_PROFILE
@synthesize name             = _name;
@synthesize portrait         = _portrait;
@synthesize joindate         = _joindate;
@synthesize gender           = _gender;
@synthesize from             = _from;
@synthesize devplatform      = _devplatform;
@synthesize favorite_count   = _favorite_count;
@synthesize fan_num          = _fan_num;
@synthesize follow_num       = _follow_num;
@synthesize user_notice      = _user_notice;

+ (USER_PROFILE*) createByXML:(CXMLElement*) userEle notice:(CXMLElement*) noticeEle
{
    if(userEle == nil) return nil;
    
    NSArray* fields = [userEle children];
    
    if(fields == nil || [fields count] == 0) return nil;
    
    USER_PROFILE* profile = [[USER_PROFILE alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"jointime"]) {
            profile.joindate = field.stringValue;
        } else if ([name equal:@"from"]) {
            profile.from  = field.stringValue;
        } else if ([name equal:@"name"]) {
            profile.name  = field.stringValue;
        } else if ([name equal:@"followerscount"]) {
            profile.follow_num= [[NSNumber alloc ] initWithInt:field.stringValue.intValue];
        } else if ([name equal:@"fanscount"]) {
            profile.fan_num    = [[NSNumber alloc ] initWithInt:field.stringValue.intValue];
        } else if ([name equal:@"favoritecount"]) {
            profile.favorite_count = [[NSNumber alloc ] initWithInt:field.stringValue.intValue];
        } else if ([name equal:@"portrait"]) {
            profile.portrait = field.stringValue;
        } else if ([name equal:@"gender"]) {
            profile.gender = field.stringValue.intValue;
        } else if ([name equal:@"devplatform"]) {
            profile.devplatform = field.stringValue;
        } else if ([name equal:@"expertise"]) {
            profile.expertise = field.stringValue;
        }
    }
    
    USER_NOTICE* notice = [USER_NOTICE createByXML:noticeEle];
    profile.user_notice    = notice;
    
    return profile;
}
@end

//User
@implementation USER
@synthesize favorite_count = _favorite_count;
@synthesize fan_num        = _fan_num;
@synthesize follow_num     = _follow_num;
@synthesize name           = _name;
@synthesize portrait       = _portrait;
@synthesize joindate       = _joindate;
@synthesize gender         = _gender;
@synthesize from           = _from;
@synthesize devplatform    = _devplatform;
@synthesize expertise      = _expertise;
@synthesize uid            = _uid;
@synthesize user_notice    = _user_notice;
@synthesize score          = _score;

+ (USER*) createByXML:(CXMLElement*) userEle notice:(CXMLElement*) noticeEle
{
    if(userEle == nil) return nil;
    
    NSArray* fields = [userEle children];
    
    if(fields == nil || [fields count] == 0) return nil;
    
    USER* user = [[USER alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"uid"]) {
            user.uid   = [[NSNumber alloc ] initWithInt:field.stringValue.intValue];
        } else if ([name equal:@"location"]) {
            user.from  = field.stringValue;
        } else if ([name equal:@"name"]) {
            user.name  = field.stringValue;
        } else if ([name equal:@"followers"]) {
            user.follow_num= [[NSNumber alloc ] initWithInt:field.stringValue.intValue];
        } else if ([name equal:@"fans"]) {
            user.fan_num    = [[NSNumber alloc ] initWithInt:field.stringValue.intValue];
        } else if ([name equal:@"score"]) {
            user.score = [[NSNumber alloc ] initWithInt:field.stringValue.intValue];
        } else if ([name equal:@"portrait"]) {
            user.portrait = field.stringValue;
        }
    }
    
    USER_NOTICE* notice = [USER_NOTICE createByXML:noticeEle];
    user.user_notice    = notice;
    
    return user;
}
@end

//News list
@implementation NEWS_LIST
@synthesize news           = _news;
@synthesize page           = _page;
@synthesize pages          = _pages;
@synthesize per_page       = _per_page;
@synthesize total          = _total;
@end

@implementation SOFTWARE_TYPE
@synthesize tag            = _tag;
@synthesize name           = _name;

+ (SOFTWARE_TYPE*) createByXML:(CXMLElement*) typeEle
{
    if(typeEle == nil) return nil;
    
    NSArray* fields = [typeEle children];
    
    if(fields == nil || [fields count] == 0) return nil;
    
    SOFTWARE_TYPE* type = [[SOFTWARE_TYPE alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"tag"]) {
            type.tag   = [[NSNumber alloc ] initWithInt:field.stringValue.intValue];
        } else if ([name equal:@"name"]) {
            type.name  = field.stringValue;
        }
    }
    
    return type;
}
@end

@implementation SOFTWARE_ITEM
@synthesize name           = _name;
@synthesize url            = _url;
@synthesize description    = _description;

+ (SOFTWARE_ITEM*) createByXML:(CXMLElement*) itemEle
{
    if(itemEle == nil) return nil;
    
    NSArray* fields = [itemEle children];
    
    if(fields == nil || [fields count] == 0) return nil;
    
    SOFTWARE_ITEM* item = [[SOFTWARE_ITEM alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"url"]) {
            item.url   = field.stringValue;
        } else if ([name equal:@"name"]) {
            item.name  = field.stringValue;
        } else if ([name equal:@"description"]) {
            item.description  = field.stringValue;
        }
    }
    
    return item;
}
@end

@implementation SOFTWARE
@synthesize _id            = __id;
@synthesize title          = _title;
@synthesize extensionTitle = _extensionTitle;
@synthesize license        = _license;
@synthesize body           = _body;
@synthesize homePage       = _homePage;
@synthesize document       = _document;
@synthesize download       = _download;
@synthesize logo           = _logo;
@synthesize language       = _language;
@synthesize os             = _os;
@synthesize recordTime     = _recordTime;
@synthesize favorite       = _favorite;
@synthesize user_notice    = _user_notice;
@synthesize tweetCount     = _tweetCount;
@synthesize url            = _url;

+ (SOFTWARE*) createByXML:(CXMLElement*) softwareEle notice:(CXMLElement*) noticeEle
{
    if(softwareEle == nil) return nil;
    
    NSArray* fields = [softwareEle children];
    
    if(fields == nil || [fields count] == 0) return nil;
    
    SOFTWARE* software = [[SOFTWARE alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"id"]) {
            software._id = field.stringValue.intValue;
        } else if ([name equal:@"title"]) {
            software.title = field.stringValue;
        } else if ([name equal:@"url"]) {
            software.url  = field.stringValue;
        } else if ([name equal:@"extensionTitle"]) {
            software.extensionTitle  = field.stringValue;
        } else if ([name equal:@"license"]) {
            software.license  = field.stringValue;
        } else if ([name equal:@"body"]) {
            software.body  = field.stringValue;
        } else if ([name equal:@"recordTime"]) {
            software.recordTime = field.stringValue;
        } else if ([name equal:@"homepage"]) {
            software.homePage  = field.stringValue;
        } else if ([name equal:@"document"]) {
            software.document  = field.stringValue;
        } else if ([name equal:@"download"]) {
            software.download  = field.stringValue;
        } else if ([name equal:@"logo"]) {
            software.logo  = field.stringValue;
        } else if ([name equal:@"language"]) {
            software.language  = field.stringValue;
        } else if ([name equal:@"os"]) {
            software.os  = field.stringValue;
        } else if ([name equal:@"favorite"]) {
            software.favorite  = field.stringValue.boolValue;
        } else if ([name equal:@"tweetCount"]) {
            software.tweetCount  = field.stringValue.intValue;
        }
    }
    
    USER_NOTICE* notice = [USER_NOTICE createByXML:noticeEle];
    software.user_notice    = notice;
    
    return software;
}
@end

@implementation SOFTWARE_TYPE_LIST
@synthesize types          = _types;
@synthesize page           = _page;
@synthesize pages          = _pages;
@synthesize per_page       = _per_page;
@synthesize total          = _total;
@end

@implementation SOFTWARE_ITEM_LIST
@synthesize items          = _items;
@synthesize page           = _page;
@synthesize pages          = _pages;
@synthesize per_page       = _per_page;
@synthesize total          = _total;
@end

@implementation BLOG
@synthesize _id            = __id;
@synthesize title          = _title;
@synthesize url            = _url;
@synthesize body           = _body;
@synthesize author         = _author;
@synthesize where          = _where;
@synthesize docType        = _docType;
@synthesize authorid       = _authorid;
@synthesize pubDate        = _pubDate;
@synthesize commentCount   = _commentCount;
@synthesize favorite       = _favorite;
@synthesize user_notice    = _user_notice;

+ (BLOG*)createByXML:(CXMLElement *) elem notice:(CXMLElement*) noticeEle
{
    if(elem == nil) return nil;
    
    NSArray* fields = [elem children];
    
    if(fields == nil) return nil;
    
    BLOG* blog = [[BLOG alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"id"]) {
            blog._id = field.stringValue.intValue;
        } else if ([name equal:@"title"]) {
            blog.title = field.stringValue;
        } else if ([name equal:@"commentCount"]) {
            blog.commentCount = field.stringValue.intValue;
        } else if ([name equal:@"author"]) {
            blog.author = field.stringValue;
        } else if ([name equal:@"authorid"]) {
            blog.authorid = field.stringValue.intValue;
        } else if ([name equal:@"pubDate"]) {
            blog.pubDate = field.stringValue;
        } else if( [name equal:@"body"]) {
            blog.body = field.stringValue;
        } else if ([name equal:@"url"]) {
            blog.url = field.stringValue;
        } else if ([name equal:@"where"]) {
            blog.where = field.stringValue;
        } else if ([name equal:@"documentType"]) {
            blog.docType = field.stringValue.intValue;
        }else if ([name equal:@"favorite"]) {
            blog.favorite = field.stringValue.boolValue;
        }
    }
    
    USER_NOTICE* notice = [USER_NOTICE createByXML:noticeEle];
    blog.user_notice    = notice;
    
    return blog;
}

@end

@implementation BLOG_ITEM
@synthesize _id            = __id;
@synthesize title          = _title;
@synthesize url            = _url;
@synthesize docType        = _docType;
@synthesize authorid       = _authorid;
@synthesize pubDate        = _pubDate;
@synthesize commentCount   = _commentCount;

+ (BLOG_ITEM*)createByXML:(CXMLElement *) elem
{
    if(elem == nil) return nil;
    
    NSArray* fields = [elem children];
    
    if(fields == nil) return nil;
    
    BLOG_ITEM* blog = [[BLOG_ITEM alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"id"]) {
            blog._id = field.stringValue.intValue;
        } else if ([name equal:@"title"]) {
            blog.title = field.stringValue;
        } else if ([name equal:@"commentCount"]) {
            blog.commentCount = field.stringValue.intValue;
        } else if ([name equal:@"authorname"]) {
            blog.authorname = field.stringValue;
        } else if ([name equal:@"authoruid"]) {
            blog.authorid = field.stringValue.intValue;
        } else if ([name equal:@"pubDate"]) {
            blog.pubDate = field.stringValue;
        } else if ([name equal:@"url"]) {
            blog.url = field.stringValue;
        } else if ([name equal:@"documentType"]) {
            blog.docType = field.stringValue.intValue;
        }
    }
    
    return blog;
}

@end

@implementation POST
@synthesize _id            = __id;
@synthesize title          = _title;
@synthesize url            = _url;
@synthesize body           = _body;
@synthesize author         = _author;
@synthesize authorid       = _authorid;
@synthesize pubDate        = _pubDate;
@synthesize favorite       = _favorite;
@synthesize user_notice    = _user_notice;
@synthesize portrait       = _portrait;
@synthesize answerCount    = _answerCount;
@synthesize viewCount      = _viewCount;
@synthesize tags           = _tags;

+ (POST*)createByXML:(CXMLElement *) elem notice:(CXMLElement*) noticeEle
{
    if(elem == nil) return nil;
    
    NSArray* fields = [elem children];
    
    if(fields == nil) return nil;
    
    POST* post = [[POST alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"id"]) {
            post._id = field.stringValue.intValue;
        } else if ([name equal:@"title"]) {
            post.title = field.stringValue;
        } else if ([name equal:@"portrait"]) {
            post.portrait = field.stringValue;
        } else if ([name equal:@"author"]) {
            post.author = field.stringValue;
        } else if ([name equal:@"authorid"]) {
            post.authorid = field.stringValue.intValue;
        } else if ([name equal:@"pubDate"]) {
            post.pubDate = field.stringValue;
        } else if( [name equal:@"body"]) {
            post.body = field.stringValue;
        } else if ([name equal:@"url"]) {
            post.url = field.stringValue;
        } else if ([name equal:@"answerCount"]) {
            post.answerCount = field.stringValue.intValue;
        } else if ([name equal:@"viewCount"]) {
            post.viewCount = field.stringValue.intValue;
        } else if ([name equal:@"favorite"]) {
            post.favorite = field.stringValue.boolValue;
        } else if ([name equal:@"tags"]) {
            post.tags = [[NSMutableArray alloc] init];
            
            NSArray* items = [field children];
            for(CXMLElement* item in items)
            {
                if(item == nil) continue;
                if([item.name equal:@"tag"])
                {
                    NSString* fieldName = item.name;
                    if ([fieldName equal:@"tag"]) {
                        NSString* tag = item.stringValue;
                        [post.tags addObject:tag];
                    }
                }
            }
        }
        
    }
    
    USER_NOTICE* notice = [USER_NOTICE createByXML:noticeEle];
    post.user_notice    = notice;
    
    return post;
}

@end

@implementation POST_ITEM
@synthesize _id            = __id;
@synthesize title          = _title;
@synthesize authorid       = _authorid;
@synthesize pubDate        = _pubDate;
@synthesize portrait       = _portrait;
@synthesize author         = _author;
@synthesize answerCount    = _answerCount;
@synthesize viewCount      = _viewCount;
@synthesize catalog        = _catalog;

+ (POST_ITEM*)createByXML:(CXMLElement *) elem
{
    if(elem == nil) return nil;
    
    NSArray* fields = [elem children];
    
    if(fields == nil) return nil;
    
    POST_ITEM* post = [[POST_ITEM alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"id"]) {
            post._id = field.stringValue.intValue;
        } else if ([name equal:@"title"]) {
            post.title = field.stringValue;
        } else if ([name equal:@"answerCount"]) {
            post.answerCount = field.stringValue.intValue;
        } else if ([name equal:@"author"]) {
            post.author = field.stringValue;
        } else if ([name equal:@"authoruid"]) {
            post.authorid = field.stringValue.intValue;
        } else if ([name equal:@"pubDate"]) {
            post.pubDate = field.stringValue;
        } else if ([name equal:@"portrait"]) {
            post.portrait = field.stringValue;
        } else if ([name equal:@"viewCount"]) {
            post.viewCount = field.stringValue.intValue;
        }
    }
    
    return post;
}

@end

@implementation SEARCH_ITEM
@synthesize _objId         = __objId;
@synthesize title          = _title;
@synthesize pubDate        = _pubDate;
@synthesize url            = _url;
@synthesize author         = _author;
@synthesize type           = _type;

+ (SEARCH_ITEM*)createByXML:(CXMLElement *) elem
{
    if(elem == nil) return nil;
    
    NSArray* fields = [elem children];
    
    if(fields == nil) return nil;
    
    SEARCH_ITEM* searchItem = [[SEARCH_ITEM alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"objid"]) {
            searchItem._objId = field.stringValue.intValue;
        } else if ([name equal:@"title"]) {
            searchItem.title = field.stringValue;
        } else if ([name equal:@"url"]) {
            searchItem.url = field.stringValue;
        } else if ([name equal:@"author"]) {
            searchItem.author = field.stringValue;
        } else if ([name equal:@"type"]) {
            searchItem.type = field.stringValue;
        } else if ([name equal:@"pubDate"]) {
            searchItem.pubDate = field.stringValue;
        }
    }
    
    return searchItem;
}

@end

@implementation TWEET
@synthesize _id            = __id;
@synthesize portrait       = _portrait;
@synthesize author         = _author;
@synthesize authorid       = _authorid;
@synthesize pubDate        = _pubDate;
@synthesize body           = _body;
@synthesize appclient      = _appclient;
@synthesize commentCount   = _commentCount;
@synthesize imgBig         = _imgBig;
@synthesize imgSmall       = _imgSmall;
@synthesize attach         = _attach;
@synthesize user_notice    = _user_notice;

+ (TWEET*) createByXML:(CXMLElement *) elem notice:(CXMLElement*) noticeEle
{
    if(elem == nil) return nil;
    
    NSArray* fields = [elem children];
    
    if(fields == nil) return nil;
    
    TWEET* tweet = [[TWEET alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"id"]) {
            tweet._id = field.stringValue.intValue;
        } else if ([name equal:@"portrait"]) {
            tweet.portrait = field.stringValue;
        } else if ([name equal:@"commentCount"]) {
            tweet.commentCount = field.stringValue.intValue;
        } else if ([name equal:@"author"]) {
            tweet.author = field.stringValue;
        } else if ([name equal:@"authorid"]) {
            tweet.authorid = field.stringValue;
        } else if ([name equal:@"pubDate"]) {
            tweet.pubDate = field.stringValue;
        } else if ([name equal:@"body"]) {
            tweet.body = field.stringValue;
        } else if ([name equal:@"appclient"]) {
            tweet.appclient = field.stringValue.intValue;
        } else if ([name equal:@"imgBig"]) {
            tweet.imgBig = field.stringValue;
        } else if ([name equal:@"imgSmall"]) {
            tweet.imgSmall = field.stringValue;
        } else if ([name equal:@"attach"]) {
            tweet.attach = field.stringValue;
        }

    }
    
    USER_NOTICE* notice = [USER_NOTICE createByXML:noticeEle];
    tweet.user_notice    = notice;
    
    return tweet;
}
@end

@implementation TWEET_ITEM
@synthesize _id            = __id;
@synthesize portrait       = _portrait;
@synthesize author         = _author;
@synthesize authorid       = _authorid;
@synthesize pubDate        = _pubDate;
@synthesize body           = _body;
@synthesize appclient      = _appclient;
@synthesize commentCount   = _commentCount;
@synthesize imgBig         = _imgBig;
@synthesize imgSmall       = _imgSmall;

+ (TWEET_ITEM*)createByXML:(CXMLElement *) elem
{
    if(elem == nil) return nil;
    
    NSArray* fields = [elem children];
    
    if(fields == nil) return nil;
    
    TWEET_ITEM* tweet = [[TWEET_ITEM alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"id"]) {
            tweet._id = field.stringValue.intValue;
        } else if ([name equal:@"portrait"]) {
            tweet.portrait = field.stringValue;
        } else if ([name equal:@"commentCount"]) {
            tweet.commentCount = field.stringValue.intValue;
        } else if ([name equal:@"author"]) {
            tweet.author = field.stringValue;
        } else if ([name equal:@"authorid"]) {
            tweet.authorid = field.stringValue;
        } else if ([name equal:@"pubDate"]) {
            tweet.pubDate = field.stringValue;
        } else if ([name equal:@"body"]) {
            tweet.body = field.stringValue;
        } else if ([name equal:@"appclient"]) {
            tweet.appclient = field.stringValue.intValue;
        } else if ([name equal:@"imgBig"]) {
            tweet.imgBig = field.stringValue;
        } else if ([name equal:@"imgSmall"]) {
            tweet.imgSmall = field.stringValue;
        }
    }
    
    return tweet;
}

@end

@implementation REPLY
@synthesize rcontent       = _rcontent;
@synthesize rpubDate       = _rpubDate;
@synthesize rauthor        = _rauthor;

+ (REPLY*)createByXML:(CXMLElement *) elem
{
    if(elem == nil) return nil;
    
    NSArray* fields = [elem children];
    
    if(fields == nil) return nil;
    
    REPLY* reply = [[REPLY alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"rcontent"]) {
            reply.rcontent = field.stringValue;
        } else if ([name equal:@"rpubDate"]) {
            reply.rpubDate = field.stringValue;
        } else if ([name equal:@"rauthor"]) {
            reply.rauthor = field.stringValue;
        }
    }
    
    return reply;
}

@end

@implementation REFER
@synthesize referbody      = _referbody;
@synthesize refertitle     = _refertitle;

+ (REFER*)createByXML:(CXMLElement *) elem
{
    if(elem == nil) return nil;
    
    NSArray* fields = [elem children];
    
    if(fields == nil) return nil;
    
    REFER* refer = [[REFER alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"referbody"]) {
            refer.referbody = field.stringValue;
        } else if ([name equal:@"refertitle"]) {
            refer.refertitle = field.stringValue;
        }
    }
    
    return refer;
}

@end

@implementation COMMENT
@synthesize _id            = __id;
@synthesize portrait       = _portrait;
@synthesize author         = _author;
@synthesize authorid       = _authorid;
@synthesize pubDate        = _pubDate;
@synthesize content        = _content;
@synthesize appclient      = _appclient;
@synthesize refers         = _refers;
@synthesize replies        = _replies;
@synthesize user_notice    = _user_notice;

+ (COMMENT*) createByXML:(CXMLElement *) elem notice:(CXMLElement*) noticeEle
{
    if(elem == nil) return nil;
    
    NSArray* fields = [elem children];
    
    if(fields == nil) return nil;
    
    COMMENT* comment = [[COMMENT alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"id"]) {
            comment._id = field.stringValue.intValue;
        } else if ([name equal:@"portrait"]) {
            comment.portrait = field.stringValue;
        } else if ([name equal:@"author"]) {
            comment.author = field.stringValue;
        } else if ([name equal:@"authorid"]) {
            comment.authorid = field.stringValue;
        } else if ([name equal:@"pubDate"]) {
            comment.pubDate = field.stringValue;
        } else if ([name equal:@"content"]) {
            comment.content = field.stringValue;
        } else if ([name equal:@"appclient"]) {
            comment.appclient = field.stringValue.intValue;
        } else if ([name equal:@"replies"]) {
            comment.replies = [[NSMutableArray alloc] init];
            
            NSArray* items = [field children];
            for(CXMLElement* item in items)
            {
                if(item == nil) continue;
                if([item.name equal:@"reply"])
                {
                    REPLY* reply = [REPLY createByXML:item];
                    [comment.replies addObject:reply];
                }
            }
        } else if ([name equal:@"refers"]) {
            comment.replies = [[NSMutableArray alloc] init];
            
            NSArray* items = [field children];
            for(CXMLElement* item in items)
            {
                if(item == nil) continue;
                if([item.name equal:@"refer"])
                {
                    REFER* refer = [REFER createByXML:item];
                    [comment.refers addObject:refer];
                }
            }
        }
    }
    
    USER_NOTICE* notice = [USER_NOTICE createByXML:noticeEle];
    comment.user_notice    = notice;
    
    return comment;
}

@end

@implementation FRIEND
@synthesize userid         = _userid;
@synthesize name           = _name;
@synthesize portrait       = _portrait;
@synthesize expertise      = _expertise;
@synthesize gender         = _gender;

+ (FRIEND*)createByXML:(CXMLElement *) elem
{
    if(elem == nil) return nil;
    
    NSArray* fields = [elem children];
    
    if(fields == nil) return nil;
    
    FRIEND* friend_item = [[FRIEND alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"userid"]) {
            friend_item.userid = field.stringValue.intValue;
        } else if ([name equal:@"name"]) {
            friend_item.name = field.stringValue;
        } else if ([name equal:@"portrait"]) {
            friend_item.portrait = field.stringValue;
        } else if ([name equal:@"expertise"]) {
            friend_item.expertise = field.stringValue;
        } else if ([name equal:@"gender"]) {
            friend_item.gender = field.stringValue.intValue;
        }
    }
    
    return friend_item;
}

@end

@implementation USER_INFO
@synthesize relation           = _relation;
@synthesize latestonline       = _latestonline;
@synthesize name               = _name;
@synthesize portrait           = _portrait;
@synthesize joindate           = _joindate;
@synthesize gender             = _gender;
@synthesize from               = _from;
@synthesize devplatform        = _devplatform;
@synthesize expertise          = _expertise;
@synthesize uid                = _uid;
@synthesize score              = _score;
@synthesize fans               = _fans;
@synthesize followers          = _followers;
@synthesize activities         = _activities;
@synthesize user_notice        = _user_notice;

+ (USER_INFO*) createByXML:(CXMLElement *) elem notice:(CXMLElement*) noticeEle;
{
    if(elem == nil) return nil;
    
    NSArray* fields = [elem children];
    
    if(fields == nil) return nil;
    
    USER_INFO* user = [[USER_INFO alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"relation"]) {
            user.relation = field.stringValue.intValue;
        } else if ([name equal:@"latestonline"]) {
            user.latestonline = field.stringValue;
        } else if ([name equal:@"name"]) {
            user.name = field.stringValue;
        } else if ([name equal:@"portrait"]) {
            user.portrait = field.stringValue;
        } else if ([name equal:@"jointime"]) {
            user.joindate = field.stringValue;
        } else if ([name equal:@"gender"]) {
            user.gender = field.stringValue;
        } else if ([name equal:@"from"]) {
            user.from = field.stringValue;
        } else if ([name equal:@"devplatform"]) {
            user.devplatform = field.stringValue;
        } else if ([name equal:@"expertise"]) {
            user.expertise = field.stringValue;
        } else if ([name equal:@"uid"]) {
            user.uid = [[NSNumber alloc ] initWithInt:field.stringValue.intValue];
        } else if ([name equal:@"score"]) {
            user.score = [[NSNumber alloc ] initWithInt:field.stringValue.intValue];
        } else if ([name equal:@"fans"]) {
            user.fans = field.stringValue.intValue;
        } else if ([name equal:@"followers"]) {
            user.followers = field.stringValue.intValue;
        }
    }
    
    USER_NOTICE* notice = [USER_NOTICE createByXML:noticeEle];
    user.user_notice    = notice;
    
    return user;
}

@end

@implementation ACTIVITY
@synthesize _id            = __id;
@synthesize portrait       = _portrait;
@synthesize author         = _author;
@synthesize authorid       = _authorid;
@synthesize catalog        = _catalog;
@synthesize objecttype     = _objecttype;
@synthesize objectcatalog  = _objectcatalog;
@synthesize objecttitle    = _objecttitle;
@synthesize appclient      = _appclient;
@synthesize objectID       = _objectID;
@synthesize message        = _message;
@synthesize commentCount   = _commentCount;
@synthesize pubDate        = _pubDate;
@synthesize tweetimage     = _tweetimage;

+ (ACTIVITY*) createByXML:(CXMLElement *) elem
{
    if(elem == nil) return nil;
    
    NSArray* fields = [elem children];
    
    if(fields == nil) return nil;
    
    ACTIVITY* activity = [[ACTIVITY alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"id"]) {
            activity._id = field.stringValue;
        } else if ([name equal:@"portrait"]) {
            activity.portrait = field.stringValue;
        } else if ([name equal:@"author"]) {
            activity.author = field.stringValue;
        } else if ([name equal:@"authorid"]) {
            activity.authorid = field.stringValue;
        } else if ([name equal:@"catalog"]) {
            activity.catalog = field.stringValue.intValue;
        } else if ([name equal:@"objecttype"]) {
            activity.objecttype = field.stringValue.intValue;
        } else if ([name equal:@"objectcatalog"]) {
            activity.objectcatalog = field.stringValue.intValue;
        } else if ([name equal:@"objecttitle"]) {
            activity.objecttitle = field.stringValue;
        } else if ([name equal:@"appclient"]) {
            activity.appclient = field.stringValue.intValue;
        } else if ([name equal:@"objectID"]) {
            activity.objectID = field.stringValue.intValue;
        } else if ([name equal:@"message"]) {
            activity.message = field.stringValue;
        } else if ([name equal:@"commentCount"]) {
            activity.commentCount = field.stringValue.intValue;
        } else if ([name equal:@"pubDate"]) {
            activity.pubDate = field.stringValue;
        } else if ([name equal:@"tweetimage"]) {
           activity.tweetimage = field.stringValue;
        }
    }
    
    return activity;
}

@end

@implementation FAVORITE
@synthesize objid          = _objid;
@synthesize type           = _type;
@synthesize title          = _title;
@synthesize url            = _url;

+ (FAVORITE*) createByXML:(CXMLElement *) elem;
{
    if(elem == nil) return nil;
    
    NSArray* fields = [elem children];
    
    if(fields == nil) return nil;
    
    FAVORITE* fav = [[FAVORITE alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"objid"]) {
            fav.objid = field.stringValue.intValue;
        } else if ([name equal:@"type"]) {
            fav.type = field.stringValue.intValue;
        } else if ([name equal:@"title"]) {
            fav.title = field.stringValue;
        } else if ([name equal:@"url"]) {
            fav.url = field.stringValue;
        }
    }
    
    return fav;
}

@end

@implementation MESSAGE
@synthesize _id            = __id;
@synthesize portrait       = _portrait;
@synthesize friendid       = _friendid;
@synthesize senderid       = _senderid;
@synthesize friendname     = _friendname;
@synthesize sender         = _sender;
@synthesize content        = _content;
@synthesize messageCount   = _messageCount;
@synthesize pubDate        = _pubDate;

+ (MESSAGE*) createByXML:(CXMLElement *) elem
{
    if(elem == nil) return nil;
    
    NSArray* fields = [elem children];
    
    if(fields == nil) return nil;
    
    MESSAGE* message = [[MESSAGE alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"id"]) {
            message._id = field.stringValue.intValue;
        } else if ([name equal:@"portrait"]) {
            message.portrait = field.stringValue;
        } else if ([name equal:@"friendid"]) {
            message.friendid = field.stringValue.intValue;
        } else if ([name equal:@"senderid"]) {
            message.senderid = field.stringValue.intValue;
        } else if ([name equal:@"friendname"]) {
            message.friendname = field.stringValue;
        } else if ([name equal:@"sender"]) {
            message.sender = field.stringValue;
        } else if ([name equal:@"content"]) {
            message.content = field.stringValue;
        } else if ([name equal:@"messageCount"]) {
            message.messageCount = field.stringValue.intValue;
        } else if ([name equal:@"pubDate"]) {
            message.pubDate = field.stringValue;
        }
    }
    
    return message;
}

@end

@implementation RESULT : BeeActiveObject
@synthesize errorCode = _errorCode;
@synthesize errorMessage = _errorMessage;

+ (RESULT*) createByXML:(CXMLElement *) elem
{
    if(elem == nil) return nil;
    
    NSArray* fields = [elem children];
    
    if(fields == nil) return nil;
    
    RESULT* result = [[RESULT alloc] init];
    
    for(CXMLElement* field in fields)
    {
        NSString* name = [field name];
        
        if ([name equal:@"errorCode"]) {
            result.errorCode = field.stringValue.intValue;
        } else if ([name equal:@"errorCode"]) {
            result.errorMessage = field.stringValue;
        }
    }
    
    return result;
}

@end

@implementation BLOG_ITEM_LIST
@synthesize blogs          = _blogs;
@synthesize page           = _page;
@synthesize pages          = _pages;
@synthesize per_page       = _per_page;
@synthesize total          = _total;
@end

@implementation POST_ITEM_LIST
@synthesize posts          = _posts;
@synthesize page           = _page;
@synthesize pages          = _pages;
@synthesize per_page       = _per_page;
@synthesize total          = _total;
@end

@implementation TWEET_ITEM_LIST
@synthesize tweets         = _tweets;
@synthesize page           = _page;
@synthesize pages          = _pages;
@synthesize per_page       = _per_page;
@synthesize total          = _total;
@end

@implementation SEARCH_ITEM_LIST
@synthesize search_items   = _search_items;
@synthesize page           = _page;
@synthesize pages          = _pages;
@synthesize per_page       = _per_page;
@synthesize total          = _total;
@end

@implementation COMMENT_LIST
@synthesize comments       = _comments;
@synthesize page           = _page;
@synthesize pages          = _pages;
@synthesize per_page       = _per_page;
@synthesize total          = _total;
@end

@implementation FRIEND_LIST
@synthesize friends        = _friends;
@synthesize page           = _page;
@synthesize pages          = _pages;
@synthesize per_page       = _per_page;
@synthesize total          = _total;
@end

@implementation ACTIVITY_LIST : BeeActiveObject
@synthesize activities     = _activities;
@synthesize page           = _page;
@synthesize pages          = _pages;
@synthesize per_page       = _per_page;
@synthesize total          = _total;
@end

@implementation FAVORITE_LIST : BeeActiveObject
@synthesize favorites      = _favorites;
@synthesize page           = _page;
@synthesize pages          = _pages;
@synthesize per_page       = _per_page;
@synthesize total          = _total;
@end

@implementation MESSAGE_LIST : BeeActiveObject
@synthesize messages       = _messages;
@synthesize page           = _page;
@synthesize pages          = _pages;
@synthesize per_page       = _per_page;
@synthesize total          = _total;
@end

#pragma mark - HTTP API definitions

//API_NEWS_LIST
@implementation API_NEWS_LIST

@synthesize id   = _id;
@synthesize resp = _resp;

CONVERT_PROPERTY_CLASS( news, NEWS_LIST );

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.resp = nil;
        self.resp = [[NEWS_LIST alloc] init];
        self.resp.news = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.resp.news = nil;
    self.resp = nil;
    //[super dealloc];
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_news_list];
        
        self.HTTP_GET( requestURI );
    }
    else if ( self.succeed )
    {
        NSError* error;
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        NSArray* newslist = [document nodesForXPath:@"oschina/newslist/news" error:&error];
       
        if(newslist == nil)
        {
            self.failed = YES;
            return;
        }
        
        for ( CXMLElement* newsXML in newslist )
        {
            if(newsXML == nil) continue;
            
            NEWS* news = [NEWS createByXML:newsXML];
            [self.resp.news addObject:news];
        }
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}
@end

//API_NEWS_DETAIL
@implementation API_NEWS_DETAIL
@synthesize id     = _id;
@synthesize resp   = _resp;

CONVERT_PROPERTY_CLASS( resp, NEWS_DETAIL );

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.resp = nil;
    }
    return self;
}

- (void)dealloc
{
    self.resp = nil;
    //[super dealloc];
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_news_detail];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        CXMLElement* news = (CXMLElement*)[document nodeForXPath:@"oschina/news" error:&error];
        
        if(news == nil)
        {
            self.failed = YES;
            return;
        }
        
        self.resp = [NEWS_DETAIL createByXML:news];
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

//API_LOGIN
@implementation API_LOGIN

@synthesize id     = _id;
@synthesize resp   = _resp;

CONVERT_PROPERTY_CLASS( resp, USER );

- (id)init
{
    self = [super init];
    self.resp = nil;
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = api_login_validate;
        
        self.HTTP_POST( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        CXMLElement* userEle   = (CXMLElement*)[document nodeForXPath:@"oschina/user" error:&error];
        CXMLElement* noticeEle = (CXMLElement*)[document nodeForXPath:@"oschina/notice" error:&error];
        
        if(userEle == nil)
        {
            self.failed = YES;
            return;
        }
        
        self.resp = [USER createByXML:userEle notice:noticeEle];
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }

    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}
@end

@implementation API_USER_PROFILE
@synthesize id   = _id;
@synthesize resp = _resp;

CONVERT_PROPERTY_CLASS( resp, USER_PROFILE );

- (id)init
{
    self = [super init];
    self.resp = nil;
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_my_information];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        CXMLElement* userEle   = (CXMLElement*)[document nodeForXPath:@"oschina/user" error:&error];
        CXMLElement* noticeEle = (CXMLElement*)[document nodeForXPath:@"oschina/notice" error:&error];
        
        if(userEle == nil)
        {
            self.failed = YES;
            return;
        }
        
        self.resp = [USER_PROFILE createByXML:userEle notice:noticeEle];
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_SOFTWARE_CATALOGS
@synthesize id                     = _id;
@synthesize resp                   = _resp;

CONVERT_PROPERTY_CLASS( resp, SOFTWARE_TYPE_LIST );

- (id)init
{
    self = [super init];
    
    self.resp = nil;
    self.resp = [[SOFTWARE_TYPE_LIST alloc] init];
    self.resp.types = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp.types = nil;
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_softwarecatalog_list];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        NSArray* types = [document nodesForXPath:@"oschina/softwareTypes/softwareType" error:&error];
        
        if(types == nil)
        {
            self.failed = YES;
            return;
        }
        
        for ( CXMLElement* typeXML in types )
        {
            if(typeXML == nil) continue;
            
            SOFTWARE_TYPE* type = [SOFTWARE_TYPE createByXML:typeXML];
            [self.resp.types addObject:type];
        }
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_SOFTWARE_LIST
@synthesize id                     = _id;
@synthesize resp                   = _resp;

CONVERT_PROPERTY_CLASS( resp, SOFTWARE_ITEM_LIST );

- (id)init
{
    self = [super init];
    
    self.resp = nil;
    self.resp = [[SOFTWARE_ITEM_LIST alloc] init];
    self.resp.items = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp.items = nil;
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_software_list];
        
        self.HTTP_POST( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        NSArray* items = [document nodesForXPath:@"oschina/softwares/software" error:&error];
        
        if(items == nil)
        {
            self.failed = YES;
            return;
        }
        
        for ( CXMLElement* itemXML in items )
        {
            if(itemXML == nil) continue;
            
            SOFTWARE_ITEM* item = [SOFTWARE_ITEM createByXML:itemXML];
            [self.resp.items addObject:item];
        }
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_SOFTWARETAG_LIST
@synthesize id                     = _id;
@synthesize resp                   = _resp;

CONVERT_PROPERTY_CLASS( resp, SOFTWARE_ITEM_LIST );

- (id)init
{
    self = [super init];
    
    self.resp = nil;
    self.resp = [[SOFTWARE_ITEM_LIST alloc] init];
    self.resp.items = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp.items = nil;
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_softwaretag_list];
        
        self.HTTP_POST( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        NSArray* items = [document nodesForXPath:@"oschina/softwares/software" error:&error];
        
        if(items == nil)
        {
            self.failed = YES;
            return;
        }
        
        for ( CXMLElement* itemXML in items )
        {
            if(itemXML == nil) continue;
            
            SOFTWARE_ITEM* item = [SOFTWARE_ITEM createByXML:itemXML];
            [self.resp.items addObject:item];
        }
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_SOFTWARE_DETAIL
@synthesize id                     = _id;
@synthesize resp                   = _resp;

CONVERT_PROPERTY_CLASS( resp, SOFTWARE );

- (id)init
{
    self = [super init];
    
    self.resp = nil;
    
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_software_detail];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        CXMLElement* softEle   = (CXMLElement*)[document nodeForXPath:@"oschina/software" error:&error];
        CXMLElement* noticeEle = (CXMLElement*)[document nodeForXPath:@"oschina/notice" error:&error];
        
        if(softEle == nil)
        {
            self.failed = YES;
            return;
        }
            
        self.resp = [SOFTWARE createByXML:softEle notice:noticeEle];
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_POST_LIST

@synthesize id   = _id;
@synthesize resp = _resp;

CONVERT_PROPERTY_CLASS( resp, POST_ITEM_LIST );

- (id)init
{
    self = [super init];
    self.resp = [[POST_ITEM_LIST alloc] init];
    self.resp.posts = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp.posts = nil;
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_post_list];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        NSArray* items = [document nodesForXPath:@"oschina/posts/post" error:&error];
        
        if(items == nil)
        {
            self.failed = YES;
            return;
        }
        
        for ( CXMLElement* itemXML in items )
        {
            if(itemXML == nil) continue;
            
            POST_ITEM* item = [POST_ITEM createByXML:itemXML];
            [self.resp.posts addObject:item];
        }
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_POST_DETAIL

@synthesize id   = _id;
@synthesize resp = _resp;

CONVERT_PROPERTY_CLASS( resp, POST );

- (id)init
{
    self = [super init];
    
    self.resp = nil;
    
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_post_detail];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        CXMLElement* postEle   = (CXMLElement*)[document nodeForXPath:@"oschina/post" error:&error];
        CXMLElement* noticeEle = (CXMLElement*)[document nodeForXPath:@"oschina/notice" error:&error];
        
        if(postEle == nil)
        {
            self.failed = YES;
            return;
        }
        
        self.resp = [POST createByXML:postEle notice:noticeEle];
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_BLOG_LIST

@synthesize id   = _id;
@synthesize resp = _resp;

CONVERT_PROPERTY_CLASS( resp, BLOG_ITEM_LIST );

- (id)init
{
    self = [super init];
    self.resp = [[BLOG_ITEM_LIST alloc] init];
    self.resp.blogs = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp.blogs = nil;
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_blog_list];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        NSArray* items = [document nodesForXPath:@"oschina/blogs/blog" error:&error];
        
        if(items == nil)
        {
            self.failed = YES;
            return;
        }
        
        for ( CXMLElement* itemXML in items )
        {
            if(itemXML == nil) continue;
            
            BLOG_ITEM* item = [BLOG_ITEM createByXML:itemXML];
            [self.resp.blogs addObject:item];
        }
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_BLOG_DETAIL

@synthesize id   = _id;
@synthesize resp = _resp;

CONVERT_PROPERTY_CLASS( resp, BLOG );

- (id)init
{
    self = [super init];
    
    self.resp = nil;
    
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_blog_detail];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        CXMLElement* blogEle   = (CXMLElement*)[document nodeForXPath:@"oschina/blog" error:&error];
        CXMLElement* noticeEle = (CXMLElement*)[document nodeForXPath:@"oschina/notice" error:&error];
        
        if(blogEle == nil)
        {
            self.failed = YES;
            return;
        }
        
        self.resp = [BLOG createByXML:blogEle notice:noticeEle];
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_SEARCH_LIST

@synthesize id   = _id;
@synthesize resp = _resp;
@synthesize type = _type;

CONVERT_PROPERTY_CLASS( resp, SEARCH_ITEM_LIST );

- (id)init
{
    self = [super init];
    self.resp = [[SEARCH_ITEM_LIST alloc] init];
    self.resp.search_items = [[NSMutableArray alloc] init];
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp.search_items = nil;
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_search_list];
        
        self.HTTP_POST( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        NSString* nodePath = @"oschina/results/result";
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        NSArray* items = [document nodesForXPath:nodePath error:&error];
        
        if(items == nil)
        {
            self.failed = YES;
            return;
        }
        
        for ( CXMLElement* itemXML in items )
        {
            if(itemXML == nil) continue;
            
            SEARCH_ITEM* item = [SEARCH_ITEM createByXML:itemXML];
            [self.resp.search_items addObject:item];
        }
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_TWEET_LIST

@synthesize id   = _id;
@synthesize resp = _resp;

CONVERT_PROPERTY_CLASS( resp, TWEET_ITEM_LIST );

- (id)init
{
    self = [super init];
    self.resp = [[TWEET_ITEM_LIST alloc] init];
    self.resp.tweets = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp.tweets = nil;
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_tweet_list];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        NSArray* items = [document nodesForXPath:@"oschina/tweets/tweet" error:&error];
        
        if(items == nil)
        {
            self.failed = YES;
            return;
        }
        
        for ( CXMLElement* itemXML in items )
        {
            if(itemXML == nil) continue;
            
            TWEET_ITEM* item = [TWEET_ITEM createByXML:itemXML];
            [self.resp.tweets addObject:item];
        }
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_TWEET_DETAIL

@synthesize id   = _id;
@synthesize resp = _resp;

CONVERT_PROPERTY_CLASS( resp, TWEET );

- (id)init
{
    self = [super init];
    
    self.resp = nil;
    
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_tweet_detail];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        CXMLElement* blogEle   = (CXMLElement*)[document nodeForXPath:@"oschina/tweet" error:&error];
        CXMLElement* noticeEle = (CXMLElement*)[document nodeForXPath:@"oschina/notice" error:&error];
        
        if(blogEle == nil)
        {
            self.failed = YES;
            return;
        }
        
        self.resp = [TWEET createByXML:blogEle notice:noticeEle];
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_COMMENT_LIST
@synthesize id   = _id;
@synthesize resp = _resp;

CONVERT_PROPERTY_CLASS( resp, COMMENT_LIST );

- (id)init
{
    self = [super init];
    self.resp = [[COMMENT_LIST alloc] init];
    self.resp.comments = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp.comments = nil;
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_comment_list];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        NSArray* items = [document nodesForXPath:@"oschina/comments/comment" error:&error];
        CXMLElement* noticeEle = (CXMLElement*)[document nodeForXPath:@"oschina/notice" error:&error];
        
        if(items == nil)
        {
            self.failed = YES;
            return;
        }
        
        for ( CXMLElement* itemXML in items )
        {
            if(itemXML == nil) continue;
            
            COMMENT* item = [COMMENT createByXML:itemXML notice:noticeEle];
            [self.resp.comments addObject:item];
        }
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_BLOG_COMMENT_LIST
@synthesize id   = _id;
@synthesize resp = _resp;

CONVERT_PROPERTY_CLASS( resp, COMMENT_LIST );

- (id)init
{
    self = [super init];
    self.resp = [[COMMENT_LIST alloc] init];
    self.resp.comments = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp.comments = nil;
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_blogcomment_list];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        NSArray* items = [document nodesForXPath:@"oschina/comments/comment" error:&error];
        CXMLElement* noticeEle = (CXMLElement*)[document nodeForXPath:@"oschina/notice" error:&error];
        
        if(items == nil)
        {
            self.failed = YES;
            return;
        }
        
        for ( CXMLElement* itemXML in items )
        {
            if(itemXML == nil) continue;
            
            COMMENT* item = [COMMENT createByXML:itemXML notice: noticeEle];
            [self.resp.comments addObject:item];
        }
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_FRIEND_LIST
@synthesize id   = _id;
@synthesize resp = _resp;

CONVERT_PROPERTY_CLASS( resp, FRIEND_LIST );

- (id)init
{
    self = [super init];
    self.resp = [[FRIEND_LIST alloc] init];
    self.resp.friends = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp.friends = nil;
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_friends_list];
        
        self.HTTP_POST( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        NSArray* items = [document nodesForXPath:@"oschina/friends/friend" error:&error];
        //CXMLElement* noticeEle = [document nodeForXPath:@"oschina/notice" error:&error];
        
        if(items == nil)
        {
            self.failed = YES;
            return;
        }
        
        for ( CXMLElement* itemXML in items )
        {
            if(itemXML == nil) continue;
            
            FRIEND* item = [FRIEND createByXML:itemXML];
            [self.resp.friends addObject:item];
        }
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_USER_INFO : BeeAPI

@synthesize id   = _id;
@synthesize resp = _resp;

CONVERT_PROPERTY_CLASS( resp, USER_INFO );

- (id)init
{
    self = [super init];
    
    self.resp = nil;
    
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_user_information];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        CXMLElement* userEle     = (CXMLElement*)[document nodeForXPath:@"oschina/user" error:&error];
        CXMLElement* noticeEle   = (CXMLElement*)[document nodeForXPath:@"oschina/notice" error:&error];
        
        NSArray* activies = [document nodesForXPath:@"oschina/activies/active" error:&error];
        
        if(userEle == nil)
        {
            self.failed = YES;
            return;
        }
        
        self.resp = [USER_INFO createByXML:userEle notice:noticeEle];
        self.resp.activities = [[NSMutableArray alloc] init];
        
        for ( CXMLElement* itemXML in activies )
        {
            if(itemXML == nil) continue;
            
            ACTIVITY* activity = [ACTIVITY createByXML:itemXML];
            [self.resp.activities addObject:activity];
        }
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_ACTIVITY_LIST
@synthesize id   = _id;
@synthesize resp = _resp;

CONVERT_PROPERTY_CLASS( resp, ACTIVITY_LIST );

- (id)init
{
    self = [super init];
    self.resp = [[ACTIVITY_LIST alloc] init];
    self.resp.activities = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp.activities = nil;
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_active_list];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        NSArray* items = [document nodesForXPath:@"oschina/activies/active" error:&error];
        //CXMLElement* noticeEle = [document nodeForXPath:@"oschina/notice" error:&error];
        
        if(items == nil)
        {
            self.failed = YES;
            return;
        }
        
        for ( CXMLElement* itemXML in items )
        {
            if(itemXML == nil) continue;
            
            ACTIVITY* item = [ACTIVITY createByXML:itemXML];
            [self.resp.activities addObject:item];
        }
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_FAVORITE_LIST
@synthesize id   = _id;
@synthesize resp = _resp;

CONVERT_PROPERTY_CLASS( resp, FAVORITE_LIST );

- (id)init
{
    self = [super init];
    self.resp = [[FAVORITE_LIST alloc] init];
    self.resp.favorites = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp.favorites = nil;
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_favorite_list];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        NSArray* items = [document nodesForXPath:@"oschina/favorites/favorite" error:&error];
        //CXMLElement* noticeEle = [document nodeForXPath:@"oschina/notice" error:&error];
        
        if(items == nil)
        {
            self.failed = YES;
            return;
        }
        
        for ( CXMLElement* itemXML in items )
        {
            if(itemXML == nil) continue;
            
            FAVORITE* item = [FAVORITE createByXML:itemXML];
            [self.resp.favorites addObject:item];
        }
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_MESSAGE_LIST
@synthesize id   = _id;
@synthesize resp = _resp;

CONVERT_PROPERTY_CLASS( resp, MESSAGE_LIST );

- (id)init
{
    self = [super init];
    self.resp = [[MESSAGE_LIST alloc] init];
    self.resp.messages = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp.messages = nil;
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_message_list];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        NSArray* items = [document nodesForXPath:@"oschina/messages/message" error:&error];
        //CXMLElement* noticeEle = [document nodeForXPath:@"oschina/notice" error:&error];
        
        if(items == nil)
        {
            self.failed = YES;
            return;
        }
        
        for ( CXMLElement* itemXML in items )
        {
            if(itemXML == nil) continue;
            
            MESSAGE* item = [MESSAGE createByXML:itemXML];
            [self.resp.messages addObject:item];
        }
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_POST_PUB
@synthesize id         = _id;
@synthesize resp       = _resp;
@synthesize result     = _result;

CONVERT_PROPERTY_CLASS( resp, POST_ITEM );

- (id)init
{
    self = [super init];
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp = nil;
    self.result = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_post_pub];
        
        self.HTTP_POST( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        CXMLElement* resultItem = (CXMLElement*)[document nodeForXPath:@"oschina/result" error:&error];
        CXMLElement* postItem   = (CXMLElement*)[document nodeForXPath:@"oschina/post" error:&error];
        
        if(resultItem == nil)
        {
            self.failed = YES;
            return;
        }
        
        POST_ITEM* post_item = [POST_ITEM createByXML:postItem];
        RESULT*    result    = [RESULT createByXML:resultItem];
        
        self.resp   = post_item;
        self.result = result;
        
        if ( nil == self.result || NO == [self.result validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_TWEET_PUB
@synthesize id         = _id;
@synthesize resp       = _resp;
@synthesize result     = _result;

CONVERT_PROPERTY_CLASS( resp, TWEET_ITEM );

- (id)init
{
    self = [super init];
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp = nil;
    self.result = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_tweet_pub];
        
        self.HTTP_POST( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        CXMLElement* resultItem = (CXMLElement*)[document nodeForXPath:@"oschina/result" error:&error];
        CXMLElement* tweetItem  = (CXMLElement*)[document nodeForXPath:@"oschina/tweet" error:&error];
        
        if(resultItem == nil)
        {
            self.failed = YES;
            return;
        }
        
        TWEET_ITEM* tweet_item = [TWEET_ITEM createByXML:tweetItem];
        RESULT*     result    = [RESULT createByXML:resultItem];
        
        self.resp   = tweet_item;
        self.result = result;
        
        if ( nil == self.result || NO == [self.result validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_MESSAGE_PUB
@synthesize id         = _id;
@synthesize resp       = _resp;
@synthesize result     = _result;

CONVERT_PROPERTY_CLASS( resp, MESSAGE );

- (id)init
{
    self = [super init];
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp = nil;
    self.result = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_message_pub];
        
        self.HTTP_POST( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        CXMLElement* resultItem = (CXMLElement*)[document nodeForXPath:@"oschina/result" error:&error];
        CXMLElement* msgItem    = (CXMLElement*)[document nodeForXPath:@"oschina/message" error:&error];
        
        if(resultItem == nil)
        {
            self.failed = YES;
            return;
        }
        
        MESSAGE* msg_item = [MESSAGE createByXML:msgItem];
        RESULT*  result   = [RESULT createByXML:resultItem];
        
        self.resp   = msg_item;
        self.result = result;
        
        if ( nil == self.result || NO == [self.result validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_COMMENT_PUB
@synthesize id             = _id;
@synthesize resp           = _resp;
@synthesize result         = _result;

CONVERT_PROPERTY_CLASS( resp, COMMENT );

- (id)init
{
    self = [super init];
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp = nil;
    self.result = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_comment_pub];
        
        self.HTTP_POST( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        CXMLElement* resultItem  = (CXMLElement*)[document nodeForXPath:@"oschina/result" error:&error];
        CXMLElement* commentItem = (CXMLElement*)[document nodeForXPath:@"oschina/comment" error:&error];
        
        if(resultItem == nil)
        {
            self.failed = YES;
            return;
        }
        
        COMMENT* comment_item = [COMMENT createByXML:commentItem notice:nil];
        RESULT*  result       = [RESULT createByXML:resultItem];
        
        self.resp   = comment_item;
        self.result = result;
        
        if ( nil == self.result || NO == [self.result validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_BLOG_COMMENT_PUB
@synthesize id             = _id;
@synthesize resp           = _resp;
@synthesize result         = _result;

CONVERT_PROPERTY_CLASS( resp, COMMENT );

- (id)init
{
    self = [super init];
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp = nil;
    self.result = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_blogcomment_pub];
        
        self.HTTP_POST( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        CXMLElement* resultItem  = (CXMLElement*)[document nodeForXPath:@"oschina/result" error:&error];
        CXMLElement* commentItem = (CXMLElement*)[document nodeForXPath:@"oschina/comment" error:&error];
        
        if(resultItem == nil)
        {
            self.failed = YES;
            return;
        }
        
        COMMENT* comment_item = [COMMENT createByXML:commentItem notice:nil];
        RESULT*  result       = [RESULT createByXML:resultItem];
        
        self.resp   = comment_item;
        self.result = result;
        
        if ( nil == self.result || NO == [self.result validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_COMMENT_REPLY
@synthesize id             = _id;
@synthesize resp           = _resp;
@synthesize result         = _result;

CONVERT_PROPERTY_CLASS( resp, COMMENT );

- (id)init
{
    self = [super init];
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp   = nil;
    self.result = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_comment_reply];
        
        self.HTTP_POST( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        CXMLElement* resultItem  = (CXMLElement*)[document nodeForXPath:@"oschina/result" error:&error];
        CXMLElement* commentItem = (CXMLElement*)[document nodeForXPath:@"oschina/comment" error:&error];
        
        if(resultItem == nil)
        {
            self.failed = YES;
            return;
        }
        
        COMMENT* comment_item = [COMMENT createByXML:commentItem notice:nil];
        RESULT*  result       = [RESULT createByXML:resultItem];
        
        self.resp   = comment_item;
        self.result = result;
        
        if ( nil == self.result || NO == [self.result validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_TWEET_DELETE
@synthesize id         = _id;
@synthesize result     = _result;

CONVERT_PROPERTY_CLASS( resp, RESULT );

- (id)init
{
    self = [super init];
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.result= nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_tweet_delete];
        
        self.HTTP_POST( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        CXMLElement* resultItem = (CXMLElement*)[document nodeForXPath:@"oschina/result" error:&error];
        
        if(resultItem == nil)
        {
            self.failed = YES;
            return;
        }
        
        RESULT*  result       = [RESULT createByXML:resultItem];
        self.result = result;
        
        if ( nil == self.result || NO == [self.result validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_MESSAGE_DELETE
@synthesize id         = _id;
@synthesize result     = _result;

CONVERT_PROPERTY_CLASS( resp, RESULT );

- (id)init
{
    self = [super init];
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.result= nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_message_delete];
        
        self.HTTP_POST( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        CXMLElement* resultItem = (CXMLElement*)[document nodeForXPath:@"oschina/result" error:&error];
        
        if(resultItem == nil)
        {
            self.failed = YES;
            return;
        }
        
        RESULT*  result       = [RESULT createByXML:resultItem];
        self.result = result;
        
        if ( nil == self.result || NO == [self.result validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_FAVORITE_DELETE
@synthesize id         = _id;
@synthesize result     = _result;

CONVERT_PROPERTY_CLASS( resp, RESULT );

- (id)init
{
    self = [super init];
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.result= nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_favorite_delete];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        CXMLElement* resultItem = (CXMLElement*)[document nodeForXPath:@"oschina/result" error:&error];
        
        if(resultItem == nil)
        {
            self.failed = YES;
            return;
        }
        
        RESULT*  result       = [RESULT createByXML:resultItem];
        self.result = result;
        
        if ( nil == self.result || NO == [self.result validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_FAVORITE_ADD
@synthesize id         = _id;
@synthesize result     = _result;

CONVERT_PROPERTY_CLASS( resp, RESULT );

- (id)init
{
    self = [super init];
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.result= nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_favorite_add];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        CXMLElement* resultItem = (CXMLElement*)[document nodeForXPath:@"oschina/result" error:&error];
        
        if(resultItem == nil)
        {
            self.failed = YES;
            return;
        }
        
        RESULT*  result       = [RESULT createByXML:resultItem];
        self.result = result;
        
        if ( nil == self.result || NO == [self.result validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_USER_UPDATERELATION
@synthesize id          = _id;
@synthesize result      = _result;

CONVERT_PROPERTY_CLASS( resp, RESULT );

- (id)init
{
    self = [super init];
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.result= nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_user_updaterelation];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        CXMLElement* resultItem = (CXMLElement*)[document nodeForXPath:@"oschina/result" error:&error];
        
        if(resultItem == nil)
        {
            self.failed = YES;
            return;
        }
        
        RESULT*  result       = [RESULT createByXML:resultItem];
        self.result = result;
        
        if ( nil == self.result || NO == [self.result validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_NOTICE_CLEAR
@synthesize id          = _id;
@synthesize result      = _result;

CONVERT_PROPERTY_CLASS( resp, RESULT );

- (id)init
{
    self = [super init];
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.result= nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_notice_clear];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        CXMLElement* resultItem = (CXMLElement*)[document nodeForXPath:@"oschina/result" error:&error];
        
        if(resultItem == nil)
        {
            self.failed = YES;
            return;
        }
        
        RESULT*  result       = [RESULT createByXML:resultItem];
        self.result = result;
        
        if ( nil == self.result || NO == [self.result validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation API_USER_NOTICE

@synthesize id   = _id;
@synthesize resp = _resp;

CONVERT_PROPERTY_CLASS( resp, USER_NOTICE );

- (id)init
{
    self = [super init];
    
    self.resp = nil;
    
    return self;
}

- (void)dealloc
{
    //[super dealloc];
    self.resp = nil;
}

- (void)routine
{
    if ( self.sending )
    {
        NSString * requestURI = [[[ServerConfig sharedInstance] url] stringByAppendingString:api_user_notice];
        
        self.HTTP_GET( requestURI ).PARAM(self.input);
    }
    else if ( self.succeed )
    {
        NSError* error;
        
        CXMLDocument * document = [[CXMLDocument alloc] initWithXMLString:self.responseString options:NSUTF8StringEncoding error:&error];
        
        CXMLElement* noticeEle = (CXMLElement*)[document nodeForXPath:@"oschina/notice" error:&error];
        
        if(noticeEle == nil)
        {
            self.failed = YES;
            return;
        }
        
        self.resp = [USER_NOTICE createByXML:noticeEle];
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
        
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}

@end

@implementation ServerConfig

DEF_SINGLETON( ServerConfig )

-(NSString*) url
{
    return @"http://www.oschina.net/action/api/";
    //return @"http://localhost/";
}

@end
