//
//  ImportText.h
//  Known Hosts
//
//  Created by Jonathan Buys on 12/12/09.
//  Copyright 2009 B6 Systems Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JBSaveAndLoad.h"

@class JBStatusItemView;

@interface ImportText : NSObject 
{
	IBOutlet NSTableView* tableView;
	IBOutlet NSArrayController *hostsController;
	IBOutlet JBSaveAndLoad *saveManager;
	IBOutlet JBStatusItemView *go2StatusItemView;
    
	NSURL *newURL;
	//NSMutableString *saveString;
}

- (IBAction)import:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)importSafariBookmarks:(id)sender;

- (void)importFromBookmarklet:(NSString *)urlString;


@end
