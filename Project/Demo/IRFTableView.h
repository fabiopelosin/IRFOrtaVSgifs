//
//  IRFTableView.h
//  IRFOrtaVSgifs
//
//  Created by Fabio Pelosin on 17/10/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IRFTableView : NSTableView

@property (nonatomic, copy) void (^enterKeyBlock)(void);

@end
