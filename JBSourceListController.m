    //
    //  JBSourceListController.m
    //  Servers
    //
    //  Created by Jonathan Buys on 1/14/11.
    //  Copyright 2011 Farmdog Software. All rights reserved.
    //
    // In 2017 I switched away from PXSourceList to the standard Apple
    // NSOutlineView. This file got too unweildy, so I split it into
    // JBOutlineViewController. Now this file controls creating the
    // smart folders, and the other file controls everything else.
    // I'll probably have to swap over everything at some point. 

#import "JBSourceListController.h"
#import "SourceListItem.h"

#define DEFAULT_PREDICATE @"hostName CONTAINS[cd] '' AND urlScheme CONTAINS[cd] ''" 
#define NSPERT NSPredicateEditorRowTemplate

@implementation JBSourceListController



- (void)dealloc
{
//    [sourceListItems release];
	[smartPredicateForEditor release];
	[super dealloc];
}

#pragma mark -
#pragma mark IB Actions


- (IBAction)openEditor:(id)sender
{
	[textValidator setButtonOKBoolNO:nil];
    
	
	NSPERT * template = [[NSPERT alloc] initWithLeftExpressions:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"hostName"]] 
								   rightExpressionAttributeType:NSStringAttributeType
													   modifier:NSDirectPredicateModifier
													  operators:[NSArray arrayWithObject:
																 [NSNumber numberWithUnsignedInteger:NSContainsPredicateOperatorType]]
														options:(NSCaseInsensitivePredicateOption|NSDiacriticInsensitivePredicateOption)];
    
	NSMutableArray * templates = [[myPredicateEditor rowTemplates] mutableCopy];
	[templates addObject:template];
	[template release];
	[myPredicateEditor setRowTemplates:templates];
	[templates release];
	[myPredicateEditor setObjectValue:[NSPredicate predicateWithFormat:DEFAULT_PREDICATE]];
	
	[smartFolderNameTextView setStringValue:@""];
    
    NSString *createString = NSLocalizedString(@"Create", nil);

	[smartOKButton setTitle:createString];
	
    NSString *newSmartFolder = NSLocalizedString(@"New Smart FOlder", nil);
    [sheet setTitle:newSmartFolder];
	[smartOKButton setEnabled:NO];
    
	[sheet makeKeyAndOrderFront:nil];
	[NSApp runModalForWindow:sheet];
	    
	[smartOKButton setAction:@selector(closeEditor:)];
}

- (IBAction)closeEditor:(id)sender
{
	NSPredicate *pred = [myPredicateEditor objectValue];
    
	[NSApp endSheet:sheet];
	[sheet orderOut:sender];
    
	[self createSmartList:pred named:[smartFolderNameTextView stringValue]];
	[bookmarkListArrayController setFetchPredicate:pred];
}

- (IBAction)cancelNewSmartFolder:(id)sender
{
	[NSApp endSheet:sheet];
	[sheet orderOut:sender];
	
}


