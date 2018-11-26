//
//  Go2_AppDelegate.m
//  Go2
//
//  Created by Jonathan Buys on 10/27/10.
//  Copyright Farmdog Software 2010 . All rights reserved.
//

#import "Go2_AppDelegate.h"
#import "JBGetDefaultApps.h"
#import "JBStatusItemView.h"

// #define YOUR_EXTERNAL_RECORD_EXTENSION @"farmdog.go2"
#define YOUR_STORE_TYPE NSXMLStoreType

@implementation Go2_AppDelegate

@synthesize window;

/**
 Returns the support directory for the application, used to store the Core Data
 store file.  This code uses a directory named "Go2" for
 the content, either in the NSApplicationSupportDirectory location or (if the
 former cannot be found), the system's temporary directory.
 */

- (NSString *)applicationSupportDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:@"Go2"];
}

/**
 Returns the external records directory for the application.
 This code uses a directory named "Go2" for the content, 
 either in the ~/Library/Caches/Metadata/CoreData location or (if the
 former cannot be found), the system's temporary directory.
 */

- (NSString *)externalRecordsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:@"Metadata/CoreData/Go2"];
}

/**
 Creates, retains, and returns the managed object model for the application 
 by merging all of the models found in the application bundle.
 */

- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel) return managedObjectModel;
    
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.  This 
 implementation will create and return a coordinator, having added the 
 store for the application to it.  (The directory for the store is created, 
 if necessary.)
 */

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
    
    if (persistentStoreCoordinator) return persistentStoreCoordinator;
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSAssert(NO, @"Managed object model is nil");
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *applicationSupportDirectory = [self applicationSupportDirectory];
    NSError *error = nil;
    
    if ( ![fileManager fileExistsAtPath:applicationSupportDirectory isDirectory:NULL] ) {
        if (![fileManager createDirectoryAtPath:applicationSupportDirectory withIntermediateDirectories:NO attributes:nil error:&error]) {
            NSAssert(NO, ([NSString stringWithFormat:@"Failed to create App Support directory %@ : %@", applicationSupportDirectory,error]));
            NSLog(@"Error creating application support directory at %@ : %@",applicationSupportDirectory,error);
            return nil;
        }
    }
    
    //    NSString *externalRecordsDirectory = [self externalRecordsDirectory];
    //    if ( ![fileManager fileExistsAtPath:externalRecordsDirectory isDirectory:NULL] ) {
    //        if (![fileManager createDirectoryAtPath:externalRecordsDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
    //            NSLog(@"Error creating external records directory at %@ : %@",externalRecordsDirectory,error);
    //            NSAssert(NO, ([NSString stringWithFormat:@"Failed to create external records directory %@ : %@", externalRecordsDirectory,error]));
    //            NSLog(@"Error creating external records directory at %@ : %@",externalRecordsDirectory,error);
    //            return nil;
    //        };
    //    }
    
    NSURL *url = [NSURL fileURLWithPath: [applicationSupportDirectory stringByAppendingPathComponent: @"farmdog.go2.xml"]];
    
    // set store options to enable spotlight indexing
    
    NSMutableDictionary *storeOptions = [NSMutableDictionary dictionary];
    //    [storeOptions setObject:YOUR_EXTERNAL_RECORD_EXTENSION forKey:NSExternalRecordExtensionOption];
    //    [storeOptions setObject:externalRecordsDirectory forKey:NSExternalRecordsDirectoryOption];
    
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: mom];
    if (![persistentStoreCoordinator addPersistentStoreWithType:YOUR_STORE_TYPE 
                                                  configuration:nil 
                                                            URL:url 
                                                        options:storeOptions 
                                                          error:&error]){
        [[NSApplication sharedApplication] presentError:error];
        (void)([persistentStoreCoordinator release]), persistentStoreCoordinator = nil;
        return nil;
    }    
    
    return persistentStoreCoordinator;
}

/**
 Returns the managed object context for the application (which is already
 bound to the persistent store coordinator for the application.) 
 */

- (NSManagedObjectContext *) managedObjectContext {
    
    if (managedObjectContext) return managedObjectContext;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [managedObjectContext setPersistentStoreCoordinator: coordinator];
    
    return managedObjectContext;
}

