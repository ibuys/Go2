//
//  JBAppController.m
//  Go
//
//  Created by Jon Buys on 7/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JBAppController.h"
#import "JBGetDefaultApps.h"
#import "JBQSDelegate.h"
#import "Go2_AppDelegate.h"

#define GO2_BUNDLE [NSBundle bundleWithIdentifier:@"com.farmdog.go2"]

@implementation JBAppController

- (id)init
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults valueForKey:@"firstLaunch"]) 
	{
		BOOL iconInDock = [[NSUserDefaults standardUserDefaults] boolForKey:@"hideIcon"];
		//NSLog(@"BOOL = %d", iconInDock);
		if (iconInDock) {
			ProcessSerialNumber psn = { 0, kCurrentProcess };
			// display dock icon
			TransformProcessType(&psn, kProcessTransformToForegroundApplication);
		}
		
	} else {
		//NSLog(@"First launch, show the dock icon...");
		ProcessSerialNumber psn = { 0, kCurrentProcess };
		// display dock icon
		TransformProcessType(&psn, kProcessTransformToForegroundApplication);
		[defaults setBool:YES forKey:@"hideIcon"];
	}
	
	[[NSNotificationCenter defaultCenter] 
	 addObserver:self
	 selector:@selector(appDidLaunch:)
	 name: NSApplicationDidFinishLaunchingNotification
	 object: nil];	
	
	return self;
}

- (void)appDidLaunch:(NSNotification *)aNotification
{	
	
	// Get the Defaults
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	// Check to see if this is the first time we've launched or not
	if ([defaults valueForKey:@"firstLaunch"]) 
	{
		
		//	NSLog(@"Not First Launch");
		
            // Register hotkey for menu
//		NSString *str = [defaults valueForKey:@"modValue"];
		
//		globalHotKey = [[PTHotKey alloc] initWithIdentifier:@"SRTest" keyCombo:[PTKeyCombo keyComboWithKeyCode:[defaults integerForKey:@"keyComboCode"] modifiers:[str integerValue]]];
//		[globalHotKey setTarget: self];
//		[globalHotKey setAction: @selector(hitHotKey:)];
//		[[PTHotKeyCenter sharedCenter] registerHotKey: globalHotKey];
//
//
//            // Register hotkey for quick search
//        NSString *strQS = [defaults valueForKey:@"modValueQS"];
//		
//		globalHotKeyQS = [[PTHotKey alloc] initWithIdentifier:@"SRTestQS" keyCombo:[PTKeyCombo keyComboWithKeyCode:[defaults integerForKey:@"keyComboCodeQS"] modifiers:[strQS integerValue]]];
//		[globalHotKeyQS setTarget: self];
//		[globalHotKeyQS setAction: @selector(hitHotKeyQS:)];
//		[[PTHotKeyCenter sharedCenter] registerHotKey: globalHotKeyQS];
        

    
    
    } else {
		NSLog(@"First Launch!");
		
//		ProcessSerialNumber psn = { 0, kCurrentProcess };
//        // display dock icon
//        TransformProcessType(&psn, kProcessTransformToForegroundApplication);
		
		
		
		
		NSURL *newURL = [NSURL URLWithString:@"http://jonathanbuys.com"];
				
		id hostObj = [hostArrayController newObject];
		[hostObj setValue:[newURL absoluteString] forKey:@"url"];
		[hostObj setValue:[newURL host] forKey:@"hostName"];
		[hostObj setValue:[newURL user] forKey:@"userName"];
		[hostObj setValue:[newURL scheme] forKey:@"urlScheme"];
		
		JBGetDefaultApps *getDefaultApps = [[JBGetDefaultApps alloc] init];
		NSURL *defaultAppURL = [getDefaultApps getDefaultApp:[newURL scheme]];
		[getDefaultApps release];
		
		[hostObj setValue:[defaultAppURL path] forKey:@"iconImage"];
		
		[hostArrayController addObject:hostObj];
		[hostObj release];
		[hostListTableView reloadData];
		[urlTextField setStringValue:@""];
		
		newURL = nil;
		getDefaultApps = nil;
		defaultAppURL = nil;

		// Last step, set the bool for surpressing the first launch wizard
		
		BOOL firstLaunch = YES;
		[defaults setBool:firstLaunch forKey:@"firstLaunch"];

	}
	
	if ([defaults valueForKey:@"firstLaunch16"])
	{
		//NSLog(@"Not first launch of Go2 v1.3");
		
	} else {
		
		NSLog(@"First Launch of Go2 v1.6");

		[defaults setBool:YES forKey:@"showSecureShellLib"];
		[defaults setBool:YES forKey:@"showWebAppsLib"];
		[defaults setBool:YES forKey:@"showVncLib"];
		[defaults setBool:YES forKey:@"showFtpLib"];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch16"];
	}

	
	[hostListTableView setTarget:self];
	[hostListTableView setDoubleAction:@selector(connectToHost:)];
	[[segControl cell] setTag:0 forSegment:0];
	[[segControl cell] setTag:1 forSegment:1];
	[[segControl cell] setTag:2 forSegment:2];
	[segControl setTarget:self];
	[segControl setAction:@selector(segControlClicked:)];

	[NSApp activateIgnoringOtherApps:YES];
	[mainWindow makeKeyAndOrderFront:self];
	
}

