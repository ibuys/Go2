//
//  JBSourceListController.h
//  Servers
//
//  Created by Jonathan Buys on 1/14/11.
//  Copyright 2011 Farmdog Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JBValidateTextField.h"

@interface JBSourceListController : NSObject
{
	NSMutableArray *sourceListItems;
    NSArray *draggedItems;

	IBOutlet NSArrayController *bookmarkListArrayController;
	IBOutlet NSTableView *bookmarkListTableView;
	
	NSPredicate *smartPredicateForEditor;
	IBOutlet NSPredicateEditor *myPredicateEditor;
	IBOutlet NSWindow *mainWindow;
	IBOutlet NSWindow *sheet;
	IBOutlet NSTextField *smartFolderNameTextView;
	IBOutlet NSButton *smartOKButton;
	IBOutlet NSSearchField *mySearchField;
	NSInteger previousRowCount;

	IBOutlet JBValidateTextField *textValidator;
	IBOutlet NSSearchField *searchField;
}

- (IBAction)openEditor:(id)sender;
- (IBAction)closeEditor:(id)sender;
- (IBAction)deleteSmartFolder:(id)sender;
- (IBAction)cancelNewSmartFolder:(id)sender;
- (IBAction)editSmartFolder:(id)sender;

- (IBAction)predicateEditorChanged:(id)sender;
- (IBAction)finishEditSmartFolder:(id)sender;

- (IBAction)saveSearch:(id)sender;

- (void)createSmartList:(NSPredicate *)passedSmartPredicate named:(NSString *) newSmartFolderName;
- (BOOL)deleteSelectedSmartFolder:(NSIndexSet *)selectedSmartFolderSet;


- (NSString *)applicationSupportFolder;
- (NSUndoManager *)undoManager;

- (void)showVNCLibary:(BOOL)option;
- (void)showSSHLibary:(BOOL)option;
- (void)showFTPLibary:(BOOL)option;
- (void)showWebLibary:(BOOL)option;
//- (void)liveUpdateView:(NSNotification *)passedPredicateEditor;


@end
