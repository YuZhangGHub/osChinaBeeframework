//
//  oschina.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/11/5.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#ifndef BeeOSChina_oschina_h
#define BeeOSChina_oschina_h
#import "Bee.h"

#define api_news_list @"news_list"
#define api_news_detail @"news_detail"
#define api_post_list @"post_list"
#define api_post_detail @"post_detail"
#define api_login_validate @"https://www.oschina.net/action/api/login_validate"
#define api_software_detail @"software_detail"
#define api_blog_detail @"blog_detail"
#define api_softwarecatalog_list @"softwarecatalog_list"
#define api_software_list @"software_list"
#define api_softwaretag_list @"softwaretag_list"
#define api_my_information @"my_information"
#define api_blog_list @"blog_list"
#define api_userinfo_update @"portrait_update"
#define api_search_list @"search_list"
#define api_tweet_list @"tweet_list"
#define api_tweet_detail @"tweet_detail"
#define api_comment_list @"comment_list"
#define api_blogcomment_list @"blogcomment_list"
#define api_active_list @"active_list"
#define api_message_list @"message_list"
#define api_user_information @"user_information"
#define api_favorite_list @"favorite_list"
#define api_friends_list @"friends_list"
#define api_userblog_list @"userblog_list"
#define api_post_pub @"post_pub"
#define api_tweet_pub @"tweet_pub"
#define api_message_pub @"message_pub"
#define api_comment_pub @"comment_pub"
#define api_blogcomment_pub @"blogcomment_pub"
#define api_comment_reply @"comment_reply"
#define api_tweet_delete @"tweet_delete"
#define api_message_delete @"message_delete"
#define api_favorite_add @"favorite_add"
#define api_favorite_delete @"favorite_delete"
#define api_user_updaterelation @"user_updaterelation"
#define api_notice_clear @"notice_clear"
#define api_user_notice @"user_notice"

//Not used
#define api_comment_delete @"comment_delete"          //have no access
#define api_blogcomment_delete @"blogcomment_delete"  //have no access
#define api_userblog_delete @"userblog_delete"        //have no access
#define api_report @"http://www.oschina.net/action/communityManage/report"

typedef enum
{
    SearchTypeSoftware	= 0,
    SearchTypePost		= 1,
    SearchTypeBlog      = 2,
    SearchTypeNews	    = 3,
} SearchType;

typedef enum
{
    News	            = 0,
    Blog		        = 1,
    Recommend           = 2,
} NewsType;

typedef enum
{
    Question            = 1,
    Sharing             = 2,
    Synthesize          = 3,
    Carrer              = 4,
    Site                = 5,
} PostType;

typedef enum
{
    NormalComment       = 0,
    BlogComment         = 1,
} CommentType;

typedef enum
{
    FromNews            = 1,
    FromQuestion        = 2,
    FromTweet           = 3,
    FromMessage         = 4,
    FromBlog            = 5,
} CommentSourceType;

typedef enum
{
    All                 = 1,
    AtMe                = 2,
    MyComment           = 3,
    MyBlog              = 4,
    MyMessage           = 5,
} PersonalSelType;

typedef enum
{
    FavoriteSoftware    = 1,
    FavoriteTopic       = 2,
    FavoriteBlog        = 3,
    FavoriteNews        = 4,
    FavoriteCode        = 5,
} FavoriteType;

typedef enum
{
    WebLink             = 0,
    NewsDetail          = 1,
    SoftwareDetail      = 2,
    QuestionDetail      = 3,
    PostList            = 4,
    UserDetail          = 5,
    BlogDetail          = 6,
    TweetDetail         = 7,
} UrlLinkType;

#pragma mark - Data Entities

@interface STATUS : NSObject
@property (nonatomic, retain) NSNumber *		error_code;
@property (nonatomic, retain) NSString *		error_desc;
@property (nonatomic, retain) NSNumber *		succeed;
@end

@interface URL_ITEM : NSObject
@property (nonatomic)         UrlLinkType		type;
@property (nonatomic, retain) NSString *		attachment;
@property (nonatomic)         int		        reserved;  //id 0, username 1, for user details
@end

