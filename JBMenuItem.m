//
//  JBMenuItem.m
//  Go
//
//  Created by Jonathan Buys on 9/13/10.
//  Copyright 2010 Farmdog Software. All rights reserved.
//

#import "JBMenuItem.h"
#import "JBStatusItemView.h"

@implementation JBMenuItem


- (void)createMenuApp
{
	recentSelections = [[NSMutableArray alloc] initWithCapacity:3];
	
    NSString *goString = NSLocalizedString(@"Go", nil);
    NSString *menuString = NSLocalizedString(@"Menu", nil);
    NSString *activeateGo2String = NSLocalizedString(@"Activate Go2", nil);

	statusMenu = [[NSMenu alloc] initWithTitle:goString];
	[statusMenu setDelegate:self];
	
	NSMenuItem *myMenuItemView = [[NSMenuItem alloc] initWithTitle:menuString action:NULL keyEquivalent:@""];
	
	[myMenuItemView setView:menuView];
	[statusMenu addItem:myMenuItemView];
	[myMenuItemView release];
	
	//Create the NSStatusBar and set its length
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
		
	//Used to detect where our files are
	NSBundle *bundle = [NSBundle mainBundle];
	
	//Allocates and loads the images into the application which will be used for our NSStatusItem
	statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"go_menubarTemplate" ofType:@"png"]];
	statusHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"go_menubar_altTemplate" ofType:@"png"]];
	
	//Sets the images in our NSStatusItem
	[statusItem setImage:statusImage];
	[statusItem setAlternateImage:statusHighlightImage];
	[statusItem setToolTip:activeateGo2String];
		
	[statusItem setView:jbView];

	
	//[statusItem setTarget:self];
	
	[statusItem setHighlightMode:YES];
	[statusItem setEnabled:YES];
	[statusItem setMenu:statusMenu];
}

- (void)controlTextDidChange:(NSNotification *)obj
{
	// I guess I'm not going to use this
//	obj = nil;
		
	// Build the search
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(hostName contains[cd] %@) OR (url contains %@)", [searchField stringValue] , [searchField stringValue]];
	
	// Get all of our objects from core data
	NSArray *array = nil;
	array = [hostsController arrangedObjects];
	
	// Don't worry about it if we don't have anything in core data
	if (array != nil)
	{
		// Get rid of the old menu
		NSArray *oldMenuItmes = nil;
		oldMenuItmes = [statusMenu itemArray];
		NSUInteger index = 0;

		for (id x in oldMenuItmes)
		{
			if (index != 0) 
			{
//				[statusMenu setMenuChangedMessagesEnabled:YES];			
				[statusMenu removeItem:x];
//				[statusMenu setMenuChangedMessagesEnabled:YES];			
			}
			index++;
		}

		
		// Build the new array
		NSArray *filteredArray = nil;
		filteredArray = [array filteredArrayUsingPredicate:predicate];
				
		// Start looping through
		
		for (id jbObject in filteredArray)
		{
			NSMenuItem *dupItem = [[NSMenuItem alloc] init];
			[statusMenu addItem:[self buildMenuItem:dupItem fromObject:jbObject]];
			[dupItem release];
		}
	}
//    NSString *showGo2String = NSLocalizedString(@"Show Go2", nil);
    NSString *showGo2String = NSLocalizedString(@"Show Go2", nil);

	[statusMenu addItemWithTitle:showGo2String action:@selector(showMainWindow:) keyEquivalent:@""];
	[[statusMenu itemWithTitle:showGo2String] setTarget:self];
	[[statusMenu itemWithTitle:showGo2String] setEnabled:YES];
	
}

- (void)menuWillOpen:(NSMenu *)menu 
{
	
	// We don't need this, might as well get rid of it.
//	menu = nil;
	
	// NSLog(@"menuWillOpen");
	[searchField setStringValue:@""];
	
	// Get rid of the old menu
	NSArray *oldMenuItmes = nil;
	oldMenuItmes = [statusMenu itemArray];
	NSUInteger index = 0;

	for (id x in oldMenuItmes)
	{
		if (index != 0) 
		{
//			[statusMenu setMenuChangedMessagesEnabled:YES];			
			[statusMenu removeItem:x];
//			[statusMenu setMenuChangedMessagesEnabled:YES];			
		}
		index++;
	}
	
	
	// Add the recently selected items here.
	
	if ([recentSelections count] != 0) 
	{
		NSUInteger i = 1;
		for (NSMenuItem *newMenuItem in recentSelections)
		{
			[newMenuItem setKeyEquivalent:[NSString stringWithFormat:@"%lx", i]];
			[newMenuItem setKeyEquivalentModifierMask:0];
			[statusMenu addItem:newMenuItem];
			i++;
		}
	} 
	
	// Add a menu item to open the Go2 GUI
	
	if ([statusMenu numberOfItems] > 1) {
		[statusMenu addItem:[NSMenuItem separatorItem]];
	}
    NSString *showGo2String = NSLocalizedString(@"Show Go2", nil);

	[statusMenu addItemWithTitle:showGo2String action:@selector(showMainWindow:) keyEquivalent:@""];
	[[statusMenu itemWithTitle:showGo2String] setTarget:self];
	[[statusMenu itemWithTitle:showGo2String] setEnabled:YES];

	[(JBStatusItemView *)[statusItem view] setHighlightOn];

}