- (void)showMainWindow:(id)sender {
	// Open main window. Simple.
	[mainWindow showWindow:sender];
}


- (IBAction)segControlClicked:(id)sender
{
    NSInteger clickedSegment = [sender selectedSegment];
    NSInteger clickedSegmentTag = [[sender cell] tagForSegment:clickedSegment];
    if(clickedSegmentTag == 0)
	{
		[self addHost:nil];
	} 
	
	if(clickedSegmentTag == 1)
	{
		//JBConfirmDelete *confirmDelete;
		[self editHost:nil];
	}
	
	if(clickedSegmentTag == 2)
	{
		//JBConfirmDelete *confirmDelete;
		[self connectToHost:nil];
	}
	
}



#pragma mark Adding Host



- (IBAction)addHost:(id)sender
{
	
	[myOKButton setEnabled:NO];
    NSString *createString = NSLocalizedString(@"Create", nil);

	[myOKButton setTitle:createString];
	[myOKButton setAction:@selector(doneAddingHost:)];

	[urlTextField setStringValue:@""];
	[bookmarkNameTextField setStringValue:@""];
	
	
	
//	[NSApp beginSheet:addUrlSheet modalForWindow:mainWindow
//        modalDelegate:self didEndSelector:NULL contextInfo:nil];
    [mainWindow beginSheet:addUrlSheet completionHandler:NULL];

	
	NSPasteboard *pasteboard = [NSPasteboard generalPasteboard]; 
	NSArray *classes = [[NSArray alloc] initWithObjects:[NSString class], nil];
	NSDictionary *options = [NSDictionary dictionary];
	NSArray *copiedItems = [pasteboard readObjectsForClasses:classes options:options];
	[classes release];
	
	if (copiedItems != nil) 
	{
		NSString *urlRegEx = @"[a-z]{2,9}://[a-z|0-9]*.*";
		NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx]; 
		
		if ([urlTest evaluateWithObject:[copiedItems objectAtIndex:0]]) 
		{
			[urlTextField setStringValue:[copiedItems objectAtIndex:0]];
			[myOKButton setEnabled:YES];
		}
	}
}
- (NSManagedObjectContext*)managedObjectContext
{
    return [(Go2_AppDelegate *)[[NSApplication sharedApplication] delegate] managedObjectContext];
}

