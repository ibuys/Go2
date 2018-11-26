//
//  JBLaunch.m
//  Go2
//
//  Created by Jonathan Buys on 2/5/11.
//  Copyright 2011 Farmdog Software. All rights reserved.
//

#import "JBLaunch.h"


@implementation JBLaunch

//- (id)init
//{
//    
//	[super init];
//	return self;
//}

- (void)dealloc
{
	[super dealloc];
}

- (BOOL)launchFromFile:(NSString *)filename
{
	NSLog(@"Called launchFromFile method for this file: %@", filename);
		
	NSDictionary *bookmarkDictionary = [NSDictionary dictionaryWithContentsOfFile:filename];
	
	if (bookmarkDictionary == nil) 
	{
		NSLog(@"bookmarkDictionary is nil");
		return NO;
	}

		

	NSURL *launchURL = [NSURL URLWithString:[bookmarkDictionary valueForKey:@"bookmarkURL"]];
	
	if (launchURL == nil) 
	{
		NSLog(@"launchURL is nil");
		return NO;
	}
	
	//NSLog(@"launchURL = %@", launchURL);

	NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
	[workSpace openURL:launchURL];	
	[[NSApplication sharedApplication] hide:nil];
	return YES;
}

@end