- (void)menuDidClose:(NSMenu *)menu 
{
//	menu = nil;
	// NSLog(@"menuDidCLose");
	[(JBStatusItemView *)[statusItem view] setHighlightOff];
	[[searchField window] makeFirstResponder:nil];

}


// Got this gem from Jim, lets me use the down arrow to keyboard through the search results
//- (void)controlTextDidEndEditing:(NSNotification *)aNotification{
//
//    if([[[aNotification userInfo] valueForKey:@"NSTextMovement"] intValue] == NSTabTextMovement) {
//       // NSLog(@"test");
//		[[statusMenu window] makeFirstResponder:[statusMenu window]];
//
//
//	}
//
//	
//}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)command
{
	
	// NSLog(@"Selector: %@", NSStringFromSelector( command ));
	if( [NSStringFromSelector( command ) isEqualToString:@"moveDown:"] )
	{
		NSEvent *theEvent = [NSApp currentEvent];
	//	NSLog(@"moveDown");
		
		[[searchField window] makeFirstResponder:nil];
		[[searchField window] postEvent:theEvent atStart:NO];
		
		return( YES );
	}
	
	return( NO );
	
}

-(IBAction)goToHostFromMenuBar:(id)sender
{
	//NSLog(@"Sender: %@", sender);
	
	BOOL addToArray = YES;
	
	NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
	[workSpace openURL:[NSURL URLWithString:[sender representedObject]]];
	
		
	// Test each item in the old array, and if it's already in there, don't add it
	for (NSMenuItem *recentMenuItem in recentSelections)
	{
		if ([sender representedObject] == [recentMenuItem representedObject]) 
		{
			addToArray = NO;			
		} 
	}
	
	if (addToArray == YES) 
	{
		// Rotate through the most recent four objects
		if ([recentSelections count] == 4) 
		{
			[recentSelections removeObjectAtIndex:0];
		}
		
		[recentSelections addObject:sender];
		
	}
    
    [[NSApplication sharedApplication] hide:nil];

}

- (void)popUpStatusItemMenu
{
	[statusItem popUpStatusItemMenu:[statusItem menu]];
}

- (void)popUpRightClickMenu;
{
    [(JBStatusItemView *)[statusItem view] setHighlightOn];

    [statusItem popUpStatusItemMenu:rightClickMenu];
}

- (void)closeMenu
{
//	NSLog(@"Ok, now close the damn menu");
	[statusMenu cancelTracking];
}


- (void)showMainWindow:(id)sender {
	// Open main window. Simple.
	[mainWindow makeKeyAndOrderFront:sender];
}

- (NSMenuItem *)buildMenuItem:(NSMenuItem *)dupItem fromObject:(NSObject *)hostObject
{	
	
	[dupItem setAction:@selector(goToHostFromMenuBar:)];
	[dupItem setTarget:self];
	[dupItem setEnabled:YES];
	[dupItem setRepresentedObject:[hostObject valueForKey:@"url"]];
	
	
	
	// Check for the outside chance that the user deleted the host name.
	if ([[hostObject valueForKey:@"hostName"] isEqualToString:@""])
	{
		NSURL *hostURL = [NSURL URLWithString:[hostObject valueForKey:@"url"]];
		[dupItem setTitle:[hostURL host]];
		 
	} else {
		
		[dupItem setTitle:[hostObject valueForKey:@"hostName"]];
	}
		
	
	NSString *myImagePathString = [hostObject valueForKey:@"iconImage"];
	
	NSImage *newMenuItemIcon = [[NSWorkspace sharedWorkspace] iconForFile: myImagePathString];
	NSSize newSize;
	newSize = [newMenuItemIcon size];
	newSize.width *= 0.5;
	newSize.height *= 0.5;
	[newMenuItemIcon setSize:newSize];
	
	[dupItem setImage:newMenuItemIcon];
	
	// Add hotkeys for the first five hosts
	if ([statusMenu numberOfItems] <= 5) {
		
		NSString *statusMenuItemIndex = [NSString stringWithFormat:@"%lx", [statusMenu numberOfItems]];
		//NSLog(@"statusMenuItemIndex = %@", statusMenuItemIndex);
		
		[dupItem setKeyEquivalent:statusMenuItemIndex];
	}
	
	return dupItem;
}

- (void)quitGo2
{
	[NSApp terminate:nil];
}

- (void)dealloc
{
	[recentSelections release];
	[super dealloc];
}

@end