/**
 Returns the NSUndoManager for the application.  In this case, the manager
 returned is that of the managed object context for the application.
 */

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window 
{       
    return [[self managedObjectContext] undoManager];
}


/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.  Any encountered errors
 are presented to the user.
 */

- (IBAction) saveAction:(id)sender {
    
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}


/**
 Implementation of the applicationShouldTerminate: method, used here to
 handle the saving of changes in the application managed object context
 before the application terminates.
 */

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender 
{
    
    if (!managedObjectContext) return NSTerminateNow;
    
    if (![managedObjectContext commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![managedObjectContext hasChanges]) return NSTerminateNow;
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        
        // This error handling simply presents error information in a panel with an 
        // "Ok" button, which does not include any attempt at error recovery (meaning, 
        // attempting to fix the error.)  As a result, this implementation will 
        // present the information to the user and then follow up with a panel asking 
        // if the user wishes to "Quit Anyway", without saving the changes.
        
        // Typically, this process should be altered to include application-specific 
        // recovery steps.  
        
        BOOL result = [sender presentError:error];
        if (result) return NSTerminateCancel;
        
        NSString *question = NSLocalizedString(@"Could not save changes while quitting.  Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];
        
        NSInteger answer = [alert runModal];
        [alert release];
        alert = nil;
        
        if (answer == NSAlertFirstButtonReturn) return NSTerminateCancel;
        
    }
    [[window windowController] setShouldCascadeWindows:NO];      // Tell the controller to not cascade its windows.
    [window setFrameAutosaveName:[window representedFilename]];  // Specify the autosave name for the window.
    
    
    
    return NSTerminateNow;
}


#pragma mark -
#pragma mark Custom Code

- (void)handleGetURLEvent:(NSAppleEventDescriptor*)event withReplyEvent:(NSAppleEventDescriptor*)replyEvent
{
    
    // NSLog(@"Called!");
    NSString* url = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    
    if ([url rangeOfString:@"go2:url=" options:NSCaseInsensitiveSearch].location != NSNotFound) 
    {
        [importTexter importFromBookmarklet:url];
    } 
    
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{
    
    [myMenuApplet createMenuApp];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"hostName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];  
    
    [hostsController setSortDescriptors:[NSArray arrayWithObject:sort]];  
    [sort release];
    

    
    

}

- (void)popUpTheMenuAfterDelay
{
    [myMenuApplet popUpStatusItemMenu];
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
    
    NSAppleEventManager *appleEventManager = [NSAppleEventManager sharedAppleEventManager];// 1
    [appleEventManager setEventHandler:self andSelector:@selector(handleGetURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
    [window makeKeyAndOrderFront:self];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication
                    hasVisibleWindows:(BOOL)flag
{
    if( !flag )
        [window makeKeyAndOrderFront:nil];
    
    return YES;
}

- (BOOL) application:(NSApplication *)theApplication openFile:(NSString *)filename
{
    // NSLog(@"Called! %@", filename);
    JBLaunch *launch = [[JBLaunch alloc] init];
    
    if ([launch launchFromFile:filename]) 
    {
        [launch release];
        return YES;
    } else {
        [launch release];
        return NO;
    }
}


/**
 Implementation of dealloc, to release the retained variables.
 */

- (void)dealloc {
    
    [window release];
    [managedObjectContext release];
    [persistentStoreCoordinator release];
    [managedObjectModel release];
    
    [super dealloc];
}


- (IBAction)enableMenu:sender
{
    [openBookmarkMenuItem setEnabled:YES];
    [editBookmarkMenuItem setEnabled:YES];
    [removeBookmarkMenuItem setEnabled:YES];
    [smallOpenBookmarkMenuItem setEnabled:YES];
    [smallEditBookmarkMenuItem setEnabled:YES];
    [smallRemoveBookmarkMenuItem setEnabled:YES];
}

- (IBAction)disableMenu:sender
{
    [openBookmarkMenuItem setEnabled:NO];
    [editBookmarkMenuItem setEnabled:NO];
    [removeBookmarkMenuItem setEnabled:NO];
    [smallOpenBookmarkMenuItem setEnabled:NO];
    [smallEditBookmarkMenuItem setEnabled:NO];
    [smallRemoveBookmarkMenuItem setEnabled:NO];
}

@end
