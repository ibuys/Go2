//
//  JBSourceListDelegate.m
//  Go2
//
//  Created by Jonathan Buys on 12/9/15.
//
//

#import "JBSourceListDelegate.h"

@implementation JBSourceListDelegate

@synthesize window = _window;
@synthesize dataModel = _dataModel;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    // Make some fake data for our source list.
    NSMutableDictionary* item1 = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Item 1", @"itemName", [NSMutableArray array], @"children", nil];
    NSMutableDictionary* item2 = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Item 2", @"itemName", [NSMutableArray array], @"children", nil];
    NSMutableDictionary* item2_1 = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Item 2.1", @"itemName", [NSMutableArray array], @"children", nil];
    NSMutableDictionary* item2_2 = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Item 2.2", @"itemName", [NSMutableArray array], @"children", nil];
    NSMutableDictionary* item2_2_1 = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Item 2.2.1", @"itemName", [NSMutableArray array], @"children", nil];
    NSMutableDictionary* item2_2_2 = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Item 2.2.2", @"itemName", [NSMutableArray array], @"children", nil];
    NSMutableDictionary* item3 = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Item 3", @"itemName", [NSMutableArray array], @"children", nil];
    
    [[item2_2 objectForKey: @"children"] addObject: item2_2_1];
    [[item2_2 objectForKey: @"children"] addObject: item2_2_2];
    
    [[item2 objectForKey: @"children"] addObject: item2_1];
    [[item2 objectForKey: @"children"] addObject: item2_2];
    
    NSMutableArray* dataModel = [NSMutableArray array];
    
    [dataModel addObject: item1];
    [dataModel addObject: item2];
    [dataModel addObject: item3];
    
    self.dataModel = dataModel;
}

- (void)dealloc
{
    [_dataModel release];
    [super dealloc];
}


@end
