//
//  JBOutlineViewController.m
//  CloudChain
//
//  Created by Jonathan Buys on 9/6/17.
//  Copyright © 2017 Fall Harvest. All rights reserved.
//

#import "JBOutlineViewController.h"
#import "Group.h"

#define DEFAULT_PREDICATE @"hostName CONTAINS[cd] '' AND urlScheme CONTAINS[cd] ''"
#define NSPERT NSPredicateEditorRowTemplate

@interface JBOutlineViewController()

@property (weak) IBOutlet NSOutlineView *outlineView;
@property (weak) IBOutlet NSTreeController *groupsController;

@end

@implementation JBOutlineViewController

- (id)init
{
    self = [super init];
    NSLog(@"JBOutlineViewController init");

    if (self != nil)
    {
        
        smartPredicateForEditor = [[NSPredicate predicateWithFormat:DEFAULT_PREDICATE] retain];
        
        [[NSNotificationCenter defaultCenter]
         addObserver: self
         selector: @selector(applicationWillTerminate:)
         name: NSApplicationWillTerminateNotification
         object: nil];

        [[NSNotificationCenter defaultCenter]
         addObserver: self
         selector: @selector(applicationDidFinishLaunching:)
         name: NSApplicationDidFinishLaunchingNotification
         object: nil];
    }
    return self;
}

- (BOOL)allowsVibrancy {
    return YES;
}

- (void)appDidLaunch
{
    self.outlineView.delegate = self;
    self.outlineView.dataSource = self;
    self.outlineView.floatsGroupRows = NO; // Prevent a sticky header
    
    
    NSString *go2_smart_data_path = [[self applicationSupportFolder] stringByAppendingPathComponent:@"go2_smartP_data"];
    NSFileManager *myDefaultManager = [[NSFileManager alloc] init];
    
    if ([myDefaultManager fileExistsAtPath:go2_smart_data_path])
    {
        [self loadDataFromFile];
    } else {
        [self addData];
    }
    [myDefaultManager release];

    
    // Expand the first group and select the first item in the list
    [self.outlineView expandItem:[self.outlineView itemAtRow:0]];
    [self.outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
    
    // Enable Drag and Drop
    [self.outlineView registerForDraggedTypes: [NSArray arrayWithObject: @"public.text"]];
}




- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    NSError *error;
    
    NSIndexPath *newPath =  [[NSIndexPath alloc] initWithIndex: 0];
    [self.groupsController setSelectionIndexPath:newPath];
    [newPath release];
    
    NSArray * afterArray = [self.groupsController selectedObjects];
    NSMutableDictionary *archiveArray = [afterArray objectAtIndex:0];

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:archiveArray requiringSecureCoding:NO error:&error];
    NSString *go2_name_data_path = [[self applicationSupportFolder] stringByAppendingPathComponent:@"go2_smartP_data"];
    
    if ([data writeToFile:go2_name_data_path atomically:YES])
    {
        NSLog(@"data saved!");
    } else {
        NSLog(@"data not saved...");
    }
    
}


#pragma mark - Add data

- (void) loadDataFromFile
{
    NSString *go2_smart_data_path = [[self applicationSupportFolder] stringByAppendingPathComponent:@"go2_smartP_data"];
    NSLog(@"JBOutlineViewController found go2_smartP_data");
    
    NSData *data = [NSData dataWithContentsOfFile:go2_smart_data_path];
    NSLog(@"Data: %@", data);
    
    NSMutableDictionary *root = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"archiveArray = %@", root);
    NSLog(@"sourceListItems = %@", sourceListItems);
    NSLog(@"sourceListItems after = %@", sourceListItems);
    [self.groupsController addObject:root];
}





- (void) addData
{
    
    // `children` and `isLeaf` have to be configured for the Tree Controller in IB
    NSDictionary *initalizeDict = @{@"title": @"LIBRARY",
                                  @"isLeaf": @(NO),
                                  @"children":@[
                                        [Group groupWithTitle:@"All Bookmarks"],
                                        [Group groupWithTitle:@"Web"],
                                        [Group groupWithTitle:@"Secure Shell"],
                                        [Group groupWithTitle:@"VNC Connections"],
                                        [Group groupWithTitle:@"FTP Servers"]
                                          ]
                                  };
    
    NSMutableDictionary *root = [[NSMutableDictionary alloc] initWithDictionary:initalizeDict];
    [self.groupsController addObject:root];
    [root release];
}


