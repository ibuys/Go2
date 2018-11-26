//
//  JBTableView.m
//  Go
//
//  Created by Jonathan Buys on 9/12/10.
//  Copyright 2010 Farmdog Software. All rights reserved.
//

#import "JBTableView.h"


@implementation JBTableView

- (NSMenu *)menuForEvent:(NSEvent *)theEvent
{
	if ([theEvent type] == NSEventTypeRightMouseDown)
	{
		// get the current selections for the outline view. 
		NSIndexSet *selectedRowIndexes = [self selectedRowIndexes];
		
		// select the row that was clicked before showing the menu for the event
		NSPoint mousePoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
		NSInteger row = [self rowAtPoint:mousePoint];
        
        if (row == -1) 
        {
            return nil;
        }
		
		// figure out if the row that was just clicked on is currently selected
		if ([selectedRowIndexes containsIndex:row] == NO)
		{
			NSIndexSet *newSelectedRowIndexes = [NSIndexSet indexSetWithIndex:row];
			[self selectRowIndexes:newSelectedRowIndexes byExtendingSelection:NO];
			// NSLog(@"OK, right click!");
		}
		selectedRowIndexes = nil;
		
		// else that row is currently selected, so don't change anything.
        
            // NSLog(@"row: %d", row);
	}
	[self setMenu:rightClickMenu];
	return [super menuForEvent:theEvent];
}

- (void)textDidEndEditing:(NSNotification *)notification
{
	//[myMenuApplet updateMenuApp];
	[super textDidEndEditing: notification];
}


@end
