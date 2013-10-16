//
//  IRFAppDelegate.h
//  Demo
//
//  Created by Fabio Pelosin on 16/10/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IRFTableView;

@interface IRFAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *searchTextField;
@property (weak) IBOutlet IRFTableView *tableView;
@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSTextField *urlLabel;
@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

@end