- (IBAction)addClicked:(id)sender {
    
    
    [textValidator setButtonOKBoolNO:nil];
    
    
    NSPERT * template = [[NSPERT alloc] initWithLeftExpressions:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"hostName"]]
                                   rightExpressionAttributeType:NSStringAttributeType
                                                       modifier:NSDirectPredicateModifier
                                                      operators:[NSArray arrayWithObject:
                                                                 [NSNumber numberWithUnsignedInteger:NSContainsPredicateOperatorType]]
                                                        options:(NSCaseInsensitivePredicateOption|NSDiacriticInsensitivePredicateOption)];
    
    NSMutableArray * templates = [[myPredicateEditor rowTemplates] mutableCopy];
    [templates addObject:template];
    [template release];
    [myPredicateEditor setRowTemplates:templates];
    [templates release];
    [myPredicateEditor setObjectValue:[NSPredicate predicateWithFormat:DEFAULT_PREDICATE]];
    
    [smartFolderNameTextView setStringValue:@""];
    
    NSString *createString = NSLocalizedString(@"Create", nil);
    
    [smartOKButton setTitle:createString];
    
    NSString *newSmartFolder = NSLocalizedString(@"New Smart FOlder", nil);
    [sheet setTitle:newSmartFolder];
    [smartOKButton setEnabled:NO];
    
    [sheet makeKeyAndOrderFront:nil];
    [NSApp runModalForWindow:sheet];
    
    [smartOKButton setAction:@selector(closeEditor:)];

}

- (IBAction)closeEditor:(id)sender
{
    NSLog(@"closeEditor");
    NSPredicate *pred = [myPredicateEditor objectValue];
    
    [NSApp endSheet:sheet];
    [sheet orderOut:sender];
    
    [self createSmartList:pred named:[smartFolderNameTextView stringValue]];
    [bookmarkListArrayController setFetchPredicate:pred];
}

#pragma mark -
#pragma mark Void Methods

- (void)createSmartList:(NSPredicate *)passedSmartPredicate named:(NSString *) newSmartFolderName
{
    // Undo
    
    Group *newSmartFolder = [Group itemWithTitle:newSmartFolderName identifier:@"smartPredicate"];
    [newSmartFolder setValue:passedSmartPredicate forKey:@"smartPredicate"];
    
    
    [newSmartFolder setIcon:[NSImage imageNamed: @"NSFolderSmart"]];
    
    NSDictionary *treeNode = [[self.groupsController arrangedObjects] representedObject];
    
    NSLog(@"the tree node?: %@", [treeNode valueForKey:@"children"]);
    
    // Do we already have smart folders?
    if ([[treeNode valueForKey:@"children"] count] > 1)
    {
        NSLog(@"sourceListItems count is more than 1");
        
        NSUInteger indexArr[] = {1,1};
        NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexArr length:2];
        [self.groupsController insertObject:newSmartFolder atArrangedObjectIndexPath:indexPath];

    } else {
        
        NSLog(@"sourceListItems count is NOT more than 1");
        NSLog(@"selectionIndexPath = %@", [self.groupsController selectionIndexPath]);
        NSDictionary *initalizeDict = @{@"title": @"SMART FOLDERS",
                                        @"isLeaf": @(NO),
                                        @"children":@[newSmartFolder]
                                        };
        NSMutableDictionary *root = [[NSMutableDictionary alloc] initWithDictionary:initalizeDict];
        
        NSIndexPath *newPath =  [[NSIndexPath alloc] initWithIndex: 1];

        [self.groupsController insertObject:root atArrangedObjectIndexPath:newPath];
        [newPath release];
        [root release];

    }

    [bookmarkListTableView reloadData];
}


#pragma mark - Helpers

- (BOOL) isHeader:(id)item
{
//    NSLog(@"item: %@", [item representedObject]);
    
    if([item isKindOfClass:[NSTreeNode class]])
    {
        return ![((NSTreeNode *)item).representedObject isKindOfClass:[Group class]];
    } else {
        return ![item isKindOfClass:[Group class]];
    }
}

