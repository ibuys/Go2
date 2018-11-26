//
//  JBNiceWindow.h
//  Scout
//
//  Created by Jonathan Buys on 1/29/10.
//  Copyright 2010 B6 Systems Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>


@interface JBNiceWindow : NSWindow 
{
	IBOutlet NSToolbar *myToolBar;
	IBOutlet NSTableView *hostTableView;
}

- (void)toggleToolbarShown:(id)sender;

@end
