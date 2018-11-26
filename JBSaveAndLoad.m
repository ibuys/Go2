//
//  JBSaveAndLoad.m
//  Steps
//
//  Created by Jonathan Buys on 2/1/11.
//  Copyright 2011 Farmdog Software. All rights reserved.
//

#import "JBSaveAndLoad.h"


@implementation JBSaveAndLoad

//- (id)init
//{
//	[super init];
//	return self;
//}

- (void)dealloc
{
	[super dealloc];
}


- (BOOL)saveBookmarks
{
	
	NSArray *saveArray = [coreArrayController arrangedObjects];
		
	for (NSManagedObject *bookmarkObject in saveArray)
	{
		[self saveSingleBookmark:bookmarkObject];
	}
	
	return YES;
}

- (BOOL)saveSingleBookmark:(NSManagedObject *)bookmarkObject
{
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSError *error = nil;
	BOOL isDir;
	
    NSString *go2SupportDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Go2Data"];
    
    
        // OK, let's play around with this a bit:
    
//    NSString *normalPath = @"/Users/";
//    
//    NSString *realHomeDir = [normalPath stringByAppendingPathComponent:NSUserName()];
//    
//    
//    NSString *go2SupportDir = [realHomeDir stringByAppendingPathComponent:@"Public/Go2Data"];
//    NSLog(@"go2Supportdir = %@", go2SupportDir);

    
    
	NSURL *url = [NSURL fileURLWithPath:go2SupportDir];

	// Check for the Go2Data directory
	if ([fileManager fileExistsAtPath:go2SupportDir isDirectory:&isDir] && isDir) {
		//NSLog(@"Directory Exists");
		
	} else {
		if (![fileManager createDirectoryAtPath:go2SupportDir withIntermediateDirectories:NO attributes:nil error:&error]) {
			[fileManager release];
			NSLog(@"Error: %@", error);
			return NO;
		}
	}
	// End Check for Go2Data Directory	
	
	
	NSArray *keys = [NSArray arrayWithObjects:@"bookmarkName", @"bookmarkURL", nil];
	NSArray *objects = [NSArray arrayWithObjects:[bookmarkObject valueForKey:@"hostName"], [bookmarkObject valueForKey:@"url"], nil];
	NSDictionary *bookmark = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	NSString *bookMarkNameWithExt = [NSString stringWithFormat:@"%@ %@.go2", [bookmarkObject valueForKey:@"urlScheme"], [bookmark valueForKey:@"bookmarkName"]];
	//NSString *bookMarkNameWithExt = [[bookmark valueForKey:@"bookmarkName"] stringByAppendingPathExtension:@"go2"];
	NSURL *bookmarkURL = [url URLByAppendingPathComponent:bookMarkNameWithExt];
		
	if ([bookmarkURL checkResourceIsReachableAndReturnError:&error] == NO) 
	{
		if (![bookmark writeToURL:bookmarkURL atomically:YES]) 
		{
			[fileManager release];
			[error release];
			NSLog(@"Error saving data");
			return NO;
		}
		
	} else {
		//NSLog(@"File Exists");
		
		int i=1;
		
		// Increment the file name number according to how many are alread there. 
		// This should be in accordance with the Finder's duplicate file naming pattern.
		while ([bookmarkURL checkResourceIsReachableAndReturnError:&error] == YES) 
		{
			NSMutableString *dupName = [NSMutableString stringWithString:[bookmark valueForKey:@"bookmarkName"]];
			[dupName appendString:[NSString stringWithFormat:@"-%d", i]];
			bookMarkNameWithExt = [dupName stringByAppendingPathExtension:@"go2"];
			
			bookmarkURL = [url URLByAppendingPathComponent:bookMarkNameWithExt];
		//	NSLog(@"Duplicate Bookmark URL: %@", bookmarkURL);
			
			i++;
		}
		
		if (![bookmark writeToURL:bookmarkURL atomically:YES]) 
		{
			[fileManager release];
			[error release];
			NSLog(@"Error saving data");
			return NO;
		}
		
	}
	
	[bookmarkObject setValue:[bookmarkURL absoluteString] forKey:@"customPort"];

	[fileManager release];


	return YES;

}


- (BOOL)deleteBookmark:(NSArray *)bookmarkArray
{
	
	if ([bookmarkArray count] == 0) 
	{
		return NO;
	}
	
	for (NSManagedObject *bookmark in bookmarkArray)
	{
	//	NSLog(@"Value Stored in customPort = %@", [bookmark valueForKey:@"customPort"]);
		
		NSFileManager *fileManager = [[NSFileManager alloc] init];
		NSError *error = nil;
		BOOL isDir;
		
        NSString *go2SupportDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Go2Data"];
		
        
            // OK, let's play around with this a bit:
        
//        NSString *normalPath = @"/Users/";
//        
//        NSString *realHomeDir = [normalPath stringByAppendingPathComponent:NSUserName()];
//        
//        
//        NSString *go2SupportDir = [realHomeDir stringByAppendingPathComponent:@"Public/Go2Data"];
//        NSLog(@"go2Supportdir = %@", go2SupportDir);
        
		// Check for the Go2Data directory
		if (![fileManager fileExistsAtPath:go2SupportDir isDirectory:&isDir] && isDir) {
			
			[fileManager release];
			[error release];
			return NO;
		} 
		// End Check for Go2Data Directory
		
//		NSURL *url = [NSURL fileURLWithPath:go2SupportDir];
//		NSString *bookMarkNameWithExt = [[bookmark valueForKey:@"hostName"] stringByAppendingPathExtension:@"go2"];
		//NSURL *bookmarkURL = [url URLByAppendingPathComponent:bookMarkNameWithExt];
			
		NSURL *bookmarkURL = [NSURL URLWithString:[bookmark valueForKey:@"customPort"]];
		
		
		if ([fileManager removeItemAtURL:bookmarkURL error:&error]) 
		{
		//	NSLog(@"Bookmark %@ Removed!", bookmarkURL);
		} else {
			NSLog(@"Bookmark not removed from Spotlight index");
		}
		
		[error release];
		[fileManager release];
	}


	return YES;
}

@end