@interface NEWS : BeeActiveObject

@property (nonatomic, retain)NSNumber* id;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * url;
@property (nonatomic,copy) NSString * author;
@property int                         authorid;
@property (nonatomic,copy) NSString * pubDate;
@property int                         commentCount;
@property int                         newsType;
@property (nonatomic,copy) NSString * attachment;
@property int                         authoruid2;

+ (NEWS*)createByXML:(CXMLElement *) elem;

@end

@interface RELATIVE_NEWS : BeeActiveObject

@property (nonatomic,copy) NSString * url;
@property (nonatomic,copy) NSString * title;

@end

@interface NEWS_DETAIL : BeeActiveObject

@property int _id;
@property (copy,nonatomic) NSString * title;
@property (copy,nonatomic) NSString * url;
@property (copy,nonatomic) NSString * body;
@property (copy,nonatomic) NSString * author;
@property int authorid;
@property (copy,nonatomic) NSString * pubDate;
@property int commentCount;
@property (retain,nonatomic)NSMutableArray * relativies;
@property (copy,nonatomic) NSString * softwarelink;
@property (copy,nonatomic) NSString * softwarename;
@property BOOL favorite;

+ (NEWS_DETAIL*)createByXML:(CXMLElement *) elem;

@end

@interface USER_NOTICE : BeeActiveObject
@property (nonatomic, retain) NSNumber *		atmeCount;
@property (nonatomic, retain) NSNumber *		msgCount;
@property (nonatomic, retain) NSNumber *		reviewCount;
@property (nonatomic, retain) NSNumber *		newfansCount;

+ (USER_NOTICE*)createByXML:(CXMLElement *) elem;
@end

@interface USER_PROFILE : BeeActiveObject
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSString *		portrait;
@property (nonatomic, retain) NSString *		joindate;
@property int                                   gender;
@property (nonatomic, retain) NSString *		from;
@property (nonatomic, retain) NSString *		devplatform;
@property (nonatomic, retain) NSString *		expertise;
@property (nonatomic, retain) NSNumber *		favorite_count;
@property (nonatomic, retain) NSNumber *		fan_num;
@property (nonatomic, retain) NSNumber *		follow_num;
@property (nonatomic, retain) USER_NOTICE *		user_notice;

+ (USER_PROFILE*) createByXML:(CXMLElement*) userEle notice:(CXMLElement*) noticeEle;
@end

@interface USER : BeeActiveObject
@property (nonatomic, retain) NSNumber *		favorite_count;
@property (nonatomic, retain) NSNumber *		fan_num;
@property (nonatomic, retain) NSNumber *		follow_num;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSString *		portrait;
@property (nonatomic, retain) NSString *		joindate;
@property int                                   gender;
@property (nonatomic, retain) NSString *		from;
@property (nonatomic, retain) NSString *		devplatform;
@property (nonatomic, retain) NSString *		expertise;
@property (nonatomic, retain) NSNumber *		uid;
@property (nonatomic, retain) NSNumber *		score;
@property (nonatomic, retain) USER_NOTICE *		user_notice;

+ (USER*) createByXML:(CXMLElement*) userEle notice:(CXMLElement*) noticeEle;
@end

@interface NEWS_LIST : BeeActiveObject
@property (nonatomic, retain) NSMutableArray *	    news;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			pages;
@property (nonatomic, retain) NSNumber *			per_page;
@property (nonatomic, retain) NSNumber *			total;
@end

@interface SOFTWARE_TYPE : BeeActiveObject
@property (nonatomic, retain) NSNumber *		tag;
@property (nonatomic, retain) NSString *		name;

+ (SOFTWARE_TYPE*) createByXML:(CXMLElement*) typeEle;
@end

@interface SOFTWARE_ITEM : BeeActiveObject
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSString *		url;
@property (nonatomic, retain) NSString *		description;

+ (SOFTWARE_ITEM*) createByXML:(CXMLElement*) itemEle;
@end