- (IBAction)deleteSmartFolder:(id)sender
{
        // First find out where we clicked...
//	NSIndexSet *rows = [sourceList selectedRowIndexes];
//	NSString *title = [[sourceList itemAtRow:[rows firstIndex]] title];
    
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
//	NSString *areYouSure = NSLocalizedString(@"ConfirmDeleteSmartFolder", nil);
	NSString *confirmInformation = NSLocalizedString(@"ConfirmDeleteInformation", nil);
//	NSString *somethingWentWrong = NSLocalizedString(@"SomethingWentWrong", nil);
//	NSString *somethingWentWrongInfo = NSLocalizedString(@"SomethingWentWrongInfo", nil);
	NSString *okString = NSLocalizedString(@"OK", nil);
	NSString *cancelString = NSLocalizedString(@"Cancel", nil);	
    
	NSAlert* alert = [NSAlert new];
	
	[alert setInformativeText: confirmInformation];
	
//	[alert setMessageText: [NSString stringWithFormat: @"%@ %@",areYouSure, title]];
	[alert addButtonWithTitle:okString];
	[alert addButtonWithTitle:cancelString];
	[alert setShowsSuppressionButton:YES];
	[alert setAlertStyle:NSAlertStyleCritical];
	
	if ([alert runModal] == NSAlertFirstButtonReturn) 
	{
            // OK clicked, delete the record
//		if ([self deleteSelectedSmartFolder:rows]) 
//		{
//			NSLog(@"Smart Folder %@ Deleted", rows);
//		} else {
//			
//			NSAlert* errorAlert = [NSAlert new];
//			[errorAlert setInformativeText: somethingWentWrongInfo];
//			[errorAlert setMessageText: [NSString stringWithFormat: @"%@",somethingWentWrong]];
//			[errorAlert addButtonWithTitle:okString];
//			[errorAlert addButtonWithTitle:cancelString];
//			[errorAlert setShowsSuppressionButton:NO];
//			[errorAlert setAlertStyle:NSCriticalAlertStyle];
//			
//			
//                // I know, this doesn't reall do anything
//                // TODO: Make this do something meaningful.
//			if ([errorAlert runModal] == NSAlertFirstButtonReturn) 
//			{
//				[errorAlert release];
//			} else {
//				[errorAlert release];
//			}
//		}
	}
	
    if ([[alert suppressionButton] state] == NSControlStateValueOn) {
		[alert release];
            // Suppress this alert from now on.
		[defaults setBool:YES forKey:@"jbConfirmDeleteSmartKey"];
		
	} else {
		[alert release];
	}
	
//	areYouSure = nil;
//	somethingWentWrongInfo = nil;
//	somethingWentWrong = nil;
	okString = nil;
	cancelString = nil;
	
	
}

- (IBAction)editSmartFolder:(id)sender
{

//	NSIndexSet *rows = [sourceList selectedRowIndexes];
//	NSString *title = [[sourceList itemAtRow:[rows firstIndex]] title];
//	SourceListItem *selectedSmartListItem = [sourceList itemAtRow:[rows firstIndex]];
	
//	if ([[selectedSmartListItem identifier] isEqualToString:@"smartPredicate"])
//	{
//            // Get the predicate
//		
//		NSPredicate *selectedSmartListPredicate = [selectedSmartListItem smartPredicate];
//		
//		[myPredicateEditor setObjectValue:selectedSmartListPredicate];
//		
//            // Set the name of the folder
//		[smartFolderNameTextView setStringValue:title];
//		[smartOKButton setTitleWithMnemonic:@"Change"];
//		[smartOKButton setAction:@selector(finishEditSmartFolder:)];
//		[sheet setTitle:title];
//        
//		[sheet makeKeyAndOrderFront:nil];
//		[NSApp runModalForWindow:sheet];
//        
//		[self predicateEditorChanged:self];
//		
//	}
	
}


- (IBAction)finishEditSmartFolder:(id)sender
{
//	NSIndexSet *rows = [sourceList selectedRowIndexes];
//	[[sourceList itemAtRow:[rows firstIndex]] setValue:[myPredicateEditor objectValue] forKey:@"smartPredicate"];
//	[[sourceList itemAtRow:[rows firstIndex]] setValue:[smartFolderNameTextView stringValue] forKey:@"title"];
//	[bookmarkListArrayController setFetchPredicate:[myPredicateEditor objectValue]];
//	[NSApp endSheet:sheet];
//	[sheet orderOut:sender];
    
}

