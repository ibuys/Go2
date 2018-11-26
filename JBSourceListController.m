    //
    //  JBSourceListController.m
    //  Servers
    //
    //  Created by Jonathan Buys on 1/14/11.
    //  Copyright 2011 Farmdog Software. All rights reserved.
    //

#import "JBSourceListController.h"
#import "SourceListItem.h"

#define DEFAULT_PREDICATE @"hostName CONTAINS[cd] '' AND urlScheme CONTAINS[cd] ''" 
#define NSPERT NSPredicateEditorRowTemplate

@implementation JBSourceListController

- (id)init
{
	self = [super init];
	
	if (self != nil) 
	{
		
		smartPredicateForEditor = [[NSPredicate predicateWithFormat:DEFAULT_PREDICATE] retain];
		
		[[NSNotificationCenter defaultCenter] 
		 addObserver: self
		 selector: @selector(applicationWillTerminate:)
		 name: NSApplicationWillTerminateNotification
         object: nil];	
        
        
//		[[NSNotificationCenter defaultCenter] 
//		 addObserver: self
//		 selector: @selector(liveUpdateView:)
//		 name: NSControlTextDidChangeNotification
//         object: myPredicateEditor];	
        
        
	}
	return self;
}



- (void)awakeFromNib
{
	sourceListItems = [[NSMutableArray alloc] init];
    
	NSString *go2_smart_data_path = [[self applicationSupportFolder] stringByAppendingPathComponent:@"go2_smartP_data"];
	NSFileManager *myDefaultManager = [[NSFileManager alloc] init];
	
	if ([myDefaultManager fileExistsAtPath:go2_smart_data_path])
	{
		NSData *data = [NSData dataWithContentsOfFile:go2_smart_data_path];
		[sourceListItems addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
		
	} else {
		
            // Set up the "Library" parent and children
		SourceListItem *mainLibrary = [SourceListItem itemWithTitle:@"Library" identifier:@"mainLibrary"];
		SourceListItem *sshBookmarks = [SourceListItem itemWithTitle:@"Secure Shell" identifier:@"sshBookmarks"];
		SourceListItem *httpBookmarks = [SourceListItem itemWithTitle:@"Web Apps" identifier:@"httpBookmarks"];
		SourceListItem *vncBookmarks = [SourceListItem itemWithTitle:@"VNC Connections" identifier:@"vncBookmarks"];
		SourceListItem *ftpBookmarks = [SourceListItem itemWithTitle:@"FTP Servers" identifier:@"ftpBookmarks"];
		SourceListItem *unsortedBookmarks = [SourceListItem itemWithTitle:@"All Bookmarks" identifier:@"unsortedBookmarks"];
		
		[sshBookmarks setIcon:[NSImage imageNamed:@"box.png"]];
		[httpBookmarks setIcon:[NSImage imageNamed:@"box.png"]];
		[vncBookmarks setIcon:[NSImage imageNamed:@"box.png"]];
		[ftpBookmarks setIcon:[NSImage imageNamed:@"box.png"]];
		[unsortedBookmarks setIcon:[NSImage imageNamed:@"box.png"]];
		
		
		[mainLibrary setChildren:[NSMutableArray arrayWithObjects:unsortedBookmarks, sshBookmarks, httpBookmarks, vncBookmarks, ftpBookmarks, nil]];
		[sourceListItems addObject:mainLibrary];
	}
	
	[myDefaultManager release];
	
        // All done, display the data
//	[sourceList reloadData];
//    [sourceList registerForDraggedTypes:[NSArray arrayWithObject:@"SourceListPboardType"]];
//	[sourceList setDraggingSourceOperationMask:NSDragOperationEvery forLocal:YES];
//    [sourceList setDraggingSourceOperationMask:NSDragOperationEvery forLocal:NO];
//    
//	[sourceList setTarget:self];
//	[sourceList setDoubleAction:@selector(editSmartFolder:)];
    
        // setup the nspredicateeditor
	previousRowCount = 3;
	[[myPredicateEditor enclosingScrollView] setHasVerticalScroller:YES];
    
//    NSString *imageName;
//    NSImage *image1;
//    
//    imageName = [[NSBundle mainBundle] pathForResource:@"texture" ofType:@"png"];
//    image1 = [[NSImage alloc] initWithContentsOfFile:imageName];	// note no need to retain since we call "alloc"
//
//    [sourceList setBackgroundImage:image1];
//    [image1 release];
}


- (BOOL)allowsVibrancy {
    return YES;
}



- (void)dealloc
{
	[sourceListItems release];
	[smartPredicateForEditor release];
	[super dealloc];
}


- (NSString *)applicationSupportFolder
{
	return [[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
												 NSUserDomainMask, YES) objectAtIndex:0] 
			stringByAppendingPathComponent:[[NSProcessInfo processInfo]
											processName]];
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
	
	
//	NSIndexSet *rows = [sourceList selectedRowIndexes];
//	NSInteger row = [rows firstIndex];
//    
//        // figure out if the row that was just clicked on is currently selected
//	
//	if (row > 0)
//	{
////		SourceListItem *selectedSmartListItem = [sourceList itemAtRow:[rows firstIndex]];
//		NSPredicate *selectedSmartListPredicate = [selectedSmartListItem smartPredicate];
//		[bookmarkListArrayController setFetchPredicate:selectedSmartListPredicate];
//		
//	} else {
//		
//		[bookmarkListArrayController setFetchPredicate:nil];
//	}	
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
	
	if ([[alert suppressionButton] state] == NSOnState) {
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
	
	
//	[sourceList reloadData];
    
    [bookmarkListTableView reloadData];	
}



- (BOOL)deleteSelectedSmartFolder:(NSIndexSet *)selectedSmartFolderSet
{
	NSMutableArray *currentKids = [NSMutableArray arrayWithArray:[[sourceListItems objectAtIndex:1] children]];
    
//	SourceListItem *tempSmartListItem = [sourceList itemAtRow:[selectedSmartFolderSet firstIndex]];
	
	
        // Undo
        // - (void)createSmartList:(NSPredicate *)passedSmartPredicate named:(NSString *) newSmartFolderName
    
	NSUndoManager *undo = [self undoManager];
	
//	[[undo prepareWithInvocationTarget:self] createSmartList:[tempSmartListItem smartPredicate] named:[tempSmartListItem title]];
	
	if (![undo isUndoing]) 
	{
        NSString *deleteSmartFolder = NSLocalizedString(@"Delete Smart Folder", nil);

		[undo setActionName:deleteSmartFolder];
	}
    
        //NSLog(@"itemAtRow: %@", [[sourceList itemAtRow:[selectedIndexes firstIndex]] title]);
	
        // Ok, let's get rid of it
//	[currentKids removeObject:[sourceList itemAtRow:[selectedSmartFolderSet firstIndex]]];
	
        // Do we even need the Smart Folders list now?
	if ([currentKids count] == 0) 
	{
		[sourceListItems removeObjectAtIndex:1];
	} else {
		[[sourceListItems objectAtIndex:1] setChildren:currentKids];
	}
    
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
		
		SourceListItem *vncBookmarks = [SourceListItem itemWithTitle:@"VNC Connections" identifier:@"vncBookmarks"];
		[vncBookmarks setIcon:[NSImage imageNamed:@"box.png"]];
		
		NSMutableArray *libraries = [NSMutableArray arrayWithArray:[[sourceListItems objectAtIndex:0] children]];
		[libraries addObject:vncBookmarks];
		
		[[sourceListItems objectAtIndex:0] setChildren:libraries];
//		[sourceList reloadData];
        
        
	} else {
		
		NSMutableArray *libraries = [NSMutableArray arrayWithArray:[[sourceListItems objectAtIndex:0] children]];
		
		SourceListItem *holderItem = [[[SourceListItem alloc] init] autorelease];
		for (SourceListItem *checkItem in libraries) 
		{
			if ([[checkItem identifier] isEqualToString:@"vncBookmarks"]) 
			{
				holderItem = checkItem;
			}
		}
		
		[libraries removeObject:holderItem];
		
		
		[[sourceListItems objectAtIndex:0] setChildren:libraries];
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
		SourceListItem *sshBookmarks = [SourceListItem itemWithTitle:@"Secure Shell" identifier:@"sshBookmarks"];
		[sshBookmarks setIcon:[NSImage imageNamed:@"box.png"]];
		
		NSMutableArray *libraries = [NSMutableArray arrayWithArray:[[sourceListItems objectAtIndex:0] children]];
		[libraries addObject:sshBookmarks];
		
		[[sourceListItems objectAtIndex:0] setChildren:libraries];
//		[sourceList reloadData];
		
	} else {
            //NSLog(@"Hide SSH Lib");
		NSMutableArray *libraries = [NSMutableArray arrayWithArray:[[sourceListItems objectAtIndex:0] children]];
		
		SourceListItem *holderItem = [[[SourceListItem alloc] init] autorelease];
		for (SourceListItem *checkItem in libraries) 
		{
			if ([[checkItem identifier] isEqualToString:@"sshBookmarks"]) 
			{
				holderItem = checkItem;
			}
		}
		
		[libraries removeObject:holderItem];
		
            //	NSLog(@"vnc: %@", [[sourceList itemAtRow:2] title]);
        
		
		[[sourceListItems objectAtIndex:0] setChildren:libraries];
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
		
		SourceListItem *ftpBookmarks = [SourceListItem itemWithTitle:@"FTP Servers" identifier:@"ftpBookmarks"];
		[ftpBookmarks setIcon:[NSImage imageNamed:@"box.png"]];
		
		NSMutableArray *libraries = [NSMutableArray arrayWithArray:[[sourceListItems objectAtIndex:0] children]];
		[libraries addObject:ftpBookmarks];
		
		[[sourceListItems objectAtIndex:0] setChildren:libraries];
//		[sourceList reloadData];
		
	} else {
		
		
            //NSLog(@"Hide FTP Lib");
		
		NSMutableArray *libraries = [NSMutableArray arrayWithArray:[[sourceListItems objectAtIndex:0] children]];
		SourceListItem *holderItem = [[[SourceListItem alloc] init] autorelease];
        
		for (SourceListItem *checkItem in libraries) 
		{
			if ([[checkItem identifier] isEqualToString:@"ftpBookmarks"]) 
			{
				holderItem = checkItem;
			}
		}
		[libraries removeObject:holderItem];
        
        
		[[sourceListItems objectAtIndex:0] setChildren:libraries];
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
		
		SourceListItem *httpBookmarks = [SourceListItem itemWithTitle:@"Web Apps" identifier:@"httpBookmarks"];
		[httpBookmarks setIcon:[NSImage imageNamed:@"box.png"]];
		
		NSMutableArray *libraries = [NSMutableArray arrayWithArray:[[sourceListItems objectAtIndex:0] children]];
		[libraries addObject:httpBookmarks];
		
		[[sourceListItems objectAtIndex:0] setChildren:libraries];
//		[sourceList reloadData];
		
	} else {
		
		NSMutableArray *libraries = [NSMutableArray arrayWithArray:[[sourceListItems objectAtIndex:0] children]];
		SourceListItem *holderItem = [[[SourceListItem alloc] init] autorelease];
        
		for (SourceListItem *checkItem in libraries) 
		{
			if ([[checkItem identifier] isEqualToString:@"httpBookmarks"]) 
			{
				holderItem = checkItem;
			}
		}
		[libraries removeObject:holderItem];
		
		
		[[sourceListItems objectAtIndex:0] setChildren:libraries];
//		[sourceList reloadData];
		
		
	}	
}


