//
//  IRFGifSearchManager.h
//  Pods
//
//  Created by Fabio Pelosin on 16/10/13.
//
//

#import <Foundation/Foundation.h>

@interface IRFGifSearchManager : NSObject

- (void)searchWithQuery:(NSString*)query
                  token:(NSString*)token
                success:(void (^)(NSMutableArray *gifs, NSString *token))success
                failure:(void (^)(NSError *error))failure;
@end
