//
//  AppController.h
//  Go
//
//  Created by Jon Buys on 7/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "JBOutlineViewController.h"


extern NSString * const B6DefaultUserName;
extern NSString * const B6UnixCheckBoxKey;


@interface AppController : NSObject 
{
	IBOutlet NSWindow *window;
	IBOutlet NSTableView* hostList;
	IBOutlet NSArrayController *hostsController;
	IBOutlet NSTableColumn *mainTableColumn;
	IBOutlet NSButton *dropDownMenuButton;
	IBOutlet NSToolbar *mainToolBar;

	NSMutableArray*			_allKeywords;
	NSMutableArray*			_builtInKeywords;
	
	IBOutlet NSSearchField*	searchField;
	IBOutlet NSTextField *numberOfHostsTextView;
	
	
	BOOL					completePosting;
    BOOL					commandHandling;
	
	NSError *error;
	
	//IBOutlet NSOutlineView *myPXSourceList;
	IBOutlet NSView *mainView;
	IBOutlet NSView *smartEditorView;
	IBOutlet NSView *mainSplitView;

	CALayer *root;
	CALayer *smartEditorLayer;
	CALayer *mainSplitLayer;
    
    IBOutlet JBOutlineViewController *obvController;
}

- (IBAction)sendFeedback:(id)sender;

@end
