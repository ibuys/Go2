//
//  JBAppController.h
//  Go
//
//  Created by Jon Buys on 7/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JBMenuItem.h"
#import "JBStatusItemView.h"
#import "JBSaveAndLoad.h"
//#import "JBSourceListController.h"
#import <dispatch/dispatch.h>

@class PTHotKey;
@class JBQSDelegate;


extern NSString * const B6DefaultUserName;
extern NSString * const B6UnixCheckBoxKey;


@interface JBAppController : NSObject 
{
	IBOutlet id addUrlSheet;
	IBOutlet id editPrefsSheet;
    IBOutlet id mainWindow;
	
	
	IBOutlet NSTextField *bookmarkNameTextField;
	IBOutlet NSTextField *urlTextField;
	
	IBOutlet NSArrayController *hostArrayController;
	IBOutlet NSTableView *hostListTableView;	
	IBOutlet NSButton *myOKButton;
	
	IBOutlet NSSearchField *mySearchField;
	IBOutlet NSSegmentedControl *segControl;
	IBOutlet NSToolbar *myToolBar;
	IBOutlet NSTextField *numberOfHostsTextView;
	
	IBOutlet JBMenuItem *myMenuApplet;
	IBOutlet JBSaveAndLoad *saveManager;
	
	IBOutlet NSButton *shouldBeInDockButton;
    IBOutlet NSButton *allowSpotlightCheckbox;
	IBOutlet NSButton *showSecureShellCheckbox;
	IBOutlet NSButton *showWebAppsCheckbox;
	IBOutlet NSButton *showVncCheckbox;
	IBOutlet NSButton *showFtpCheckbox;
	
	
	IBOutlet NSMenu *mainFileMenu;


	IBOutlet NSTextField *delegateDisallowReasonField;
	
	IBOutlet NSWindow *prefsWindow;
//    IBOutlet JBSourceListController *sourceListController;

    IBOutlet JBQSDelegate *qsDelegate;

	PTHotKey *globalHotKey;
    PTHotKey *globalHotKeyQS;

    NSString *relaunchPath;

	
}

- (IBAction)addHost:(id)sender;
- (IBAction)doneAddingHost:(id)sender;
- (IBAction)cancelAddingHost:(id)sender;
- (IBAction)connectToHost:(id)sender;
- (IBAction)editHost:(id)sender;
- (IBAction)doneEditHost:(id)sender;
//- (IBAction)cancelEditHost:(id)sender;
- (IBAction)focusSearchField:(id)sender;
- (IBAction)segControlClicked:(id)sender;
- (IBAction)selectAllHosts:(id)sender;
- (IBAction)deleteHost:(id)sender;
- (IBAction)openFarmdogSoftware:(id)sender;

- (IBAction)editPrefs:(id)sender;
- (IBAction)doneEditPrefs:(id)sender;
- (void)prefsPanelWillClose;

- (void)doTheDelete;
- (BOOL)validateMenuItem:(NSMenuItem*)anItem;
- (void)hitHotKey:(PTHotKey *)hotKey;
- (void)hitHotKeyQS:(PTHotKey *)hotKey;

//- (IBAction)changeSSHCheckbox:(id)sender;
//- (IBAction)changeWebCheckbox:(id)sender;
//- (IBAction)changeVNCCheckbox:(id)sender;
//- (IBAction)changeFTPCheckbox:(id)sender;

- (void)appDidLaunch:(NSNotification *)aNotification;

@end