@interface SOFTWARE : BeeActiveObject
@property int _id;
@property (copy,nonatomic)    NSString *        title;
@property (copy,nonatomic)    NSString *        extensionTitle;
@property (copy,nonatomic)    NSString *        url;
@property (copy,nonatomic)    NSString *        license;
@property (copy,nonatomic)    NSString *        body;
@property (copy,nonatomic)    NSString *        homePage;
@property (copy,nonatomic)    NSString *        document;
@property (copy,nonatomic)    NSString *        download;
@property (copy,nonatomic)    NSString *        logo;
@property (copy,nonatomic)    NSString *        language;
@property (copy,nonatomic)    NSString *        os;
@property (copy,nonatomic)    NSString *        recordTime;
@property BOOL                                  favorite;
@property int                                   tweetCount;
@property (nonatomic, retain) USER_NOTICE *		user_notice;

+ (SOFTWARE*) createByXML:(CXMLElement*) softwareEle notice:(CXMLElement*) noticeEle;
@end

@interface SOFTWARE_TYPE_LIST : BeeActiveObject
@property (nonatomic, retain) NSMutableArray *	    types;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			pages;
@property (nonatomic, retain) NSNumber *			per_page;
@property (nonatomic, retain) NSNumber *			total;
@end

@interface SOFTWARE_ITEM_LIST : BeeActiveObject
@property (nonatomic, retain) NSMutableArray *	    items;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			pages;
@property (nonatomic, retain) NSNumber *			per_page;
@property (nonatomic, retain) NSNumber *			total;
@end

@interface BLOG : BeeActiveObject

@property int                                       _id;
@property (nonatomic,copy) NSString *               title;
@property (nonatomic,copy) NSString *               url;
@property int                                       commentCount;
@property (nonatomic,copy) NSString *               where;
@property (nonatomic,copy) NSString *               body;
@property (nonatomic,copy) NSString *               author;
@property int                                       authorid;
@property int                                       docType;
@property (nonatomic,copy) NSString *               pubDate;
@property int                                       favorite;
@property (nonatomic, retain) USER_NOTICE *		    user_notice;

+ (BLOG*)createByXML:(CXMLElement *) elem notice:(CXMLElement*) noticeEle;

@end

@interface BLOG_ITEM : BeeActiveObject

@property int                                       _id;
@property (nonatomic,copy) NSString *               title;
@property (nonatomic,copy) NSString *               url;
@property int                                       commentCount;
@property (nonatomic,copy) NSString *               authorname;
@property int                                       authorid;
@property int                                       docType;
@property (nonatomic,copy) NSString *               pubDate;

+ (BLOG_ITEM*)createByXML:(CXMLElement *) elem;

@end

@interface POST : BeeActiveObject

@property int                                       _id;
@property (copy,nonatomic) NSString *               title;
@property (copy,nonatomic) NSString *               url;
@property (copy,nonatomic) NSString *               portrait;
@property (copy,nonatomic) NSString *               body;
@property (copy,nonatomic) NSString *               author;
@property int                                       authorid;
@property (copy,nonatomic) NSString *               pubDate;
@property int                                       answerCount;
@property int                                       viewCount;
@property (retain,nonatomic)NSMutableArray *        tags;
@property BOOL                                      favorite;
@property (nonatomic, retain) USER_NOTICE *		    user_notice;

+ (POST*)createByXML:(CXMLElement *) elem notice:(CXMLElement*) noticeEle;
@end

@interface POST_ITEM : BeeActiveObject

@property int                                       _id;
@property (nonatomic,copy) NSString *               title;
@property (nonatomic,copy) NSString *               portrait;
@property (nonatomic,copy) NSString *               author;
@property int                                       authorid;
@property (nonatomic,copy) NSString *               pubDate;
@property int                                       answerCount;
@property int                                       viewCount;
@property int                                       catalog;

+ (POST_ITEM*)createByXML:(CXMLElement *) elem;
@end

@interface SEARCH_ITEM : BeeActiveObject
@property int                                       _objId;
@property (nonatomic,copy) NSString *               title;
@property (nonatomic,copy) NSString *               type;
@property (nonatomic,copy) NSString *               author;
@property (nonatomic,copy) NSString *               pubDate;
@property (nonatomic,copy) NSString *               url;

