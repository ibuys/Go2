    //
    //  ImportText.m
    //  Known Hosts
    //
    //  Created by Jonathan Buys on 12/12/09.
    //  Copyright 2009 B6 Systems Inc.. All rights reserved.
    //

#import "ImportText.h"
#import "JBGetDefaultApps.h"
#import "JBStatusItemView.h"
#import "Go2_AppDelegate.h"

@implementation ImportText

#pragma mark Importing
-(IBAction)import:(id)sender {
	
	sender = nil;
	
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseDirectories:NO];
	
    [panel beginSheetModalForWindow:[tableView window] completionHandler:^(NSInteger result){
        
        if ( result == NSModalResponseOK )
        {
            
                // Grab the entire file as one string
            NSString *configString = [NSString stringWithContentsOfURL:[panel URL] encoding:NSUTF8StringEncoding error:nil];
                // Break out the string contents by line into an array
            NSArray *cvsItems = [configString componentsSeparatedByString:@"\n"];
            
                // Debug stuff
//                NSString *s = [cvsItems objectAtIndex:0];
//                NSLog(@"Here is the first item in the array: %@", [cvsItems objectAtIndex:0]);
//            
                //              // Loop through the array created above
                //              NSEnumerator* myIterator = [cvsItems objectEnumerator];
                //              id anObject;
            
            for (NSString *anObject in cvsItems)
            {
                    //NSLog(@"anObject = %@", anObject);
                
                if ( anObject.length == 0  ) 
                {
                    // This is a shoddy way to do things. 
                    
                } else {
                        // More debug logging
                        // NSLog(@"Here's an object %@", anObject);
                    
                    NSManagedObject *newFoo;
                    NSString *urlString;
                    NSString *hostNameString;
                    
                    newFoo = [NSEntityDescription insertNewObjectForEntityForName:@"Hosts" inManagedObjectContext:[self managedObjectContext]];
                    

                    // July 11, 2012 - Added this if/else section to deal with imported files that have only one url per line, and no commas. 
                    
                
                    if ([anObject rangeOfString:@","].location != NSNotFound) 
                    {
                        NSArray *contents = [anObject componentsSeparatedByString:@","];
                        urlString = [contents objectAtIndex:0];
                        urlString = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];	

                        hostNameString = [contents objectAtIndex:1];
                    } else {
                        
                        NSString *urlRegEx = @"[a-z]{2,9}://[a-z|0-9]*.*";
                        NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx]; 
                        
                        if ([urlTest evaluateWithObject:anObject]) 
                        {
                            urlString = anObject;
                            urlString = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];	
                            hostNameString = [[NSURL URLWithString:anObject] host];

                        } else {
                            NSLog(@"Sorry, there was something wrong with the import file.");
                            urlString = NULL;
                        }
                    }

                    
                    if (urlString != NULL) // Why am I checking this twice?
                    {
                        [newFoo setValue:urlString forKeyPath:@"url"];
                        
                        newURL = [NSURL URLWithString:[newFoo valueForKey:@"url"]];
                        
                        NSLog(@"newURL %@", newURL);
                        
                        [newFoo setValue:[newURL host] forKey:@"hostName"];
                        [newFoo setValue:[newURL user] forKey:@"userName"];
                        [newFoo setValue:[newURL scheme] forKey:@"urlScheme"];
                        
                        newURL = [NSURL URLWithString:urlString];
                        
                        
                        JBGetDefaultApps *getDefaultApps = [[JBGetDefaultApps alloc] init];
                        NSURL *defaultAppURL = [getDefaultApps getDefaultApp:[newURL scheme]];
                        [getDefaultApps release];
                        
                        [newFoo setValue:[defaultAppURL path] forKey:@"iconImage"];
                        
                        if (hostNameString) 
                        {
                            [newFoo setValue:hostNameString forKeyPath:@"hostName"];
                        } else {
                            [newFoo setValue:[newURL host] forKey:@"hostName"];
                        }
                        
                        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"allowSpotlight"]) 
                        {
                            if (![saveManager saveSingleBookmark:newFoo]) 
                            {
                                NSLog(@"Ummm... something is not working");       
                            }
                        }
                    }
                }
            } // I loves me some brackets! I should refactor this code.
            
            configString = nil;
            cvsItems = nil;
        }
    }];
}


#pragma mark Exporting

- (IBAction)save:(id)sender
{
	sender = nil;
	
	NSString *saveString = @""; // = [[NSString alloc] init];
    
	NSArray *selectedObjectsArray = [hostsController arrangedObjects];
	
	NSEnumerator *enm = [selectedObjectsArray objectEnumerator];
	id i;
	while( (i = [enm nextObject]) ) {
		
		NSString *urlString = [i valueForKey:@"url"];
		if (urlString)
		{
			saveString = [saveString stringByAppendingString:urlString];
                //			saveString = [NSString stringWithFormat: @"%@\n", saveString];
		}
		urlString = nil;
        NSString *hostName = [i valueForKey:@"hostName"];
        if (hostName) 
        {
            saveString = [saveString stringByAppendingString:@","];
            saveString = [saveString stringByAppendingString:hostName];
        }
        
        saveString = [NSString stringWithFormat: @"%@\n", saveString];
        
	}
    
        //NSLog(@"saveString = %@", saveString);
    
        // This stuff below here works fine.  It's getting the string to save that's killing me.
	
	NSSavePanel *sp;
	NSInteger runResult;
	
	/* create or get the shared instance of NSSavePanel */
	sp = [NSSavePanel savePanel];
	
	/* set up new attributes */
	
    [sp setAllowedFileTypes:[NSArray arrayWithObject:@"txt"]];
	
	/* display the NSSavePanel */
    runResult = [sp runModal];
        //    NSLog(@"Here's teh URL to write to: %@", [[sp URL] absoluteString]);
	
	/* if successful, save file under designated name */
	if (runResult == NSModalResponseOK) {
        if (![saveString writeToURL:[sp URL] atomically:YES encoding:NSUTF8StringEncoding error:nil])
            
			NSBeep();
	}
	
	selectedObjectsArray = nil;
	enm = nil;
	i = nil;
	sp = nil;
	
}