#pragma mark -
#pragma mark Undo


- (NSUndoManager *)undoManager 
{
	return [mainWindow undoManager];
}

#pragma mark -
#pragma mark Source List Data Source Methods

//- (NSUInteger)sourceList:(PXSourceList*)sourceList numberOfChildrenOfItem:(id)item
//{
//        //Works the same way as the NSOutlineView data source: `nil` means a parent item
//	if(item==nil) {
//		return [sourceListItems count];
//	}
//	else {
//		return [[item children] count];
//	}
//}
//
//
//- (id)sourceList:(PXSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item
//{
//        //Works the same way as the NSOutlineView data source: `nil` means a parent item
//	if(item==nil) {
//		return [sourceListItems objectAtIndex:index];
//	}
//	else {
//		return [[item children] objectAtIndex:index];
//	}
//}
//
//
//- (id)sourceList:(PXSourceList*)aSourceList objectValueForItem:(id)item
//{
//	return [item title];
//}
//
//
//- (void)sourceList:(PXSourceList*)aSourceList setObjectValue:(id)object forItem:(id)item
//{
//	[item setTitle:object];
//}
//
//
//- (BOOL)sourceList:(PXSourceList*)aSourceList isItemExpandable:(id)item
//{
//	return [item hasChildren];
//}
//
//
//- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasBadge:(id)item
//{
//	return [item hasBadge];
//}
//
//
//- (NSInteger)sourceList:(PXSourceList*)aSourceList badgeValueForItem:(id)item
//{
//	return [item badgeValue];
//}
//
//
//- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasIcon:(id)item
//{
//	return [item hasIcon];
//}
//
//
//- (NSImage*)sourceList:(PXSourceList*)aSourceList iconForItem:(id)item
//{
//	return [item icon];
//}
//
//- (NSMenu*)sourceList:(PXSourceList*)aSourceList menuForEvent:(NSEvent*)theEvent item:(id)item
//{
//        //  NSLog(@"This is getting called");
//	if ([theEvent type] == NSRightMouseDown || ([theEvent type] == NSLeftMouseDown && ([theEvent modifierFlags] & NSControlKeyMask) == NSControlKeyMask)) {
//		NSMenu * m = [[NSMenu alloc] init];
//		if (item != nil) {
//			[m addItemWithTitle:[item title] action:nil keyEquivalent:@""];
//		} else {
//            NSString *clickedOutside = NSLocalizedString(@"clicked outside", nil);
//
//			[m addItemWithTitle:clickedOutside action:nil keyEquivalent:@""];
//		}
//		return [m autorelease];
//	}
//	return nil;
//}
//
//#pragma mark -
//#pragma mark Source List Delegate Methods
//
//- (BOOL)sourceList:(PXSourceList*)aSourceList isGroupAlwaysExpanded:(id)group
//{
//	return YES;
//}
//
//
//- (void)sourceListSelectionDidChange:(NSNotification *)notification
//{    
//    
//	NSIndexSet *selectedIndexes = [sourceList selectedRowIndexes];
//	
//        //Set the label text to represent the new selection
//	if([selectedIndexes count]>1)
//	{
//		
//	} else if([selectedIndexes count]==1) {
//		
//		
//		NSString *identifier = [[sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
//        
//        if ([identifier isEqualToString:@"sshBookmarks"]) 
//        {
//			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url CONTAINS[cd] 'ssh'"];
//            [bookmarkListArrayController setFetchPredicate:predicate];
//			[bookmarkListTableView reloadData];
//        }
//        
//        if ([identifier isEqualToString:@"httpBookmarks"]) 
//        {
//			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url CONTAINS[cd] 'http'"];
//			[bookmarkListArrayController setFetchPredicate:predicate];
//			[bookmarkListTableView reloadData];
//        }
//		
//		if ([identifier isEqualToString:@"vncBookmarks"]) 
//        {
//			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url CONTAINS[cd] 'vnc'"];
//            [bookmarkListArrayController setFetchPredicate:predicate];
//			[bookmarkListTableView reloadData];
//        }
//		
//		if ([identifier isEqualToString:@"ftpBookmarks"]) 
//        {
//			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url CONTAINS[cd] 'ftp'"];
//            [bookmarkListArrayController setFetchPredicate:predicate];
//            [bookmarkListTableView reloadData];
//        }
//		
//        
//        if ([identifier isEqualToString:@"unsortedBookmarks"]) 
//        {
//            [bookmarkListArrayController setFetchPredicate:nil];
//
//			[bookmarkListTableView reloadData];
//            
//        }
//        
//		if ([identifier isEqualToString:@"smartPredicate"])
//		{
//			NSPredicate *currentSmartPredicate = [[sourceList itemAtRow:[selectedIndexes firstIndex]] smartPredicate];
//            [bookmarkListArrayController setFetchPredicate:currentSmartPredicate];
//		}
//	}
//	else {
//	}
//}
//
//
//
//
//#pragma mark -
//#pragma mark Observer Methods
//
//
//- (void)liveUpdateView:(NSNotification *)passedPredicateEditor
//{
//    
//    if ([passedPredicateEditor object] == myPredicateEditor)
//    {
//        [bookmarkListArrayController setFetchPredicate:[myPredicateEditor objectValue]];
//        [bookmarkListTableView reloadData];
//        [sheet recalculateKeyViewLoop];
//    }
//}
//
//
//
//- (void)applicationWillTerminate:(NSNotification *)aNotification
//{
//	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:sourceListItems];
//	NSString *go2_name_data_path = [[self applicationSupportFolder] stringByAppendingPathComponent:@"go2_smartP_data"];
//    
//	if ([data writeToFile:go2_name_data_path atomically:YES]) 
//	{
//            //NSLog(@"data saved!");
//	} else {
//		NSLog(@"data not saved...");
//	}
//}
//
//
//
//#pragma mark -
//#pragma mark Drag and Drop support
//
//- (BOOL)sourceList:(PXSourceList *)aSourceList writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard {
//    draggedItems = items; // Don't retain since this is just holding temporaral drag information, and it is only used during a drag!  We could put this in the pboard actually.
//    
//    [pboard declareTypes:[NSArray arrayWithObject:@"SourceListPboardType"] owner:self];
//    [pboard setData:[NSData data] forType:@"SourceListPboardType"]; // No data required, since we aren't actually moving any information.
//                                                                    //NSLog(@"Called!");
//    return YES;
//}
//
//- (NSDragOperation)sourceList:(PXSourceList *)aSourceList validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)childIndex {
//        // This method validates whether or not the proposal is a valid one.
//        // We start out by assuming that we will do a "generic" drag operation, which means we are accepting the drop. If we return NSDragOperationNone, then we are not accepting the drop.
//    NSDragOperation result = NSDragOperationGeneric;
//	
//        // Check to see what we are proposed to be dropping on
//	SourceListItem *targetItem = item;
//	
//	if (targetItem.hasChildren) {
//		if (childIndex == NSOutlineViewDropOnItemIndex) {
//			result = NSDragOperationNone; // Change to generic to allow dropping directly on group headings.
//		}
//	} else {
//            // The target node is not a container, but a leaf. Refuse the drop.
//		result = NSDragOperationNone;
//	}
//	
//        // Only allow items to be rearranged within the bounds of their group.
//	if (result != NSDragOperationNone) {
//		for (SourceListItem *anItem in draggedItems) 
//        {
//		
//                // Added Dec. 8th, 2011
//            
//            if ([[targetItem title] isEqualTo:@"Library"]) 
//            {
//                    // NSLog(@"Can Not Drag from %@ to %@",[anItem title], [targetItem title]);
//				result = NSDragOperationNone;
//				break;
//			}
//            
//            if ([[anItem title] isEqualTo:@"All Bookmarks"])
//            {
//                result = NSDragOperationNone;
//                break;
//            }
//            
//            
//            if ([[anItem title] isEqualTo:@"Secure Shell"])
//            {
//                result = NSDragOperationNone;
//                break;
//            }
//            
//            
//            if ([[anItem title] isEqualTo:@"FTP Servers"])
//            {
//                result = NSDragOperationNone;
//                break;
//            }
//            
//            
//            
//            if ([[anItem title] isEqualTo:@"Web Apps"])
//            {
//                result = NSDragOperationNone;
//                break;
//            }
//            
//            
//            
//            if ([[anItem title] isEqualTo:@"VNC Connections"])
//            {
//                result = NSDragOperationNone;
//                break;
//            }
//            
//		}
//	}
//	
//        // If we are allowing the drop, we see if we are draggng from ourselves and dropping into a descendent, which wouldn't be allowed...
//	if (result != NSDragOperationNone) {
//		if ([info draggingSource] == sourceList) {
//                // Yup, the drag is originating from ourselves. See if the appropriate drag information is available on the pasteboard
//			if ([[info draggingPasteboard] availableTypeFromArray:[NSArray arrayWithObject:@"SourceListPboardType"]] != nil) {
//				for (SourceListItem *anItem in draggedItems) {
//					if ([[anItem children] containsObject:targetItem] || [anItem isEqualTo:targetItem]) {
//                            // Yup, it is, refuse it.
//						result = NSDragOperationNone;
//						break;
//					}
//				}
//			}
//		}
//	}
//    
//    return result;    
//}
//
//- (BOOL)sourceList:(PXSourceList *)aSourceList acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(NSInteger)childIndex {
//    SourceListItem *targetItem = item;
//	
//        // Determine the parent to insert into and the child index to insert at.
//    if (!targetItem.hasChildren) {
//            // We will be dropping on the item's parent at the target index of this child, plus one
//		SourceListItem *oldTargetItem = targetItem;
//		targetItem = [targetItem parent];
//		childIndex = [[targetItem children] indexOfObject:oldTargetItem] + 1;
//    }
//	else {            
//        if (childIndex == NSOutlineViewDropOnItemIndex) {
//                // Insert it at the start, if we were dropping on it
//            childIndex = 0;
//        }
//    }
//    
//    NSArray *currentDraggedItems = nil;
//        // If the source was ourselves, we use our dragged nodes.
//    if ([info draggingSource] == sourceList && [[info draggingPasteboard] availableTypeFromArray:[NSArray arrayWithObject:@"SourceListPboardType"]] != nil)
//	{
//            // Yup, the drag is originating from ourselves. See if the appropriate drag information is available on the pasteboard
//        currentDraggedItems = draggedItems;
//    }
//	else
//	{
//		return NO;
//	}
//    
//    
//    NSMutableArray *childrenArray = [NSMutableArray arrayWithArray:[targetItem children]];
//        // Go ahead and move things. 
//    for (SourceListItem *anItem in currentDraggedItems) {
//            // Remove the node from its old location
//        NSInteger oldIndex = [childrenArray indexOfObject:anItem];
//        NSInteger newIndex = childIndex;
//        if (oldIndex != NSNotFound) {
//            [childrenArray removeObjectAtIndex:oldIndex];
//            if (childIndex > oldIndex) {
//                newIndex--; // account for the remove
//            }
//        } else {
//                // Remove it from the old parent
//            NSMutableArray *tempChildren = [NSMutableArray arrayWithArray:[[anItem parent] children]];
//			[tempChildren removeObject:anItem];
//			[[anItem parent] setChildren:[NSMutableArray arrayWithArray:tempChildren]];
//        }
//        [childrenArray insertObject:anItem atIndex:newIndex];
//        newIndex++;
//    }
//	[targetItem setChildren:[NSMutableArray arrayWithArray:childrenArray]];
//    
//    [sourceList reloadData];
//    [sourceList expandItem:targetItem];
//    
//        // Return YES to indicate we were successful with the drop. Otherwise, it would slide back the drag image.
//    return YES;
//}
//
//- (SourceListItem *)getTopLevelGroup:(SourceListItem *)targetItem
//{
//	BOOL loop = YES;
//	
//	while (loop) {
//		if ([targetItem parent] != nil)
//			targetItem = [targetItem parent];
//		else
//			loop = NO;
//	}
//	
//	return targetItem;
//}

@end