+ (SEARCH_ITEM*)createByXML:(CXMLElement *) elem;
@end

@interface TWEET : BeeActiveObject
@property int                                       _id;
@property (copy,nonatomic) NSString *               portrait;
@property (copy,nonatomic) NSString *               author;
@property (copy,nonatomic) NSString *               authorid;
@property (copy,nonatomic) NSString *               body;
@property int                                       appclient;
@property int                                       commentCount;
@property (nonatomic,copy) NSString *               pubDate;
@property (copy,nonatomic) NSString *               imgSmall;
@property (copy,nonatomic) NSString *               imgBig;
@property (copy,nonatomic) NSString *               attach;
@property (nonatomic, retain) USER_NOTICE *		    user_notice;

+ (TWEET*) createByXML:(CXMLElement *) elem notice:(CXMLElement*) noticeEle;

@end

@interface TWEET_ITEM : BeeActiveObject
@property int                                       _id;
@property (copy,nonatomic) NSString *               portrait;
@property (copy,nonatomic) NSString *               author;
@property (copy,nonatomic) NSString *               authorid;
@property (copy,nonatomic) NSString *               body;
@property int                                       appclient;
@property int                                       commentCount;
@property (nonatomic,copy) NSString *               pubDate;
@property (copy,nonatomic) NSString *               imgSmall;
@property (copy,nonatomic) NSString *               imgBig;
+ (TWEET_ITEM*) createByXML:(CXMLElement *) elem;
@end

@interface REPLY : BeeActiveObject
@property (copy,nonatomic) NSString *               rpubDate;
@property (copy,nonatomic) NSString *               rcontent;
@property (copy,nonatomic) NSString *               rauthor;
+ (REPLY*) createByXML:(CXMLElement *) elem;
@end

@interface REFER : BeeActiveObject
@property (copy,nonatomic) NSString *               refertitle;
@property (copy,nonatomic) NSString *               referbody;
+ (REFER*) createByXML:(CXMLElement *) elem;
@end

@interface COMMENT : BeeActiveObject
@property int                                       _id;
@property (copy,nonatomic) NSString *               portrait;
@property (copy,nonatomic) NSString *               author;
@property (copy,nonatomic) NSString *               authorid;
@property (copy,nonatomic) NSString *               content;
@property int                                       appclient;
@property (nonatomic,copy) NSString *               pubDate;
@property (retain,nonatomic)NSMutableArray *        replies;
@property (retain,nonatomic)NSMutableArray *        refers;
@property (nonatomic, retain) USER_NOTICE *		    user_notice;
+ (COMMENT*) createByXML:(CXMLElement *) elem notice:(CXMLElement*) noticeEle;
@end

@interface FRIEND : BeeActiveObject
@property int                                       userid;
@property (copy,nonatomic) NSString *               name;
@property (copy,nonatomic) NSString *               portrait;
@property (copy,nonatomic) NSString *               expertise;
@property (nonatomic) int                           gender;
+ (FRIEND*) createByXML:(CXMLElement *) elem;
@end

@interface USER_INFO: BeeActiveObject
@property (nonatomic) int		                    relation;
@property (nonatomic) int		                    fans;
@property (nonatomic) int		                    followers;
@property (nonatomic, retain) NSString *            latestonline;
@property (nonatomic, retain) NSString *		    name;
@property (nonatomic, retain) NSString *		    portrait;
@property (nonatomic, retain) NSString *		    joindate;
@property (nonatomic, retain) NSString *            gender;
@property (nonatomic, retain) NSString *		    from;
@property (nonatomic, retain) NSString *		    devplatform;
@property (nonatomic, retain) NSString *		    expertise;
@property (nonatomic, retain) NSNumber *		    uid;
@property (nonatomic, retain) NSNumber *		    score;
@property (nonatomic, retain) NSMutableArray *      activities;
@property (nonatomic, retain) USER_NOTICE *		    user_notice;
+ (USER_INFO*) createByXML:(CXMLElement *) elem notice:(CXMLElement*) noticeEle;
@end

