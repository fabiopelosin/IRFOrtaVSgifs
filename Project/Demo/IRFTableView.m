//
//  IRFTableView.m
//  IRFOrtaVSgifs
//
//  Created by Fabio Pelosin on 17/10/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import "IRFTableView.h"

@implementation IRFTableView

- (void)keyDown:(NSEvent *)event
{

    if (event.keyCode == 36) {
        self.enterKeyBlock();
    } else {
        [super keyDown:event];
    }
}



@end