#pragma mark-
#pragma mark Other Import Options

- (IBAction)importSafariBookmarks:(id)sender
{
	
	
//	NSString *pathToSafariBookmarks = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Safari/Bookmarks.plist"];
//	
//	NSData* plistData = [NSData dataWithContentsOfFile:pathToSafariBookmarks];
//	NSError *error;
////	NSPropertyListFormat format;
//    NSDictionary *safariBookmarks = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:NSPropertyListXMLFormat_v1_0 error:&error];
////	NSDictionary* safariBookmarks = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
//        //	NSLog( @"plist is %@", plist );
//        //	if(!plist){
//        //        NSLog(@"Error: %@",error);
//        //        [error release];
//        //	}
//	
//	
//        //    // load the preferences dictionary
//        //    NSDictionary *safariBookmarks = [NSDictionary dictionaryWithContentsOfFile:pathToSafariBookmarks];
//        //	
//        // if the file was there, we got all the information we need.
//    if (safariBookmarks) 
//	{
//            //NSLog(@"Here's the bookmarks: %@", safariBookmarks);
//		for (NSString *bookmark in [safariBookmarks objectEnumerator])
//		{
//                NSLog(@"here: %@", bookmark);
//		}
//		
//		
//		
//    } else {
//		
//		NSLog(@"No bookmarks");
//    }
	
}


- (void)importFromBookmarklet:(NSString *)urlString
{
    urlString = [urlString stringByReplacingOccurrencesOfString:@"go2:url=" withString:@""];
        //	NSLog(@"urlString: %@", urlString);
    
    
        //NSLog(@"urlString: %@", urlString);
    
    NSArray *splitURLString = [urlString componentsSeparatedByString:@"title="];
    
        //NSLog(@"splitURLString Array: %@", splitURLString);
    
    NSString *finalURLString = [splitURLString objectAtIndex:0];
    NSString *encodedTitleString = [splitURLString objectAtIndex:1];
//    NSString *finalTitleString = [encodedTitleString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *finalTitleString = [encodedTitleString stringByRemovingPercentEncoding];
    
        //	NSLog(@"finalURLString = %@", finalURLString);
        //	NSLog(@"finalTitleString = %@", finalTitleString);
    
    NSURL *bookmarkletURL = [NSURL URLWithString:urlString];

    
        //  NSLog(@"urlString: %@", urlString);
    
        // Duplicate check
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Hosts" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
        // Set example predicate and sort orderings...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(url LIKE[c] %@)", finalURLString];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"url" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if ([array count] >0)
    {
        [go2StatusItemView doToggleDup];
        
        [NSTimer scheduledTimerWithTimeInterval:1.50
                                         target:go2StatusItemView
                                       selector:@selector(doToggleDup)
                                       userInfo:nil
                                        repeats:NO];
        
        
    } else {
        
        
        
        if (bookmarkletURL) 
        {
            NSManagedObject *newFoo;
            newFoo = [NSEntityDescription insertNewObjectForEntityForName:@"Hosts" inManagedObjectContext:[self managedObjectContext]];
            
            [newFoo setValue:finalURLString forKeyPath:@"url"];
            
            
                // NSLog(@"newURL %@", newURL);
            
            [newFoo setValue:finalTitleString forKey:@"hostName"];
            [newFoo setValue:[bookmarkletURL scheme] forKey:@"urlScheme"];
            
            JBGetDefaultApps *getDefaultApps = [[JBGetDefaultApps alloc] init];
            NSURL *defaultAppURL = [getDefaultApps getDefaultApp:[bookmarkletURL scheme]];
            [getDefaultApps release];
            
            [newFoo setValue:[defaultAppURL path] forKey:@"iconImage"];
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"allowSpotlight"]) 
            {
                if (![saveManager saveSingleBookmark:newFoo]) 
                {
                    NSLog(@"Ummm... something is not working");	
                }
            }
            
            
            [go2StatusItemView doToggle];
            
            [NSTimer scheduledTimerWithTimeInterval:1.50
                                             target:go2StatusItemView
                                           selector:@selector(doToggle)
                                           userInfo:nil
                                            repeats:NO];
            
        } //endif
    } //end else    
}

- (NSManagedObjectContext*)managedObjectContext
{
    return [(Go2_AppDelegate *)[[NSApplication sharedApplication] delegate] managedObjectContext];
}

@end