@interface ACTIVITY: BeeActiveObject
@property (nonatomic, retain) NSString *		    _id;
@property (nonatomic, retain) NSString *		    portrait;
@property (nonatomic, retain) NSString *            author;
@property (nonatomic, retain) NSString *		    authorid;
@property int                                       catalog;
@property int                                       objecttype;
@property int                                       objectcatalog;
@property (nonatomic, retain) NSString *		    objecttitle;
@property int                                       appclient;
@property int                                       objectID;
@property (nonatomic, retain) NSString *		    message;
@property int                                       commentCount;
@property (nonatomic, retain) NSString *		    pubDate;
@property (nonatomic, retain) NSString *		    tweetimage;
+ (ACTIVITY*) createByXML:(CXMLElement *) elem;
@end

@interface FAVORITE : BeeActiveObject
@property (nonatomic) int                           objid;
@property (nonatomic) int                           type;
@property (retain,nonatomic) NSString *             title;
@property (retain,nonatomic) NSString *             url;
+ (FAVORITE*) createByXML:(CXMLElement *) elem;
@end

@interface MESSAGE: BeeActiveObject
@property (nonatomic) int		                    _id;
@property (nonatomic, retain) NSString *		    portrait;
@property (nonatomic) int		                    friendid;
@property (nonatomic) int                           senderid;
@property (nonatomic, retain) NSString *		    friendname;
@property (nonatomic, retain) NSString *		    sender;
@property (nonatomic, retain) NSString *		    content;
@property (nonatomic) int		                    messageCount;
@property (nonatomic, retain) NSString *		    pubDate;
+ (MESSAGE*) createByXML:(CXMLElement *) elem;
@end

@interface RESULT : BeeActiveObject
@property (nonatomic) int                           errorCode;
@property (retain,nonatomic) NSString *             errorMessage;
+ (RESULT*) createByXML:(CXMLElement *) elem;
@end

@interface TWEET_ITEM_LIST : BeeActiveObject
@property (nonatomic, retain) NSMutableArray *	    tweets;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			pages;
@property (nonatomic, retain) NSNumber *			per_page;
@property (nonatomic, retain) NSNumber *			total;
@end

@interface BLOG_ITEM_LIST : BeeActiveObject
@property (nonatomic, retain) NSMutableArray *	    blogs;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			pages;
@property (nonatomic, retain) NSNumber *			per_page;
@property (nonatomic, retain) NSNumber *			total;
@end

@interface POST_ITEM_LIST : BeeActiveObject
@property (nonatomic, retain) NSMutableArray *	    posts;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			pages;
@property (nonatomic, retain) NSNumber *			per_page;
@property (nonatomic, retain) NSNumber *			total;
@end

@interface SEARCH_ITEM_LIST : BeeActiveObject
@property (nonatomic, retain) NSMutableArray *	    search_items;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			pages;
@property (nonatomic, retain) NSNumber *			per_page;
@property (nonatomic, retain) NSNumber *			total;
@end

@interface COMMENT_LIST : BeeActiveObject
@property (nonatomic, retain) NSMutableArray *	    comments;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			pages;
@property (nonatomic, retain) NSNumber *			per_page;
@property (nonatomic, retain) NSNumber *			total;
@end

@interface FRIEND_LIST : BeeActiveObject
@property (nonatomic, retain) NSMutableArray *	    friends;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			pages;
@property (nonatomic, retain) NSNumber *			per_page;
@property (nonatomic, retain) NSNumber *			total;
@end

@interface ACTIVITY_LIST : BeeActiveObject
@property (nonatomic, retain) NSMutableArray *	    activities;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			pages;
@property (nonatomic, retain) NSNumber *			per_page;
@property (nonatomic, retain) NSNumber *			total;
@end

@interface FAVORITE_LIST : BeeActiveObject
@property (nonatomic, retain) NSMutableArray *	    favorites;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			pages;
@property (nonatomic, retain) NSNumber *			per_page;
@property (nonatomic, retain) NSNumber *			total;
@end

