//
//  IRFAppDelegate.m
//  Demo
//
//  Created by Fabio Pelosin on 16/10/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import "IRFAppDelegate.h"
#import "IRFTableView.h"
#import <IRFOrtaVSgifs/IRFOrtaVSgifs.h>
#import <AFNetworking/AFImageRequestOperation.h>

//------------------------------------------------------------------------------

@interface IRFAppDelegate () <NSTableViewDelegate, NSTableViewDataSource>
@property (nonatomic, copy) NSString *currentSearch;
@property (nonatomic, copy) NSArray *gifs;
@property (nonatomic, strong) NSCache *imagesCache;
@property (nonatomic, strong) AFImageRequestOperation *imageOperation;
@end

//------------------------------------------------------------------------------

@implementation IRFAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self setImagesCache:[NSCache new]];
    [self.imagesCache setCountLimit:15];

    [self.imageView setAnimates:TRUE];

    [self.searchTextField setTarget:self];
    [self.searchTextField setAction:@selector(searchTextFieldAction)];
    [self.window makeFirstResponder:self.searchTextField];

    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setAllowsMultipleSelection:NO];
    [self.tableView setAllowsColumnSelection:NO];
    [self.tableView setAllowsEmptySelection:NO];
    [self.tableView sizeToFit];
    [self.tableView setEnterKeyBlock:^{
        // Fix block
        [self tableViewAction];
    }];
}

- (void)setGifs:(NSArray *)gifs {
    _gifs = gifs;
    [self.tableView reloadData];
    [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    [self _selectionDidChange];
}

- (void)searchTextFieldAction {
    if (![self.currentSearch isEqualToString:self.searchTextField.stringValue]) {
        [self _startNewSearch];
    }
    [self.window selectKeyViewFollowingView:self.searchTextField];
}

- (void)tableViewAction {
    IRFGif *gif = [self _selectedGif];
    NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
    [pasteBoard clearContents];
    BOOL success = [pasteBoard writeObjects:[NSArray arrayWithObject:gif.URL]];
    if (success) {

    }
}

//------------------------------------------------------------------------------
#pragma mark - Private Helpers
//------------------------------------------------------------------------------

- (IRFGif*)_selectedGif {
    NSInteger selectedRow = [self.tableView selectedRow];
    if (selectedRow >= 0 && selectedRow < self.gifs.count) {
        IRFGif *gif = [self.gifs objectAtIndex:selectedRow];
        return gif;
    } else {
        return nil;
    }
}

- (void)_selectionDidChange {
    IRFGif *gif = [self _selectedGif];
    if (!gif) {
        return;
    }
    
    [self.imageView setImage:nil];
    [self.titleLabel setStringValue:gif.title];
    [self.urlLabel setStringValue:[gif.URL absoluteString]];

    NSProgressIndicator *progressIndicator = self.progressIndicator;
    NSCache *imagesCache = self.imagesCache;
    NSImageView *imageView = self.imageView;
    NSTextField *urlLabel = self.urlLabel;

    [self.imageOperation cancel];

    if ([self.imagesCache objectForKey:gif.URL]) {
        NSImage *image = [self.imagesCache objectForKey:gif.URL];
        [imageView setImage:image];
        [progressIndicator setHidden:YES];

    } else {
        NSURLRequest *request = [NSURLRequest requestWithURL:gif.URL];
        [progressIndicator setDoubleValue:0];
        [progressIndicator setHidden:NO];
        self.imageOperation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:^NSImage *(NSImage *image) {
            return image;

        } success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSImage *image) {
            [imageView setImage:image];
            [imagesCache setObject:image forKey:gif.URL];
            [progressIndicator setHidden:YES];

        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            if ([error code] != NSURLErrorCancelled) {
                [urlLabel setStringValue:error.localizedDescription];
                NSLog(@"%@", error);
            }
        }];

        [self.imageOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            [progressIndicator setDoubleValue:totalBytesRead];
            [progressIndicator setMaxValue:totalBytesExpectedToRead];
            [progressIndicator setHidden:NO];
        }];
        
        [self.imageOperation start];
    }
}

- (void)_startNewSearch {
    NSString *searchQuery = self.searchTextField.stringValue;
    [self setCurrentSearch:searchQuery];

    if (!searchQuery || [searchQuery isEqualToString:@""]) {
        return;
    }

    IRFGifSearchManager *searchManager = [IRFGifSearchManager new];
    [searchManager searchWithQuery:searchQuery token:nil success:^(NSMutableArray *gifs, NSString *token) {
        [self setGifs:gifs];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}


//------------------------------------------------------------------------------
#pragma mark - NSTableViewDataSource
//------------------------------------------------------------------------------

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.gifs.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
{
    IRFGif *gif = self.gifs[row];
    if ([tableColumn.identifier isEqualToString:@"Title"]) {
        return gif.title;
    } else if ([tableColumn.identifier isEqualToString:@"DownloadsCount"]) {
        return gif.donloadsCount;
    } else if ([tableColumn.identifier isEqualToString:@"Other"]) {
        return gif.score;
    }

    return nil;
}

//------------------------------------------------------------------------------
#pragma mark - NSTableViewDelegate
//------------------------------------------------------------------------------

- (void)tableViewSelectionDidChange:(NSNotification *)notification;
{
    [self _selectionDidChange];
}

@end