- (IBAction)saveSearch:(id)sender
{
	NSString *rawPredicate = @"hostName contains[cd] '$value' OR url contains '$value'";
	NSString *searchTerm = [searchField stringValue];
	NSString *savePredicateString = [rawPredicate stringByReplacingOccurrencesOfString:@"$value" withString:searchTerm];
	NSPredicate *savePredicate = [NSPredicate predicateWithFormat:savePredicateString];
	
	[self createSmartList:savePredicate named:searchTerm];
    
}



    // -------------------------------------------------------------------------------
    //	predicateEditorChanged:sender
    //
    //  This method gets called whenever the predicate editor changes.
    //	It is the action of our predicate editor and the single plate for all our updates.
    //	
    //	We need to do potentially three things:
    //		1) Fire off a search if the user hits enter.
    //		2) Add some rows if the user deleted all of them, so the user isn't left without any rows.
    //		3) Resize the window if the number of rows changed (the user hit + or -).
    // -------------------------------------------------------------------------------
- (IBAction)predicateEditorChanged:(id)sender
{
        // if the user deleted the first row, then add it again - no sense leaving the user with no rows
    if ([myPredicateEditor numberOfRows] == 0)
		[myPredicateEditor addRow:self];

        // get the new number of rows, which tells us the needed change in height,
        // note that we can't just get the view frame, because it's currently animating - this method is called before the animation is finished.
    NSInteger newRowCount = [myPredicateEditor numberOfRows];
    
        // if there's no change in row count, there's no need to resize anything
    
    if (newRowCount == previousRowCount)
		return;
    
        // The autoresizing masks, by default, allows the NSTableView to grow and keeps the predicate editor fixed.
        // We need to temporarily grow the predicate editor, and keep the NSTableView fixed, so we have to change the autoresizing masks.
        // Save off the old ones; we'll restore them after changing the window frame.
        //	NSScrollView *tableScrollView = [myTableView enclosingScrollView];
        //	NSUInteger oldOutlineViewMask = [tableScrollView autoresizingMask];
    
    NSScrollView *predicateEditorScrollView = [myPredicateEditor enclosingScrollView];
    NSUInteger oldPredicateEditorViewMask = [predicateEditorScrollView autoresizingMask];
    
        //	[tableScrollView setAutoresizingMask:NSViewWidthSizable | NSViewMaxYMargin];
    [predicateEditorScrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
        // determine if we need to grow or shrink the window
    BOOL growing = (newRowCount > previousRowCount);
    
        // if growing, figure out by how much.  Sizes must contain nonnegative values, which is why we avoid negative floats here.
    CGFloat heightDifference = fabs([myPredicateEditor rowHeight] * (newRowCount - previousRowCount));
    
        // convert the size to window coordinates -
        // if we didn't do this, we would break under scale factors other than 1.
        // We don't care about the horizontal dimension, so leave that as 0.
        //
    NSSize sizeChange = [myPredicateEditor convertSize:NSMakeSize(0, heightDifference) toView:nil];
    
        // offset our status view
        //	NSRect frame = [progressView frame];
        //	[progressView setFrameOrigin: NSMakePoint(frame.origin.x, frame.origin.y - [predicateEditor rowHeight] * (newRowCount - previousRowCount))];
	
        // change the window frame size:
        // - if we're growing, the height goes up and the origin goes down (corresponding to growing down).
        // - if we're shrinking, the height goes down and the origin goes up.
    NSRect windowFrame = [sheet frame];
    
    windowFrame.size.height += growing ? sizeChange.height : -sizeChange.height;
    
    windowFrame.origin.y -= growing ? sizeChange.height : -sizeChange.height;
    
    [sheet setFrame:windowFrame display:YES animate:YES];
    
        // restore the autoresizing mask
        //	[tableScrollView setAutoresizingMask:oldOutlineViewMask];
    [predicateEditorScrollView setAutoresizingMask:oldPredicateEditorViewMask];
    
    previousRowCount = newRowCount;	// save our new row count
    
}



#pragma mark -
#pragma mark Void Methods

- (void)createSmartList:(NSPredicate *)passedSmartPredicate named:(NSString *) newSmartFolderName
{
        // Undo

    SourceListItem *newSmartFolder = [SourceListItem itemWithTitle:newSmartFolderName identifier:@"smartPredicate"];
    [newSmartFolder setValue:passedSmartPredicate forKey:@"smartPredicate"];


    [newSmartFolder setIcon:[NSImage imageNamed: @"NSFolderSmart"]];


    if ([sourceListItems count] > 1)
    {
        NSMutableArray *currentKids = [NSMutableArray arrayWithArray:[[sourceListItems objectAtIndex:1] children]];
        [currentKids addObject:newSmartFolder];
        [[sourceListItems objectAtIndex:1] setChildren:currentKids];
    } else {
        SourceListItem *smartFolderParent = [SourceListItem itemWithTitle:@"Smart Folders" identifier:@"smartFolderParent"];
        [smartFolderParent setChildren:[NSMutableArray arrayWithObjects:newSmartFolder, nil]];
        [sourceListItems addObject:smartFolderParent];
    }


//    [sourceList reloadData];

    [bookmarkListTableView reloadData];
}



- (BOOL)deleteSelectedSmartFolder:(NSIndexSet *)selectedSmartFolderSet
{
//    NSMutableArray *currentKids = [NSMutableArray arrayWithArray:[[sourceListItems objectAtIndex:1] children]];
//    NSUndoManager *undo = [self undoManager];
//    
////    [[undo prepareWithInvocationTarget:self] createSmartList:[tempSmartListItem smartPredicate] named:[tempSmartListItem title]];
//    
//    if (![undo isUndoing]) 
//    {
//        NSString *deleteSmartFolder = NSLocalizedString(@"Delete Smart Folder", nil);
//
//        [undo setActionName:deleteSmartFolder];
//    }
//    
//        //NSLog(@"itemAtRow: %@", [[sourceList itemAtRow:[selectedIndexes firstIndex]] title]);
//    
//        // Ok, let's get rid of it
////    [currentKids removeObject:[sourceList itemAtRow:[selectedSmartFolderSet firstIndex]]];
//    
//        // Do we even need the Smart Folders list now?
//    if ([currentKids count] == 0) 
//    {
//        [sourceListItems removeObjectAtIndex:1];
//    } else {
//        [[sourceListItems objectAtIndex:1] setChildren:currentKids];
//    }
    
        // Finally, let's update the sourceList
//	[sourceList reloadData];
    
	return YES;
	
}

- (void)showVNCLibary:(BOOL)option
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:option forKey:@"showVncLib"];
    
	if (option) 
	{
            //	NSLog(@"Show VNC Lib");
		
//        SourceListItem *vncBookmarks = [SourceListItem itemWithTitle:@"VNC Connections" identifier:@"vncBookmarks"];
//        [vncBookmarks setIcon:[NSImage imageNamed:@"box.png"]];
//
//        NSMutableArray *libraries = [NSMutableArray arrayWithArray:[[sourceListItems objectAtIndex:0] children]];
//        [libraries addObject:vncBookmarks];
//
//        [[sourceListItems objectAtIndex:0] setChildren:libraries];
//		[sourceList reloadData];
        
        
	} else {
		
//        NSMutableArray *libraries = [NSMutableArray arrayWithArray:[[sourceListItems objectAtIndex:0] children]];
//
//        SourceListItem *holderItem = [[[SourceListItem alloc] init] autorelease];
//        for (SourceListItem *checkItem in libraries)
//        {
//            if ([[checkItem identifier] isEqualToString:@"vncBookmarks"])
//            {
//                holderItem = checkItem;
//            }
//        }
//
//        [libraries removeObject:holderItem];
//
//
//        [[sourceListItems objectAtIndex:0] setChildren:libraries];
//		[sourceList reloadData];
		
	}
}