@interface MESSAGE_LIST : BeeActiveObject
@property (nonatomic, retain) NSMutableArray *	    messages;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			pages;
@property (nonatomic, retain) NSNumber *			per_page;
@property (nonatomic, retain) NSNumber *			total;
@end

#pragma mark - HTTP API Definitions

@interface API_NEWS_LIST : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) NEWS_LIST*	         resp;
@end

@interface API_NEWS_DETAIL: BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) NEWS_DETAIL*	         resp;
@end

@interface API_LOGIN : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) USER*	                 resp;
@end

@interface API_USER_PROFILE : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) USER_PROFILE*	         resp;
@end

@interface API_SOFTWARE_CATALOGS : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) SOFTWARE_TYPE_LIST*	 resp;
@end

@interface API_SOFTWARE_LIST : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) SOFTWARE_ITEM_LIST*	 resp;
@end

@interface API_SOFTWARETAG_LIST : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) SOFTWARE_ITEM_LIST*	 resp;
@end

@interface API_SOFTWARE_DETAIL : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) SOFTWARE*	             resp;
@end

@interface API_POST_LIST : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) POST_ITEM_LIST*	     resp;
@end

@interface API_BLOG_LIST : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) BLOG_ITEM_LIST*	     resp;
@end

@interface API_POST_DETAIL : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) POST*	                 resp;
@end

@interface API_BLOG_DETAIL : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) BLOG*	                 resp;
@end

@interface API_SEARCH_LIST : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) SEARCH_ITEM_LIST*	     resp;
@property int                                        type;
@end

@interface API_TWEET_LIST : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) TWEET_ITEM_LIST*	     resp;
@end

@interface API_TWEET_DETAIL : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) TWEET*	             resp;
@end

@interface API_COMMENT_LIST : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) COMMENT_LIST*	         resp;
@end

@interface API_BLOG_COMMENT_LIST : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) COMMENT_LIST*          resp;
@end

@interface API_FRIEND_LIST : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) FRIEND_LIST*           resp;
@end

@interface API_USER_INFO : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) USER_INFO*	         resp;
@end

@interface API_ACTIVITY_LIST : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) ACTIVITY_LIST*         resp;
@end

@interface API_FAVORITE_LIST : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) FAVORITE_LIST*         resp;
@end

@interface API_MESSAGE_LIST : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) MESSAGE_LIST*          resp;
@end

@interface API_POST_PUB : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) POST_ITEM*             resp;
@property (nonatomic, retain) RESULT*                result;
@end

@interface API_TWEET_PUB : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) TWEET_ITEM*            resp;
@property (nonatomic, retain) RESULT*                result;
@end

@interface API_MESSAGE_PUB : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) MESSAGE*               resp;
@property (nonatomic, retain) RESULT*                result;
@end

@interface API_COMMENT_PUB : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) COMMENT*               resp;
@property (nonatomic, retain) RESULT*                result;
@end

@interface API_BLOG_COMMENT_PUB : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) COMMENT*               resp;
@property (nonatomic, retain) RESULT*                result;
@end

@interface API_COMMENT_REPLY : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) COMMENT*               resp;
@property (nonatomic, retain) RESULT*                result;
@end

@interface API_TWEET_DELETE : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) RESULT*                result;
@property (nonatomic) int                            uid;
@property (nonatomic) int                            tweetid;
@end

@interface API_MESSAGE_DELETE : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) RESULT*                result;
@end

@interface API_FAVORITE_DELETE : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) RESULT*                result;
@end

@interface API_FAVORITE_ADD : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) RESULT*                result;
@end

@interface API_USER_UPDATERELATION : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) RESULT*                result;
@end

@interface API_NOTICE_CLEAR : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) RESULT*                result;
@end

@interface API_USER_NOTICE : BeeAPI
@property (nonatomic, retain) NSString *	         id;
@property (nonatomic, retain) USER_NOTICE*           resp;
@end

@interface ServerConfig : NSObject

AS_SINGLETON( ServerConfig )
-(NSString*) url;

@end

#define HTML_Bottom @"<div style='margin-bottom:60px'/>"

#endif