- (IBAction)doneAddingHost:(id)sender
{
	NSURL *newURL = [NSURL URLWithString:[urlTextField stringValue]];
    NSString *newBookmarkName = [bookmarkNameTextField stringValue];
//    NSLog(@"Here's the new bookmark name: %@", newBookmarkName);
//
//	NSLog(@"Here's the url: %@", newURL);
//	NSLog(@"Here's the host: %@", [newURL host]);
//	NSLog(@"Here's the scheme: %@", [newURL scheme]);
//	NSLog(@"Here's the user: %@", [newURL user]);

	
	[addUrlSheet orderOut:nil];
    [NSApp endSheet:addUrlSheet];
	
    //	NSManagedObject *hostObj = [hostArrayController newObject];
    	NSManagedObject *hostObj;
    
    hostObj = [NSEntityDescription insertNewObjectForEntityForName:@"Hosts" inManagedObjectContext:[self managedObjectContext]];

   // NSLog(@"Created new hostObj");
    
	[hostObj setValue:[newURL absoluteString] forKey:@"url"];
//    NSLog(@"newURL absoluteString");

	[hostObj setValue:[newURL user] forKey:@"userName"];
//    NSLog(@"newURL user");

	[hostObj setValue:[newURL scheme] forKey:@"urlScheme"];
//    NSLog(@"newURL scheme");

    
    if (![newBookmarkName isEqual: @""]) 
    {
        [hostObj setValue:newBookmarkName forKey:@"hostName"];
//        NSLog(@"newBookmarkName");

    } else {
        [hostObj setValue:[newURL host] forKey:@"hostName"];
//        NSLog(@"newURL host");

    }
    
//    NSLog(@"%@", hostObj);
	
	JBGetDefaultApps *getDefaultApps = [[JBGetDefaultApps alloc] init];
	NSURL *defaultAppURL = [getDefaultApps getDefaultApp:[newURL scheme]];
	[getDefaultApps release];
	
	[hostObj setValue:[defaultAppURL path] forKey:@"iconImage"];


	
	[hostArrayController addObject:hostObj];
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"allowSpotlight"]) 
	{
		if (![saveManager saveSingleBookmark:hostObj]) 
		{
			NSLog(@"Ummm... something is not working");	
		}
	}
    
    NSError *error;

    if (![[hostObj managedObjectContext] save:&error]) 
    {
        NSLog(@"there was an error in Save:%@",error);
    }

	
	//[hostObj release];
	[hostListTableView reloadData];
	[urlTextField setStringValue:@""];

	newURL = nil;
	getDefaultApps = nil;
	defaultAppURL = nil;
	
}

- (IBAction)cancelAddingHost:(id)sender
{
	[addUrlSheet orderOut:nil];
    [NSApp endSheet:addUrlSheet];
	[urlTextField setStringValue:@""];
}



#pragma mark Editing Host



- (IBAction)editHost:(id)sender
{
	//[NSApp beginSheet:editHostSheet modalForWindow:mainWindow modalDelegate:self didEndSelector:NULL contextInfo:nil];

	id object = [[hostArrayController selectedObjects] lastObject];
	[myOKButton setEnabled:YES];
    NSString *changeString = NSLocalizedString(@"Change", nil);

	[myOKButton setTitle:changeString];
	[myOKButton setAction:@selector(doneEditHost:)];

	
	[urlTextField setStringValue:[object valueForKey:@"url"]];
	[bookmarkNameTextField setStringValue:[object valueForKey:@"hostName"]];
	
//	[NSApp beginSheet:addUrlSheet modalForWindow:mainWindow modalDelegate:self didEndSelector:NULL contextInfo:nil];
    [mainWindow beginSheet:addUrlSheet completionHandler:NULL];


	object = nil;

}

- (IBAction)doneEditHost:(id)sender
{
	id hostObj = [[hostArrayController selectedObjects] lastObject];
	NSURL *newURL = [NSURL URLWithString:[urlTextField stringValue]];
	NSString *newHostName = [bookmarkNameTextField stringValue];
	[addUrlSheet orderOut:nil];
    [NSApp endSheet:addUrlSheet];
	

	[hostObj setValue:[newURL absoluteString] forKey:@"url"];
	[hostObj setValue:newHostName forKey:@"hostName"];
	[hostObj setValue:[newURL user] forKey:@"userName"];
	[hostObj setValue:[newURL scheme] forKey:@"urlScheme"];
	
	JBGetDefaultApps *getDefaultApps = [[JBGetDefaultApps alloc] init];
	NSURL *defaultAppURL = [getDefaultApps getDefaultApp:[newURL scheme]];
	[getDefaultApps release];
	[hostObj setValue:[defaultAppURL path] forKey:@"iconImage"];
	
	[hostListTableView reloadData];
	[urlTextField setStringValue:@""];
	[bookmarkNameTextField setStringValue:@""];

	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"allowSpotlight"]) 
	{
		if (![saveManager saveSingleBookmark:hostObj]) 
		{
			NSLog(@"Ummm... something is not working");	
		}
	}
	
	hostObj = nil;
	newURL = nil;
	defaultAppURL = nil;
}