- (NSString *)applicationSupportFolder
{
    return [[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
                                                 NSUserDomainMask, YES) objectAtIndex:0]
            stringByAppendingPathComponent:[[NSProcessInfo processInfo]
                                            processName]];
}

#pragma mark - NSOutlineViewDelegate

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    return ![self isHeader:item];
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    
    if ([self isHeader:item]) {
        return [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
    } else {
        return [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    // This converts a group to a header which influences its style
    return [self isHeader:item];
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification;
{

    id selectedItem = [sidebarOutlineView itemAtRow:[sidebarOutlineView selectedRow]];
    NSTreeNode *node = (NSTreeNode *)selectedItem;
    Group *selectedGroup = [node representedObject];
    
    if ([selectedGroup valueForKey:@"smartPredicate"] != nil)
    {
        [bookmarkListArrayController setFilterPredicate: [selectedGroup valueForKey:@"smartPredicate"]];

    } else {
        
        NSString *selectedGroupText = [selectedGroup valueForKey:@"title"];
        NSLog(@"Selected Group: %@", selectedGroupText);
        
        if ([selectedGroupText isEqualToString:@"All Bookmarks"])
        {
            [bookmarkListArrayController setFilterPredicate: nil];
            [bookmarkListArrayController setFetchPredicate: nil];
        }
        
        if ([selectedGroupText isEqualToString:@"Web"])
        {
            NSPredicate *filter = [NSPredicate predicateWithFormat: @"urlScheme=%@", @"http"];
            [bookmarkListArrayController setFilterPredicate: filter];
        }
        
        if ([selectedGroupText isEqualToString:@"Secure Shell"])
        {
            NSPredicate *filter = [NSPredicate predicateWithFormat: @"urlScheme=%@", @"ssh"];
            [bookmarkListArrayController setFilterPredicate: filter];
        }
        
        if ([selectedGroupText isEqualToString:@"VNC Connections"])
        {
            NSPredicate *filter = [NSPredicate predicateWithFormat: @"urlScheme=%@", @"vnc"];
            [bookmarkListArrayController setFilterPredicate: filter];
        }
        
        if ([selectedGroupText isEqualToString:@"FTP Servers"])
        {
            NSPredicate *filter = [NSPredicate predicateWithFormat: @"urlScheme=%@", @"ftp"];
            [bookmarkListArrayController setFilterPredicate: filter];
        }
    }
}


#pragma mark - Drag & Drop

- (id <NSPasteboardWriting>)outlineView:(NSOutlineView *)outlineView pasteboardWriterForItem:(id)item
{
    // No dragging if <some condition isn't met>
    BOOL dragAllowed = YES;
    if (!dragAllowed)  {
        return nil;
    }
    
    Group *group = (Group *)(((NSTreeNode *)item).representedObject);
    NSString *identifier = group.title;
    
    NSPasteboardItem *pboardItem = [[NSPasteboardItem alloc] init];
    [pboardItem setString:identifier forType: @"public.text"];
    [pboardItem autorelease];
    
    return pboardItem;
}

- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id < NSDraggingInfo >)info proposedItem:(id)targetItem proposedChildIndex:(NSInteger)index
{
    
    BOOL canDrag = index >= 0 && targetItem;
    
    if (canDrag) {
        return NSDragOperationMove;
    }else {
        return NSDragOperationNone;
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id < NSDraggingInfo >)info item:(id)targetItem childIndex:(NSInteger)index
{
    
    NSPasteboard *p = [info draggingPasteboard];
    NSString *title = [p stringForType:@"public.text"];

    NSTreeNode *sourceNode = [[NSTreeNode alloc] init];
    [sourceNode autorelease];

    for(NSTreeNode *b in [targetItem childNodes]){
        if ([[[b representedObject] title] isEqualToString:title]){
            sourceNode = b;
        }
    }

    NSUInteger indexArr[] = {0,index};
    NSIndexPath *toIndexPATH =[NSIndexPath indexPathWithIndexes:indexArr length:2];
    
    [self.groupsController moveNode:sourceNode toIndexPath:toIndexPATH];
    
    return YES;
}



@end
