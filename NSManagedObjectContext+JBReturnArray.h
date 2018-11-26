//
//  NSManagedObjectContext+JBReturnArray.h
//  Go2
//
//  Created by Jonathan Buys on 2/11/11.
//  Copyright 2011 Farmdog Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSManagedObjectContext (JBReturnArray) 
- (NSArray *)fetchObjectsForEntityName:(NSString *)newEntityName withPredicate:(id)searchPredicate;
@end