//- (IBAction)cancelEditHost:(id)sender
//{
//	[editHostSheet orderOut:nil];
//    [NSApp endSheet:editHostSheet];
//	[editUrlTextField setStringValue:@""];
//}



#pragma mark Delete Host



- (IBAction)deleteHost:(id)sender
{
	[self doTheDelete];
}

- (void)doTheDelete
{
	NSString *hostString = NSLocalizedString(@"Host", nil);
	NSString *hostPluralString = NSLocalizedString(@"Hosts", nil);	
	NSString *okString = NSLocalizedString(@"OK", nil);
	NSString *cancelString = NSLocalizedString(@"Cancel", nil);	
	NSString *areYouSure = NSLocalizedString(@"areYouSure", nil);	
	NSString *deleteHostString = NSLocalizedString(@"DeleteHost", nil);	
	NSString *pluralAreYouSure = NSLocalizedString(@"PluralareYouSure", nil);	
	NSString *pluralDeleteHostString = NSLocalizedString(@"PluralDeleteHost", nil);	


	NSString *jbConfirmDeleteGoKey = @"JBConfirmDeleteGoKey";
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if ([defaults boolForKey:jbConfirmDeleteGoKey]) 
	{
		//NSLog(@"Deleting hosts without confirmation");
		
//		if (![saveManager deleteBookmark:[hostArrayController selectedObjects]]) 
//		{
//			NSLog(@"Problem deleting bookmarks");
//		}
		
		[hostArrayController removeObjects:[hostArrayController selectedObjects]];
		
		
				
		if ([[hostArrayController arrangedObjects] count] == 0) 
		{
			//NSLog(@"No Rows!");
			[numberOfHostsTextView setStringValue:@""];
			
		} else {
			
			if ([[hostArrayController arrangedObjects] count] == 1) 
			{
				[numberOfHostsTextView setStringValue:[NSString stringWithFormat: @"%ld %@",[[hostArrayController arrangedObjects] count], hostString] ];
			} else {
				
				[numberOfHostsTextView setStringValue:[NSString stringWithFormat: @"%ld %@",[[hostArrayController arrangedObjects] count], hostPluralString] ];
			}
		}
		
		
	} else {
		
		NSAlert* alert = [NSAlert new];
		
		if ([[hostArrayController selectedObjects] count] == 1) 
		{
			
			NSArray *a = [hostArrayController selectedObjects];
			NSObject *b = [a objectAtIndex:0];
			
			
			[alert setInformativeText: areYouSure];
			[alert setMessageText: [NSString stringWithFormat: @"%@ %@",deleteHostString, [b valueForKey:@"hostName"]]];
			[alert addButtonWithTitle:okString];
			[alert addButtonWithTitle:cancelString];
			
			a = nil;
			b = nil;
			
		} else {
			
			[alert setInformativeText: pluralAreYouSure];
			[alert setMessageText: pluralDeleteHostString];
			[alert addButtonWithTitle:okString];
			[alert addButtonWithTitle:cancelString];
			
		}

		
		
		[alert setShowsSuppressionButton:YES];
		[alert setAlertStyle:NSAlertStyleCritical];
		//NSLog(@"Created alert");
		
		
		if ([alert runModal] == NSAlertFirstButtonReturn) 
		{
			// OK clicked, delete the record
			
//			NSLog(@"About to remove spotlight bookmark");
//			
//			if (![saveManager deleteBookmark:[hostArrayController selectedObjects]]) 
//			{
//				NSLog(@"Problem deleting bookmarks");
//			}
			
			
			[hostArrayController removeObjects:[hostArrayController selectedObjects]];
			
			
			
			
			//[numberOfHostsTextView setTitleWithMnemonic:[NSString stringWithFormat: @"%d",[[hostArrayController arrangedObjects] count] ]];
			if ([[hostArrayController arrangedObjects] count] == 0) 
			{
				//NSLog(@"No Rows!");
				[numberOfHostsTextView setStringValue:@""];
				
			} else {
				
				if ([[hostArrayController arrangedObjects] count] == 1) 
				{
					[numberOfHostsTextView setStringValue:[NSString stringWithFormat: @"%ld %@",[[hostArrayController arrangedObjects] count], hostString] ];
				} else {
					
					[numberOfHostsTextView setStringValue:[NSString stringWithFormat: @"%ld %@",[[hostArrayController arrangedObjects] count], hostPluralString] ];
				}
			}
			
			
			//NSLog(@"Resetting the status bar at the bottom");
			
			
			
            if ([[alert suppressionButton] state] == NSControlStateValueOn) {
				// Suppress this alert from now on.
				[defaults setBool:YES forKey:jbConfirmDeleteGoKey];
			}
		}
		
        if ([[alert suppressionButton] state] == NSControlStateValueOn) {
			[alert release];
			// Suppress this alert from now on.
			[defaults setBool:YES forKey:jbConfirmDeleteGoKey];
			
		} else {
			[alert release];
		}


	}	
	
	
	hostString = nil;
	hostPluralString = nil;
	okString = nil;
	cancelString = nil;
	areYouSure = nil;
	deleteHostString = nil;
	pluralAreYouSure = nil;
	pluralDeleteHostString = nil;
	jbConfirmDeleteGoKey = nil;
	defaults = nil;
	

	

}



