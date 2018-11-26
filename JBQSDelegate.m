//
//  JBQSDelegate.m
//  Go2
//
//  Created by Jonathan Buys on 12/7/11.
//  Copyright (c) 2011 Farmdog Software. All rights reserved.
//

#import "JBQSDelegate.h"

@implementation JBQSDelegate

- (void)awakeFromNib
{
    [quickSearchPanel setHidesOnDeactivate:YES];
    NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
    [notifCenter addObserver:self selector:@selector(windowDidResignKey:) name:NSWindowDidResignKeyNotification object:quickSearchPanel];

}
//- (void)windowDidBecomeKey:(NSNotification *)notif {
//    [NSCursor unhide];
//}

- (void)windowDidResignKey:(NSNotification *)notif {
     [quickSearchPanel orderOut:NSApp];
}

- (void)openMenu
{
    if ([quickSearchPanel isVisible]) 
    {
        [quickSearchPanel orderOut:NSApp];
    } else {
        
        NSString *imageName;
        NSImage *tempImage;
        
        imageName = [[NSBundle mainBundle] pathForResource:@"search" ofType:@"png"];
        tempImage = [[NSImage alloc] initWithContentsOfFile:imageName];	// note no need to retain since we call "alloc"

        [tempImage setSize: NSMakeSize(128,128)];
        
        [quickSearchImageView setImage:tempImage];
        [tempImage release];
            //[quickSearchLabel setStringValue:@"Type to Search"];
        NSString *typeToSearch = NSLocalizedString(@"Type to Search", nil);
        [quickSearchPanel setTitle:typeToSearch];

        [quickSearchTextField setStringValue:@""];
        [quickSearchURL setStringValue:@""];
        [quickSearchLabel setStringValue:@""];
//        [quickSearchImageView setImageScaling:NSScaleProportionally];
        [quickSearchPanel center];
        [quickSearchPanel makeKeyAndOrderFront:NSApp];
            // [NSCursor hide];
        [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    }
}

//- (void)closeMenu
//{
//    [quickSearchPanel orderOut:NSApp];
//}

- (void)controlTextDidChange:(NSNotification *)obj
{
    NSArray *filteredArray;

        //NSLog(@"logging: %@", obj);
    	// I guess I'm not going to use this
//	obj = nil;
    
        // Build the search
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(hostName contains[cd] %@) OR (url contains %@)", [quickSearchTextField stringValue] , [quickSearchTextField stringValue]];
	
        // Get all of our objects from core data
	NSArray *array = nil;
	array = [hostsController arrangedObjects];
	

    
    if (array != nil)
	{
            // Build the new array
		filteredArray = nil;
		filteredArray = [array filteredArrayUsingPredicate:predicate];
        
//        if ([array count] > 0) 
//        {
//            id jbObject = [filteredArray objectAtIndex:0];
//            NSImage *tempImage = [[NSWorkspace sharedWorkspace] iconForFile:[jbObject valueForKey:@"iconImage"]];
//            [tempImage setSize: NSMakeSize(128,128)];
//            [quickSearchImageView setImage:tempImage];
//            [quickSearchLabel setStringValue:[jbObject valueForKey:@"url"]];
//
//        }
        
		for (id jbObject in filteredArray)
		{
            NSImage *tempImage = [[NSWorkspace sharedWorkspace] iconForFile:[jbObject valueForKey:@"iconImage"]];
            [tempImage setSize: NSMakeSize(128,128)];

            [quickSearchImageView setImage:tempImage];
            [quickSearchLabel setStringValue:[jbObject valueForKey:@"hostName"]];
            [quickSearchURL setStringValue:[jbObject valueForKey:@"url"]];
		}
        
        myInt = 1;
	}

}


- (BOOL)control:(NSControl *)control textView:(NSTextView *)fieldEditor doCommandBySelector:(SEL)commandSelector
{           
    BOOL retval = NO;
    
    if (commandSelector == @selector(insertNewline:)) 
    {
        
        retval = YES; // causes Apple to NOT fire the default enter action
        
            // Do your special handling of the "enter" key here
        [self openBookmark:[NSURL URLWithString:[quickSearchURL stringValue]]];
        [quickSearchPanel orderOut:NSApp];
        
    }
    
    if (commandSelector == @selector(cancelOperation:)) 
    {
        retval = YES;
        [quickSearchPanel orderOut:NSApp];

    }

	if( [NSStringFromSelector( commandSelector ) isEqualToString:@"moveDown:"] )
	{
        retval = YES;	
        [self rotateThroughFilteredArray];
	}

    
    return retval;  
}


- (void)rotateThroughFilteredArray
{
    NSArray *filteredArray;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(hostName contains[cd] %@) OR (url contains %@)", [quickSearchTextField stringValue] , [quickSearchTextField stringValue]];
	
        // Get all of our objects from core data
	NSArray *array = nil;
	array = [hostsController arrangedObjects];
	
    
    
    if (array != nil)
	{
            // Build the new array
		filteredArray = nil;
		filteredArray = [array filteredArrayUsingPredicate:predicate];

    NSUInteger numberOfBookmarks = [filteredArray count];
    
    if (numberOfBookmarks - 1 > myInt) 
    {
        myInt++;
    } else {
        myInt = 0;
    }
    
    id jbObject = [filteredArray objectAtIndex:myInt];
    NSImage *tempImage = [[NSWorkspace sharedWorkspace] iconForFile:[jbObject valueForKey:@"iconImage"]];
    [tempImage setSize: NSMakeSize(128,128)];
    
    [quickSearchImageView setImage:tempImage];
    [quickSearchLabel setStringValue:[jbObject valueForKey:@"hostName"]];
    [quickSearchURL setStringValue:[jbObject valueForKey:@"url"]];

    }
}



-(void)openBookmark:(NSURL *)url
{
//    [NSCursor unhide];

		
	NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
	[workSpace openURL:url];	
}

@end
