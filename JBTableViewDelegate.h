//
//  JBTableViewDelegate.h
//  Go
//
//  Created by Jon Buys on 7/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JBMenuItem.h"
#import "Go2_AppDelegate.h"

@interface JBTableViewDelegate : NSObject
{
	IBOutlet NSTableView *tableView;
	IBOutlet NSSegmentedControl *mainButtons;
	IBOutlet NSTextField *numberOfHostsTextView;
	
	IBOutlet Go2_AppDelegate *myAppDelegate;
    IBOutlet NSArrayController *hostsArrayController;
	
	
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification;
//- (void)textDidEndEditing:(NSNotification *)notification;


@end