#pragma mark Connecting to Host



- (IBAction)connectToHost:(id)sender
{
//    dispatch_queue_t queue = dispatch_get_global_queue(0,0);

//    dispatch_async(queue,^{
	if ([hostListTableView numberOfSelectedRows] == 1) {
		// OK, first, get the selected host
		NSInteger row = [hostListTableView selectedRow];
		
		// Get the object so we can get to the attributes of the host
		NSArray *a = [hostArrayController arrangedObjects];
		NSObject *b = [a objectAtIndex:row];
		
		NSURL *myUrl = [NSURL URLWithString:[b valueForKey:@"url"]];
		NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
		[workSpace openURL:myUrl];	
		
		a = nil;
		b = nil;
		myUrl = nil;
		workSpace = nil;
		
	} else {
		// More than one thing to do here, let's first get the selected rows
		
		NSIndexSet *selected = [hostListTableView selectedRowIndexes];		
		NSUInteger idx = [selected firstIndex];
		
		while (idx != NSNotFound)
		{
			// do work with "idx"
			//NSLog (@"The current index is %u", idx);
			
			NSArray *a = [hostArrayController arrangedObjects];
			NSObject *b = [a objectAtIndex:idx];
			
			NSURL *myUrl = [NSURL URLWithString:[b valueForKey:@"url"]];
			NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
			[workSpace openURL:myUrl];	

			// get the next index in the set
			idx = [selected indexGreaterThanIndex:idx];
			
			a = nil;
			b = nil;
			myUrl = nil;
			workSpace = nil;
		}
	
		selected = nil;
		
	}
    
//    }); // end of GCD Dispatch queue
}



#pragma mark Search



- (IBAction)focusSearchField:(id)sender
{
	if ([myToolBar isVisible]) 
	{
		[mainWindow makeFirstResponder:mySearchField]; 
	} else {
		[myToolBar setVisible:YES];
		[mainWindow makeFirstResponder:mySearchField]; 
	}
}

- (IBAction)selectAllHosts:(id)sender
{
	[hostListTableView selectAll:nil];
}



#pragma mark 3rd Party Tools



- (IBAction)openFarmdogSoftware:(id)sender
{
	NSURL *myUrl = [NSURL URLWithString:@"http://jonathanbuys.com"];
	NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
	[workSpace openURL:myUrl];
	
	myUrl = nil;
	workSpace = nil;	
}



#pragma mark -
#pragma mark Preferences



