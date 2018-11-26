//
//  JBTableViewDelegate.m
//  Go
//
//  Created by Jon Buys on 7/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JBTableViewDelegate.h"


@implementation JBTableViewDelegate


- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{    
        //NSLog(@"New Row = %ld", [tableView selectedRow]);
	if ([tableView selectedRow] == -1) 
	{
            //NSLog(@"No Row Selected!");
		[mainButtons setEnabled:NO forSegment:1];
		[mainButtons setEnabled:NO forSegment:2];
		[myAppDelegate disableMenu:nil];
        [numberOfHostsTextView setStringValue:@""];


	} else {
		[mainButtons setEnabled:YES forSegment:1];
		[mainButtons setEnabled:YES forSegment:2];
		[myAppDelegate enableMenu:nil];
	}
	
	
}


//- (void)tableView:(NSTableView *)tableView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row
//{
//    NSLog(@"Did add row");
//}
//
//- (void)tableView:(NSTableView *)tableView didRemoveRowView:(NSTableRowView *)rowView forRow:(NSInteger)row
//{
//    NSLog(@"removed row");
//}

- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    NSString *hostString = NSLocalizedString(@"Host", nil);
	NSString *hostPluralString = NSLocalizedString(@"Hosts", nil);	
	

//    if ([tableView numberOfRows] < 0) 
//	{
//            //NSLog(@"No Rows!");
//		[numberOfHostsTextView setTitleWithMnemonic:@""];
//		
//	} else {
//		
//            // NSLog(@"Number of Rows: %ld", [tableView numberOfRows]);
//        
		if ([tableView numberOfRows] > 1) 
		{
			[numberOfHostsTextView setStringValue:[NSString stringWithFormat: @"%lu %@",[tableView numberOfRows], hostPluralString] ];
		} else {
			
			[numberOfHostsTextView setStringValue:[NSString stringWithFormat: @"%lu %@",[tableView numberOfRows], hostString] ];
		}
        //	}

    hostString = nil;
	hostPluralString = nil;

        //  NSLog(@"tableview willdisplaycell");
}

@end
