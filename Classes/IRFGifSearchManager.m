//
//  IRFGifSearchManager.m
//  Pods
//
//  Created by Fabio Pelosin on 16/10/13.
//
//

#import "IRFGifSearchManager.h"
#import "IRFGif.h"
#import <AFNetworking/AFNetworking.h>

NSString *const kIRFGifSearchManagerRedditSearchURLFormat = @"http://www.reddit.com/search.json?q=%@+url:*\\.(%@)&restrict_sr=off&sort=relevance&t=all&limit=100";

@implementation IRFGifSearchManager

- (void)searchWithQuery:(NSString*)query
                  token:(NSString*)token
                success:(void (^)(NSMutableArray *gifs, NSString *token))success
                failure:(void (^)(NSError *error))failure {

//    NSArray *extensions = @[@"gif", @"png", @"jpg", @"jpeg"];
    NSArray *extensions = @[@"gif"];
    NSURL *url = [self _redditSearchURLWithQuery:query extensions:extensions token:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSString *token = JSON[@"data"][@"after"];
        NSArray *gifDictionaries = JSON[@"data"][@"children"];

        NSMutableArray *gifs = [NSMutableArray new];
        for (NSDictionary *dictionary in gifDictionaries) {
            IRFGif *gif = [IRFGif new];
            NSDictionary *gifDictionary = dictionary[@"data"];

            NSString *gifExtension = [gifDictionary[@"url"] pathExtension];
            BOOL hasValidExtension = [extensions indexOfObject:gifExtension] != NSNotFound;

            NSArray *knownURLS = [gifs valueForKeyPath:@"@distinctUnionOfObjects.URL"];
            BOOL isDuplicate = [knownURLS indexOfObject:[NSURL URLWithString:gifDictionary[@"url"]]] != NSNotFound;;

            if (hasValidExtension && !isDuplicate) {
                [gif setTitle:gifDictionary[@"title"]];
                [gif setDomain:gifDictionary[@"domain"]];
                [gif setDonloadsCount:gifDictionary[@"downs"]];
                [gif setThumbnailURL:[NSURL URLWithString:gifDictionary[@"thumbnail"]]];
                [gif setURL:[NSURL URLWithString:gifDictionary[@"url"]]];
                [gif setOver18:gifDictionary[@"over_18"]];
                [gif setRedditURL:gifDictionary[@"permalink"]];
                [gif setScore:gifDictionary[@"score"]];
                [gifs addObject:gif];
            }

        }
        success(gifs, token);

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        failure(error);
    }];
    [operation start];
}

- (NSURL*)_redditSearchURLWithQuery:(NSString*)query extensions:(NSArray*)extensions token:(NSString*)token {
    query = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *absoluteURL = [NSString stringWithFormat:kIRFGifSearchManagerRedditSearchURLFormat, query, [extensions componentsJoinedByString:@"|"]];
    if (token) {
        absoluteURL = [absoluteURL stringByAppendingFormat:@"&after=%@", token];
    }
    NSString *encoded = [absoluteURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:encoded];

    return URL;
}

@end


/*
 {
 "approved_by" = "<null>";
 author = MikeyRage;
 "author_flair_css_class" = NHLNewYorkRangersLady;
 "author_flair_text" = NHLNewYorkRangersLady;
 "banned_by" = "<null>";
 clicked = 0;
 created = 1368075937;
 "created_utc" = 1368072337;
 distinguished = "<null>";
 domain = "rangersmultimedia.com";
 downs = 2758;
 edited = 0;
 hidden = 0;
 id = 1dzcnq;
 "is_self" = 0;
 likes = "<null>";
 "link_flair_css_class" = "<null>";
 "link_flair_text" = "<null>";
 media = "<null>";
 "media_embed" =     {
 };
 name = "t3_1dzcnq";
 "num_comments" = 763;
 "num_reports" = "<null>";
 "over_18" = 0;
 permalink = "/r/hockey/comments/1dzcnq/alexander_ovechkins_amazing_back_checking_skills/";
 saved = 0;
 score = 2599;
 "secure_media" = "<null>";
 "secure_media_embed" =     {
 };
 selftext = "";
 "selftext_html" = "<null>";
 stickied = 0;
 subreddit = hockey;
 "subreddit_id" = "t5_2qiel";
 thumbnail = "";
 title = "Alexander Ovechkin's amazing back checking skills.";
 ups = 5357;
 url = "http://rangersmultimedia.com/gifs/hagelin_stepan_tictac_goal.gif";
 }
*/