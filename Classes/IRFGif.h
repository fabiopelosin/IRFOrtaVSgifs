//
//  IRFGif.h
//  Pods
//
//  Created by Fabio Pelosin on 16/10/13.
//
//

#import <Foundation/Foundation.h>

@interface IRFGif : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSNumber *score;

@property (nonatomic, copy) NSString *domain;

@property (nonatomic, copy) NSNumber *donloadsCount;

@property (nonatomic, copy) NSURL *thumbnailURL;

@property (nonatomic, copy) NSURL *URL;

@property (nonatomic, copy) NSURL *redditURL;

@property (nonatomic, copy) NSNumber *over18;

@end
