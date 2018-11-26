//
//  JBGetDefaultApps.m
//  Go
//
//  Created by Jonathan Buys on 9/14/10.
//  Copyright 2010 Farmdog Software. All rights reserved.
//

#import "JBGetDefaultApps.h"


@implementation JBGetDefaultApps

- (NSURL *)getDefaultApp:(NSString *)nameOfURL
{
        // NSLog(@"Passed from other app: %@", nameOfURL);
    NSString *finalizedURLScheme;
    
    if ([nameOfURL isEqualToString:@"file"]) 
    {
       finalizedURLScheme = @"go2:";
    } else {
        finalizedURLScheme = [nameOfURL stringByAppendingString:@":"];
    }
	
	//NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSURL *appURL = nil;
//	OSStatus err;
    NSURL *passedURL = [[NSURL alloc] initWithString:finalizedURLScheme];
    appURL = [[NSWorkspace sharedWorkspace] URLForApplicationToOpenURL: passedURL];
    [passedURL release];
    
//    err = LSCopyDefaultApplicationURLForURL((CFURLRef)[NSURL URLWithString:finalizedURLScheme], kLSRolesAll, (CFURLRef *)&appURL);
//    
//	err = LSGetApplicationForURL((CFURLRef)[NSURL URLWithString:finalizedURLScheme],kLSRolesAll, NULL, (CFURLRef *)&appURL);
    
	
	if (appURL == nil)
	{
		NSLog(@"error");
		return nil;

	} else {
		return appURL;
	}
}

@end
