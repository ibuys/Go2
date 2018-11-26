//
//  JBStatusItemView.h
//  Go2
//
//  Created by Jonathan Buys on 10/28/10.
//  Copyright 2010 Farmdog Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JBMenuItem.h"
#import "JBSaveAndLoad.h"

@class MAAttachedWindow;
@class JBNiceWindow;

@interface JBStatusItemView: NSView
{
	BOOL highlighted;
    BOOL toggleWindow;
	IBOutlet JBMenuItem *myMenuApplet;
    IBOutlet NSMenu *rightClickMenu;
    IBOutlet JBSaveAndLoad *saveManager;
    IBOutlet JBNiceWindow *jbNiceWindow;
    
    MAAttachedWindow *attachedWindow;
    
    IBOutlet NSView *view;
    IBOutlet NSTextField *textField;

        // NSString *previousApp;
}

- (void)popUpTheMenuAfterDelay;
- (void)popUpRightClickMenuAfterDelay;

- (void)setHighlightOn;
- (void)setHighlightOff;
- (void)toggleAttachedWindowAtPoint:(NSPoint)pt;
- (void)toggleAttachedWindowAtPointDup:(NSPoint)pt;
- (void)doToggle;
- (void)doToggleDup;

    //- (void)appDidChange;
@end
