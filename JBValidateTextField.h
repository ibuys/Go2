//
//  JBValidateTextField.h
//  Go
//
//  Created by Jon Buys on 7/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JBValidateTextField : NSObject 
{
	IBOutlet NSTextField *urlTextField;
	IBOutlet NSButton *urlOKButton;

	IBOutlet NSTextField *editUrlTextField;
	IBOutlet NSButton *editUrlOKButton;
	
	IBOutlet NSTextField *createEditSmartFolderTextField;
	IBOutlet NSButton *createEditSmartFolderButton;
	
	IBOutlet NSPredicateEditor *smartEditor;
	
	IBOutlet NSSearchField *searchField;
	IBOutlet NSMenuItem *saveSearchMenuItem;
    IBOutlet NSTableView *myTableView;
	
	NSURL *myUrl;
	BOOL setButtonOK;
}

- (IBAction)checkEnter:(id)sender;
- (IBAction)checkEditEnter:(id)sender;
- (BOOL) validateUrl: (NSString *) candidate;
- (IBAction)setButtonOKBoolNO:(id)sender;
- (IBAction)setButtonOKBoolYES:(id)sender;


@end