- (IBAction)editPrefs:(id)sender
{	
	//NSLog(@"Step1");
	
	if (!prefsWindow) 
	{
		//NSLog(@"No prefs window!");
//		[NSBundle loadNibNamed:@"Prefs" owner:self];
        [[NSBundle mainBundle] loadNibNamed:@"Prefs" owner:self topLevelObjects:nil];

		//NSLog(@"Loading prefs window");
	}
	//NSLog(@"Step2");

	[prefsWindow makeKeyAndOrderFront:self];
	//NSLog(@"Step3");

//	[NSApp beginSheet:editPrefsSheet modalForWindow:mainWindow modalDelegate:self didEndSelector:NULL contextInfo:nil];
//	[shortcutRecorder setCanCaptureGlobalHotKeys:YES];
	//NSLog(@"Step4");

	[shouldBeInDockButton setState:[[NSUserDefaults standardUserDefaults] boolForKey:@"hideIcon"]];
	//NSLog(@"Step5");

    [allowSpotlightCheckbox setState:[[NSUserDefaults standardUserDefaults] boolForKey:@"allowSpotlight"]];
    //NSLog(@"Step6");


	[showSecureShellCheckbox setState:[[NSUserDefaults standardUserDefaults] boolForKey:@"showSecureShellLib"]];
	//NSLog(@"Step7");

	[showWebAppsCheckbox setState:[[NSUserDefaults standardUserDefaults] boolForKey:@"showWebAppsLib"]];
	//NSLog(@"Step8");

	[showVncCheckbox setState:[[NSUserDefaults standardUserDefaults] boolForKey:@"showVncLib"]];
	//NSLog(@"Step9");

	[showFtpCheckbox setState:[[NSUserDefaults standardUserDefaults] boolForKey:@"showFtpLib"]];
	//NSLog(@"Step10");
    
//    [shortcutRecorder setKeyCombo:SRMakeKeyCombo([[NSUserDefaults standardUserDefaults] integerForKey:@"keyComboCode"], [[NSUserDefaults standardUserDefaults] integerForKey:@"keyComboCodeFlags"])];
        //  NSLog(@"this should be in the shortcutRecorder control: %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"keyComboString"]);

//    [shortcutRecorderQS setKeyCombo:SRMakeKeyCombo([[NSUserDefaults standardUserDefaults] integerForKey:@"keyComboCodeQS"], [[NSUserDefaults standardUserDefaults] integerForKey:@"keyComboCodeFlagsQS"])];


}

- (IBAction)doneEditPrefs:(id)sender
{
	
	[prefsWindow orderOut:nil];
	[self prefsPanelWillClose];
	
}


- (void)prefsPanelWillClose;
{
        //
        // Get the hotkey for the status menu
        //
	if (globalHotKey != nil)
	{
//		[[PTHotKeyCenter sharedCenter] unregisterHotKey: globalHotKey];
		[globalHotKey release];
		globalHotKey = nil;
	}
	
//	globalHotKey = [[PTHotKey alloc] initWithIdentifier:@"SRTest"
//											   keyCombo:[PTKeyCombo keyComboWithKeyCode:[shortcutRecorder keyCombo].code
//																			  modifiers:[shortcutRecorder cocoaToCarbonFlags: [shortcutRecorder keyCombo].flags]]];
//    
//        // NSLog(@"Key Combo: %@", [shortcutRecorder keyComboString]);
//	
//	[globalHotKey setTarget: self];
//	[globalHotKey setAction: @selector(hitHotKey:)];
//	
//	[[PTHotKeyCenter sharedCenter] registerHotKey: globalHotKey];
//    
//    
//        //
//        // Get the hotkey for the quicksearch
//        //
//    
//    
//    if (globalHotKeyQS != nil)
//	{
//		[[PTHotKeyCenter sharedCenter] unregisterHotKey: globalHotKeyQS];
//		[globalHotKeyQS release];
//		globalHotKeyQS = nil;
//	}
//	
//	globalHotKeyQS = [[PTHotKey alloc] initWithIdentifier:@"SRTestQS"
//                                                 keyCombo:[PTKeyCombo keyComboWithKeyCode:[shortcutRecorderQS keyCombo].code
//                                                                                modifiers:[shortcutRecorderQS cocoaToCarbonFlags: [shortcutRecorderQS keyCombo].flags]]];
//    
//        // NSLog(@"Key Combo: %@", [shortcutRecorder keyComboString]);
//	
//	[globalHotKeyQS setTarget: self];
//	[globalHotKeyQS setAction: @selector(hitHotKeyQS:)];
//	
//	[[PTHotKeyCenter sharedCenter] registerHotKey: globalHotKeyQS];
    
    
	
    
    
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"allowSpotlight"] != [allowSpotlightCheckbox state])
        {
                    if ([allowSpotlightCheckbox state])
                        {
                                    if ([saveManager saveBookmarks] )
                                        {
                                                    NSLog(@"Bookmarks exported for Spotlight");
                                            }
                            } else {
                                        NSFileManager *fileManager = [[NSFileManager alloc] init];
                                        NSError *error = nil;
                                        BOOL isDir;
                                        NSString *go2SupportDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Public/Go2Data"];

                                // Check for the Go2Data directory
                                        if ([fileManager fileExistsAtPath:go2SupportDir isDirectory:&isDir] && isDir)
                                            {
                                                        [fileManager removeItemAtPath:go2SupportDir error:&error];
                                                        
                                                } 
                                // End Check for Go2Data Directory
                                        
                                        [fileManager release];
                                        [error release];
                                        
                                }
                    
            }

	
