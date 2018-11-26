//
//  JBOutlineViewController.h
//  CloudChain
//
//  Created by Jonathan Buys on 9/6/17.
//  Copyright © 2017 Fall Harvest. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JBValidateTextField.h"

@interface JBOutlineViewController : NSObject <NSOutlineViewDelegate, NSOutlineViewDataSource>
{
    NSMutableArray *sourceListItems;
    IBOutlet NSTableView *bookmarkListTableView;
    IBOutlet NSArrayController *bookmarkListArrayController;
    IBOutlet NSOutlineView *sidebarOutlineView;

    NSPredicate *smartPredicateForEditor;
    IBOutlet NSPredicateEditor *myPredicateEditor;
    IBOutlet JBValidateTextField *textValidator;
    IBOutlet NSButton *smartOKButton;
    IBOutlet NSTextField *smartFolderNameTextView;
    IBOutlet NSWindow *sheet;
    NSInteger previousRowCount;
}

- (void)appDidLaunch;

@end
