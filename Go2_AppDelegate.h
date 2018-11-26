//
//  Go2_AppDelegate.h
//  Go2
//
//  Created by Jonathan Buys on 10/27/10.
//  Copyright Farmdog Software 2010 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JBMenuItem.h"
#import "ImportText.h"
#import "JBLaunch.h"
#import "JBSaveAndLoad.h"

@class JBStatusItemView;

@interface Go2_AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSWindow *window;
    IBOutlet JBMenuItem *myMenuApplet;
	IBOutlet NSArrayController *hostsController;
	IBOutlet ImportText *importTexter;
    IBOutlet NSTableView *hostListTableView;	

    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
	
	NSEvent *_eventMonitor;
	
	IBOutlet NSMenuItem *openBookmarkMenuItem;
	IBOutlet NSMenuItem *editBookmarkMenuItem;
	IBOutlet NSMenuItem *removeBookmarkMenuItem;
	
	IBOutlet NSMenuItem *smallOpenBookmarkMenuItem;
	IBOutlet NSMenuItem *smallEditBookmarkMenuItem;
	IBOutlet NSMenuItem *smallRemoveBookmarkMenuItem;
	
    IBOutlet JBSaveAndLoad *saveManager;
	IBOutlet JBStatusItemView *go2StatusItemView;


}

@property (nonatomic, retain) IBOutlet NSWindow *window;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;


- (IBAction)saveAction:sender;
- (IBAction)enableMenu:sender;
- (IBAction)disableMenu:sender;

@end