//    NSUInteger newInt = [shortcutRecorder cocoaToCarbonFlags: [shortcutRecorder keyCombo].flags];
//	NSString *str = [NSString stringWithFormat:@"%lu", newInt];
//
//	[[NSUserDefaults standardUserDefaults] setInteger:[shortcutRecorder keyCombo].code forKey:@"keyComboCode"];
//    [[NSUserDefaults standardUserDefaults] setInteger:[shortcutRecorder keyCombo].flags forKey:@"keyComboCodeFlags"];
//    
//	[[NSUserDefaults standardUserDefaults] setObject:str forKey:@"modValue"];
//	[[NSUserDefaults standardUserDefaults] setObject:[shortcutRecorder keyComboString] forKey:@"keyComboString"];
//
//    
//    NSUInteger newIntQS = [shortcutRecorderQS cocoaToCarbonFlags: [shortcutRecorderQS keyCombo].flags];
//	NSString *strQS = [NSString stringWithFormat:@"%lu", newIntQS];
//
//    [[NSUserDefaults standardUserDefaults] setInteger:[shortcutRecorderQS keyCombo].code forKey:@"keyComboCodeQS"];
//    [[NSUserDefaults standardUserDefaults] setInteger:[shortcutRecorderQS keyCombo].flags forKey:@"keyComboCodeFlagsQS"];
//    
//	[[NSUserDefaults standardUserDefaults] setObject:strQS forKey:@"modValueQS"];
//	[[NSUserDefaults standardUserDefaults] setObject:[shortcutRecorderQS keyComboString] forKey:@"keyComboStringQS"];

    
	if ([shouldBeInDockButton state] != [[NSUserDefaults standardUserDefaults] boolForKey:@"hideIcon" ]) 
	{
		[[NSUserDefaults standardUserDefaults] setBool:[shouldBeInDockButton state] forKey:@"hideIcon"];
		
		
		
		NSAlert* alert = [NSAlert new];
		
            //		[alert setInformativeText:@"I'm sorry, but I can't change if I'm shown in the Dock or not until I'm restarted."];
            //		[alert setMessageText:@"I hate to say this, but... I'll Need a Restart..."];
        NSString *informTextString = NSLocalizedString(@"InformText", nil);
        NSString *restartRequired = NSLocalizedString(@"Restart Required", nil);
        NSString *okString = NSLocalizedString(@"OK", nil);
        NSString *cancelString = NSLocalizedString(@"Cancel", nil);


        [alert setInformativeText:informTextString];
        
		[alert setMessageText:restartRequired];
        
		[alert addButtonWithTitle:okString];
		[alert addButtonWithTitle:cancelString];
		[alert setShowsSuppressionButton:NO];
		[alert setAlertStyle:NSAlertStyleCritical];
		
		
		if ([alert runModal] == NSAlertFirstButtonReturn) 
		{
			NSLog(@"Go2 needs to restart.");
                // [[NSWorkspace sharedWorkspace] launchApplication:@"relaunchGo2"];
            
            	// Copy the relauncher into a temporary directory in the sandbox so we can get to it.
//            NSString *privPath = @"/private";
//            NSString *relaunchPathToCopy = [GO2_BUNDLE pathForResource:@"relaunchGo2" ofType:@"app"];
//            NSString *targetPath1 = [NSTemporaryDirectory() stringByAppendingPathComponent:[relaunchPathToCopy lastPathComponent]];
//            NSString *targetPath = [privPath stringByAppendingPathComponent:targetPath1];
//                //  NSString *targetPath = [targetPath1 stringByAppendingPathComponent:@"Contents/MacOS/applet"];
//            
//                // Only the paranoid survive: if there's already a stray copy of relaunch there, we would have problems.
//            NSError *error = nil;
//            
//            [[NSFileManager defaultManager] removeItemAtPath:targetPath error:nil];
//            
//            if ([[NSFileManager defaultManager] copyItemAtPath:relaunchPathToCopy toPath:targetPath error:&error])
//                relaunchPath = [targetPath retain];
//            else
//                NSLog(@"Error relaunching...");
            
                // NSURL *fileURL = [NSURL URLWithString:targetPath];
                // NSLog(@"fileURL = %@", fileURL);
            
            
                //                NSError *error2 = nil;
                //                // [[NSWorkspace sharedWorkspace] launchApplicationAtURL:fileURL options:NSWorkspaceLaunchAndHide configuration:nil error:&error2];
                //                //  [[NSWorkspace sharedWorkspace] openURL:fileURL];
                //                 [[NSWorkspace sharedWorkspace] openFile:targetPath];
                //            [[NSWorkspace sharedWorkspace] launchApplication:targetPath];
                //        
                //            if (error2 != nil) {
                //                NSLog(@"Error: %@ %@", error2, [error2 userInfo]); //Or other error handling (e.g., [NSApp presentError:error]).
                //            } else {
                //                NSLog(@"It should have launched?");
                //            }
            
//            FSRef fsPath;
//            LSRegisterFSRef(&fsPath, YES);
//            OSStatus os_status = FSPathMakeRef((const UInt8 *)[targetPath fileSystemRepresentation], &fsPath, NULL);
//            
//            if (os_status == noErr) {
//                    //  NSLog(@"path registered a success");
//                    //  NSLog(@"targetPath = %@", targetPath);
//            }
//            
//            LSApplicationParameters params = {0, kLSLaunchDefaults, &fsPath, NULL, NULL, NULL, NULL};
//            LSOpenApplication(&params, NULL);
//                //LSOpenFSRef(&fsPath, NULL);
//            
		}
		
		[alert release];
	}
	
	[[NSUserDefaults standardUserDefaults] setBool:[allowSpotlightCheckbox state] forKey:@"allowSpotlight"];
	
}



