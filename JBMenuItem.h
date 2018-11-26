//
//  JBMenuItem.h
//  Go
//
//  Created by Jonathan Buys on 9/13/10.
//  Copyright 2010 Farmdog Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "NSManagedObjectContext+JBReturnArray.h"

@interface JBMenuItem : NSObject <NSMenuDelegate>
{
	NSMenu *statusMenu;
	NSStatusItem *statusItem;
	NSImage *statusImage;
	NSImage *statusHighlightImage;
	NSMutableArray			*recentSelections;
	
	
	
	BOOL					completePosting;
    BOOL					commandHandling;

	
	IBOutlet NSArrayController *hostsController;
	IBOutlet NSView *menuView;
	IBOutlet NSView *resultsView;
	IBOutlet NSSearchField *searchField;
	IBOutlet NSView *jbView;
	IBOutlet NSWindow *mainWindow;
	
	IBOutlet NSMenu *rightClickMenu;

}

-(IBAction)goToHostFromMenuBar:(id)sender;
- (NSMenuItem *)buildMenuItem:(NSMenuItem *)dupItem fromObject:(NSObject *)hostObject;

- (void)createMenuApp;
- (void)popUpStatusItemMenu;
- (void)popUpRightClickMenu;
- (void)quitGo2;
- (void)showMainWindow:(id)sender;

@end

