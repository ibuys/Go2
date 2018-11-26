//
//  AppController.m
//  Go
//
//  Created by Jon Buys on 7/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "JBTableViewCell.h"

NSString * const B6DefaultUserName = @"DefaultUserName";
NSString * const B6UnixCheckBoxKey = @"B6UnixCheckBoxKey";

BOOL hostCheckRunning;
BOOL runWhileLoop;

@implementation AppController


+ (void)initialize
{
	// Create a dictionary
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	
	NSString *userName = NSUserName();
	[defaultValues setObject:userName forKey:B6DefaultUserName];
	
	// Register the dictionary of defaults
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
	
	defaultValues = nil;
	userName = nil;
}

- (void)awakeFromNib
{
	JBTableViewCell *infoCell = [[JBTableViewCell alloc] init];
	[mainTableColumn setDataCell:infoCell];
	[infoCell release];
	
	
	BOOL iconInDock = [[NSUserDefaults standardUserDefaults] boolForKey:@"hideIcon"];

	if (iconInDock) 
	{
		[dropDownMenuButton setHidden:YES];
	}
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
    [hostList selectRowIndexes:indexSet byExtendingSelection:NO];
    [obvController appDidLaunch];

}



- (IBAction)sendFeedback:(id)sender
{
	sender = nil;
	NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
	[workSpace openURL:[NSURL URLWithString:@"mailto:comments@jonathanbuys.com"]];	
}


- (void)dealloc
{
    [super dealloc];
}

@end
