//
//  JBQSDelegate.h
//  Go2
//
//  Created by Jonathan Buys on 12/7/11.
//  Copyright (c) 2011 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBQSDelegate : NSObject
{
    IBOutlet NSArrayController *hostsController;

    IBOutlet NSPanel *quickSearchPanel;
    IBOutlet NSImageView *quickSearchImageView;
    IBOutlet NSTextField *quickSearchTextField;
    IBOutlet NSTextField *quickSearchLabel;
    IBOutlet NSTextField *quickSearchURL;
    NSUInteger myInt;
}

//- (void)closeMenu;
- (void)openMenu;
- (void)openBookmark:(NSURL *)url;
- (void)rotateThroughFilteredArray;



@end
