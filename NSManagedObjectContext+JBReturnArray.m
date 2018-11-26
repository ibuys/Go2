//
//  NSManagedObjectContext+JBReturnArray.m
//  Go2
//
//  Created by Jonathan Buys on 2/11/11.
//  Copyright 2011 Farmdog Software. All rights reserved.
//

#import "NSManagedObjectContext+JBReturnArray.h"
#import "Go2_AppDelegate.h"

@implementation NSManagedObjectContext(JBReturnArray)

- (NSManagedObjectContext*)managedObjectContext
{
    return [(Go2_AppDelegate *)[[NSApplication sharedApplication] delegate] managedObjectContext];
}


// Convenience method to fetch the array of objects for a given Entity
// name in the context, optionally limiting by a predicate or by a predicate
// made from a format NSString and variable arguments.
//
- (NSArray *)fetchObjectsForEntityName:(NSString *)newEntityName withPredicate:(id)searchPredicate
{
    NSEntityDescription *entity = [NSEntityDescription
								   entityForName:newEntityName inManagedObjectContext:[self managedObjectContext]];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] 
										initWithKey:@"hostName"
										ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor
														  count:1];
	
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entity];
	[request setFetchLimit:35];
	[request setSortDescriptors:sortDescriptors];
    [sortDescriptors release];
    
    if (searchPredicate)
    {
        NSPredicate *predicate;
		NSAssert([searchPredicate isKindOfClass:[NSPredicate class]],
					  @"Second parameter passed to %s is of unexpected class %@",
					  sel_getName(_cmd), [searchPredicate className]);
					  predicate = (NSPredicate *)searchPredicate;
		
        [request setPredicate:predicate];
    }
	
    NSError *error = nil;
    NSArray *results = [self executeFetchRequest:request error:&error];
    if (error != nil)
    {
      //  [NSException raise:NSGenericException format:[error description]];
        NSLog(@"error in NSmanagedObjectContext+JBReturnArray.m");
    }
    
    return results;
}

@end