- (IBAction)changeSSHCheckbox:(id)sender
{
	[sourceListController showSSHLibary:[showSecureShellCheckbox state]];
}

- (IBAction)changeWebCheckbox:(id)sender
{
	[sourceListController showWebLibary:[showWebAppsCheckbox state]];
}

- (IBAction)changeVNCCheckbox:(id)sender
{
	[sourceListController showVNCLibary:[showVncCheckbox state]];
}

- (IBAction)changeFTPCheckbox:(id)sender
{
	[sourceListController showFTPLibary:[showFtpCheckbox state]];
}


#pragma mark - shortcutRecorder delegate methods



//- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder isKeyCode:(NSInteger)keyCode andFlagsTaken:(NSUInteger)flags reason:(NSString **)aReason
//{
//	if (aRecorder == shortcutRecorder)
//	{
//		BOOL isTaken = NO;
//		
//		KeyCombo kc = [delegateDisallowRecorder keyCombo];
//		
//		if (kc.code == keyCode && kc.flags == flags) isTaken = YES;
//		
//		*aReason = [delegateDisallowReasonField stringValue];
//		
//		return isTaken;
//	}
//	
//	return NO;
//}
//
//- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo
//{
//	if (aRecorder == shortcutRecorder)
//	{
//		//[self toggleGlobalHotKey: aRecorder];
//		//NSLog(@"keyComboDidChange");
//	}
//}
//
- (void)hitHotKey:(PTHotKey *)hotKey
{
        //NSLog(@"Hit hot key");
	
	[NSApp activateIgnoringOtherApps:YES];
	
	// What a fricking hack...
	[NSTimer scheduledTimerWithTimeInterval:0.01
										target:self
									selector:@selector(popUpTheMenuAfterDelay)
									   userInfo:nil
										repeats:NO];
}

- (void)hitHotKeyQS:(PTHotKey *)hotKey
{
    [qsDelegate openMenu];
}

- (BOOL)validateMenuItem:(NSMenuItem*)anItem 
{
    return YES;
}

- (void)popUpTheMenuAfterDelay
{
	//NSLog(@"Timer Fired");
    [myMenuApplet popUpStatusItemMenu];
	//[myMenuApplet closeMenu];

}



@end