- (void)showSSHLibary:(BOOL)option
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:option forKey:@"showSecureShellLib"];
    
    
	if (option) 
	{
            //	NSLog(@"Show SSH Lib");
//        SourceListItem *sshBookmarks = [SourceListItem itemWithTitle:@"Secure Shell" identifier:@"sshBookmarks"];
//        [sshBookmarks setIcon:[NSImage imageNamed:@"box.png"]];
//
//        NSMutableArray *libraries = [NSMutableArray arrayWithArray:[[sourceListItems objectAtIndex:0] children]];
//        [libraries addObject:sshBookmarks];
//
//        [[sourceListItems objectAtIndex:0] setChildren:libraries];
//		[sourceList reloadData];
		
	} else {
            //NSLog(@"Hide SSH Lib");
//        NSMutableArray *libraries = [NSMutableArray arrayWithArray:[[sourceListItems objectAtIndex:0] children]];
//
//        SourceListItem *holderItem = [[[SourceListItem alloc] init] autorelease];
//        for (SourceListItem *checkItem in libraries)
//        {
//            if ([[checkItem identifier] isEqualToString:@"sshBookmarks"])
//            {
//                holderItem = checkItem;
//            }
//        }
//
//        [libraries removeObject:holderItem];
//
//            //    NSLog(@"vnc: %@", [[sourceList itemAtRow:2] title]);
//
//
//        [[sourceListItems objectAtIndex:0] setChildren:libraries];
//		[sourceList reloadData];
		
	}	
}

