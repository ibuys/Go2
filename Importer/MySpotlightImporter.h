//
//  MySpotlightImporter.h
//  Go2
//
//  Created by Jonathan Buys on 10/27/10.
//  Copyright Farmdog Software 2010 . All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MySpotlightImporter : NSObject {

    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    
    NSURL *modelURL;
    NSURL *storeURL;
}

@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

- (BOOL)importFileAtPath:(NSString *)filePath attributes:(NSMutableDictionary *)attributes error:(NSError **)error;

@end
