//
//  JBSaveAndLoad.h
//  Steps
//
//  Created by Jonathan Buys on 2/1/11.
//  Copyright 2011 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBSaveAndLoad : NSObject 
{
	IBOutlet NSArrayController *coreArrayController;
}


- (BOOL)saveBookmarks;
- (BOOL)saveSingleBookmark:(NSManagedObject *)bookmarkObject;
- (BOOL)deleteBookmark:(NSArray *)bookmarkArray;

@end