- (void)showFTPLibary:(BOOL)option
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:option forKey:@"showFtpLib"];
    
	if (option) 
	{
            //	NSLog(@"Show FTP Lib");
		
//        SourceListItem *ftpBookmarks = [SourceListItem itemWithTitle:@"FTP Servers" identifier:@"ftpBookmarks"];
//        [ftpBookmarks setIcon:[NSImage imageNamed:@"box.png"]];
//
//        NSMutableArray *libraries = [NSMutableArray arrayWithArray:[[sourceListItems objectAtIndex:0] children]];
//        [libraries addObject:ftpBookmarks];
//
//        [[sourceListItems objectAtIndex:0] setChildren:libraries];
//		[sourceList reloadData];
		
	} else {
		
		
            //NSLog(@"Hide FTP Lib");
		
//        NSMutableArray *libraries = [NSMutableArray arrayWithArray:[[sourceListItems objectAtIndex:0] children]];
//        SourceListItem *holderItem = [[[SourceListItem alloc] init] autorelease];
//
//        for (SourceListItem *checkItem in libraries)
//        {
//            if ([[checkItem identifier] isEqualToString:@"ftpBookmarks"])
//            {
//                holderItem = checkItem;
//            }
//        }
//        [libraries removeObject:holderItem];
//
//
//        [[sourceListItems objectAtIndex:0] setChildren:libraries];
//		[sourceList reloadData];
		
	}	
}

- (void)showWebLibary:(BOOL)option
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:option forKey:@"showWebAppsLib"];
    
	if (option) 
	{
            //	NSLog(@"Show Web Lib");
		
//        SourceListItem *httpBookmarks = [SourceListItem itemWithTitle:@"Web Apps" identifier:@"httpBookmarks"];
//        [httpBookmarks setIcon:[NSImage imageNamed:@"box.png"]];
//
//        NSMutableArray *libraries = [NSMutableArray arrayWithArray:[[sourceListItems objectAtIndex:0] children]];
//        [libraries addObject:httpBookmarks];
//
//        [[sourceListItems objectAtIndex:0] setChildren:libraries];
//		[sourceList reloadData];
		
	} else {
		
//        NSMutableArray *libraries = [NSMutableArray arrayWithArray:[[sourceListItems objectAtIndex:0] children]];
//        SourceListItem *holderItem = [[[SourceListItem alloc] init] autorelease];
//
//        for (SourceListItem *checkItem in libraries)
//        {
//            if ([[checkItem identifier] isEqualToString:@"httpBookmarks"])
//            {
//                holderItem = checkItem;
//            }
//        }
//        [libraries removeObject:holderItem];
//
//
//        [[sourceListItems objectAtIndex:0] setChildren:libraries];
//		[sourceList reloadData];
		
		
	}	
}


#pragma mark -
#pragma mark Undo


- (NSUndoManager *)undoManager 
{
	return [mainWindow undoManager];
}

@end
