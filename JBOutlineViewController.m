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
    
    if (self != nil)
    {
        
        smartPredicateForEditor = [[NSPredicate predicateWithFormat:DEFAULT_PREDICATE] retain];
        
        [[NSNotificationCenter defaultCenter]
         addObserver: self
         selector: @selector(applicationWillTerminate:)
         name: NSApplicationWillTerminateNotification
         object: nil];
         
        
//        [[NSNotificationCenter defaultCenter]
//         addObserver: self
//         selector: @selector(liveUpdateView:)
//         name: NSControlTextDidChangeNotification
//         object: myPredicateEditor];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    NSLog(@"awakeFromNib");
    sourceListItems = [[NSMutableArray alloc] init];
    
    NSString *go2_smart_data_path = [[self applicationSupportFolder] stringByAppendingPathComponent:@"go2_smartP_data"];
    NSFileManager *myDefaultManager = [[NSFileManager alloc] init];
    
    if ([myDefaultManager fileExistsAtPath:go2_smart_data_path])
    {
        NSData *data = [NSData dataWithContentsOfFile:go2_smart_data_path];
        [sourceListItems addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        
    } else {
        
        // Set up the "Library" parent and children
        Group *mainLibrary = [Group itemWithTitle:@"Library" identifier:@"mainLibrary"];
        Group *sshBookmarks = [Group itemWithTitle:@"Secure Shell" identifier:@"sshBookmarks"];
        Group *httpBookmarks = [Group itemWithTitle:@"Web Apps" identifier:@"httpBookmarks"];
        Group *vncBookmarks = [Group itemWithTitle:@"VNC Connections" identifier:@"vncBookmarks"];
        Group *ftpBookmarks = [Group itemWithTitle:@"FTP Servers" identifier:@"ftpBookmarks"];
        Group *unsortedBookmarks = [Group itemWithTitle:@"All Bookmarks" identifier:@"unsortedBookmarks"];
        
        [sshBookmarks setIcon:[NSImage imageNamed:@"box.png"]];
        [httpBookmarks setIcon:[NSImage imageNamed:@"box.png"]];
        [vncBookmarks setIcon:[NSImage imageNamed:@"box.png"]];
        [ftpBookmarks setIcon:[NSImage imageNamed:@"box.png"]];
        [unsortedBookmarks setIcon:[NSImage imageNamed:@"box.png"]];
        
        
        [mainLibrary setChildren:[NSMutableArray arrayWithObjects:unsortedBookmarks, sshBookmarks, httpBookmarks, vncBookmarks, ftpBookmarks, nil]];
        [sourceListItems addObject:mainLibrary];
    }
    
    [myDefaultManager release];
    
    // All done, display the data
    //    [sourceList reloadData];
    //    [sourceList registerForDraggedTypes:[NSArray arrayWithObject:@"SourceListPboardType"]];
    //    [sourceList setDraggingSourceOperationMask:NSDragOperationEvery forLocal:YES];
    //    [sourceList setDraggingSourceOperationMask:NSDragOperationEvery forLocal:NO];
    //
    //    [sourceList setTarget:self];
    //    [sourceList setDoubleAction:@selector(editSmartFolder:)];
    
    // setup the nspredicateeditor
    previousRowCount = 3;
    [[myPredicateEditor enclosingScrollView] setHasVerticalScroller:YES];
    
    //    NSString *imageName;
    //    NSImage *image1;
    //
    //    imageName = [[NSBundle mainBundle] pathForResource:@"texture" ofType:@"png"];
    //    image1 = [[NSImage alloc] initWithContentsOfFile:imageName];    // note no need to retain since we call "alloc"
    //
    //    [sourceList setBackgroundImage:image1];
    //    [image1 release];
}


- (void)appDidLaunch
{
    self.outlineView.delegate = self;
    self.outlineView.dataSource = self;
    self.outlineView.floatsGroupRows = NO; // Prevent a sticky header
    [self addData];
    
    // Expand the first group and select the first item in the list
    [self.outlineView expandItem:[self.outlineView itemAtRow:0]];
    [self.outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
    
    // Enable Drag and Drop
    [self.outlineView registerForDraggedTypes: [NSArray arrayWithObject: @"public.text"]];
}


#pragma mark - Add data

- (void) addData
{
    
    // `children` and `isLeaf` have to be configured for the Tree Controller in IB
    NSDictionary *initalizeDict = @{@"title": @"LIBRARY",
                                  @"isLeaf": @(NO),
                                  @"children":@[
                                        [Group groupWithTitle:@"All Bookmarks"],
                                        [Group groupWithTitle:@"Web Apps"],
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

//    NSUInteger indexArr[] = {0,0};
    
//    Group *newGroup = [Group new];
//    NSArray *list = [[self.groupsController arrangedObjects] childNodes];
//    NSUInteger total = [list count];
//
//    [self.groupsController insertObject:newGroup atArrangedObjectIndexPath:[NSIndexPath indexPathWithIndexes:indexArr length:total + 1]];
//    [newGroup release];
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
    
    
    NSLog(@"the tree node?: %@", [[self.groupsController arrangedObjects] representedObject]);
    
    
    
    
    if ([[[self.groupsController arrangedObjects] representedObject] count] > 1)
    {
        NSLog(@"sourceListItems count is more than 1");
        NSMutableArray *currentKids = [NSMutableArray arrayWithArray:[[sourceListItems objectAtIndex:1] children]];
        [currentKids addObject:newSmartFolder];
        [[sourceListItems objectAtIndex:1] setChildren:currentKids];
    } else {
        
        NSLog(@"sourceListItems count is NOT more than 1");
        
        NSDictionary *initalizeDict = @{@"title": @"SMART FOLDERS",
                                        @"isLeaf": @(NO),
                                        @"children":@[newSmartFolder]
                                        };
        NSMutableDictionary *root = [[NSMutableDictionary alloc] initWithDictionary:initalizeDict];

        [self.groupsController addObject:root];
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
    NSLog(@"Selected Group: %@",selectedItem );
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
