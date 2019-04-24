//
//  JBStatusItemView.m
//  Go2
//
//  Created by Jonathan Buys on 10/28/10.
//  Copyright 2010 Farmdog Software. All rights reserved.
//

#import "JBStatusItemView.h"
#import "JBGetDefaultApps.h"
#import "JBNiceWindow.h"
#import "Go2_AppDelegate.h"

@implementation JBStatusItemView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
            //register for drags
        [self registerForDraggedTypes:[NSArray arrayWithObjects: NSPasteboardTypeURL, nil]];
        
        
//        
//        NSNotificationCenter *distributedNC = [[NSWorkspace sharedWorkspace] notificationCenter];
//        
//            // Register for all sorts of notifications to note when apps change.
//            // This bit should work on OSX 10.3.9 (and below).  Might be overkill :)
//        [distributedNC addObserver:self selector:@selector(appDidChange) name:NSWorkspaceDidDeactivateApplicationNotification object:nil];

        
        
        
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect 
{
	//Used to detect where our files are
	NSBundle *bundle = [NSBundle mainBundle];
	NSImage *statusImage;
	NSImage *statusHighlightImage;
	statusImage = [[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"go_menubarTemplate" ofType:@"png"]] autorelease];
	statusHighlightImage = [[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"go_menubar_altTemplate" ofType:@"png"]]autorelease];
	
	// Now that we've got our stuff, let's see if we need it or not
	if (highlighted) {
        [[NSColor selectedMenuItemColor] set];
        NSRectFill(dirtyRect);
		NSPoint point = NSMakePoint(dirtyRect.origin.x+8, dirtyRect.origin.y+4);
//		[statusHighlightImage setScalesWhenResized:YES];
		//[statusHighlightImage compositeToPoint:point operation:NSCompositeSourceOver];
        [statusHighlightImage drawAtPoint:point fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1.0];

	} else {
		NSPoint point = NSMakePoint(dirtyRect.origin.x+8, dirtyRect.origin.y+4);
//		[statusImage setScalesWhenResized:YES];
		//[statusImage compositeToPoint:point operation:NSCompositeSourceOver];
        [statusImage drawAtPoint:point fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1.0];

	}
}

- (void)mouseDown:(NSEvent *)theEvent 
{
    
    if([theEvent modifierFlags] & NSEventModifierFlagControl)
    {
        [self rightMouseDown:theEvent];
    } else {
        
        [NSApp activateIgnoringOtherApps:YES];
        
        [NSTimer scheduledTimerWithTimeInterval:0.01
                                         target:self
                                       selector:@selector(popUpTheMenuAfterDelay)
                                       userInfo:nil
                                        repeats:NO];
            //[self setHighlightOn];
        
        [self setNeedsDisplay:YES];
        [super mouseDown:theEvent];

    }

}


- (void)rightMouseDown:(NSEvent *)event
{

	[NSApp activateIgnoringOtherApps:YES];
	
	[NSTimer scheduledTimerWithTimeInterval:0.01
									 target:self
								   selector:@selector(popUpRightClickMenuAfterDelay)
								   userInfo:nil
									repeats:NO];
        //[self setHighlightOn];
	
	[self setNeedsDisplay:YES];
    [super rightMouseDown:event];
	
}


- (void)popUpTheMenuAfterDelay
{
	[myMenuApplet popUpStatusItemMenu];
}

- (void)popUpRightClickMenuAfterDelay
{
	[myMenuApplet popUpRightClickMenu];
}

- (void)dealloc
{
    [super dealloc];
}


- (void)setHighlightOn
{
	highlighted = YES;
	[self setNeedsDisplay:YES];

	//NSLog(@"setHighlightOn");
}

- (void)setHighlightOff
{
	highlighted = NO;
	[self setNeedsDisplay:YES];
}



- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    return NSDragOperationCopy;
}

    //perform the drag and log the files that are dropped
- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender 
{
    NSPasteboard *pboard;
        // NSDragOperation sourceDragMask;
    
        //sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSPasteboardTypeURL] ) 
    {
        NSArray *files = [pboard propertyListForType:NSPasteboardTypeURL];
        
            // NSLog(@"Files: %@",[files objectAtIndex:0]);
        
        
        
        NSManagedObject *newFoo;
        NSString *urlString = [files objectAtIndex:0];
        
        
            // Duplicate check
        
        NSManagedObjectContext *moc = [self managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription
                                                  entityForName:@"Hosts" inManagedObjectContext:moc];
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        [request setEntity:entityDescription];
        
            // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"(url LIKE[c] %@)", urlString];
        [request setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            initWithKey:@"url" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        [sortDescriptor release];
        
        NSError *error = nil;
        NSArray *array = [moc executeFetchRequest:request error:&error];
        if ([array count] >0)
        {
            [self doToggleDup];
            
            [NSTimer scheduledTimerWithTimeInterval:1.50
                                             target:self
                                           selector:@selector(doToggleDup)
                                           userInfo:nil
                                            repeats:NO];

            
        } else {
            
                //  [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
            
            newFoo = [NSEntityDescription insertNewObjectForEntityForName:@"Hosts" inManagedObjectContext:[self managedObjectContext]];
            
            [newFoo setValue:urlString forKeyPath:@"url"];
            
            NSURL *newURL = [NSURL URLWithString:[newFoo valueForKey:@"url"]];
            
                // NSLog(@"newURL %@", newURL);
            
            [newFoo setValue:[newURL host] forKey:@"hostName"];
            [newFoo setValue:[newURL user] forKey:@"userName"];
            [newFoo setValue:[newURL scheme] forKey:@"urlScheme"];
            
            newURL = [NSURL URLWithString:urlString];
            
            
            JBGetDefaultApps *getDefaultApps = [[JBGetDefaultApps alloc] init];
            NSURL *defaultAppURL = [getDefaultApps getDefaultApp:[newURL scheme]];
            [getDefaultApps release];
            
            [newFoo setValue:[defaultAppURL path] forKey:@"iconImage"];
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"allowSpotlight"]) 
            {
                if (![saveManager saveSingleBookmark:newFoo]) 
                {
                    NSLog(@"Ummm... something is not working");       
                }
            }
            
            
            
            [self doToggle];
            
            [NSTimer scheduledTimerWithTimeInterval:1.50
                                             target:self
                                           selector:@selector(doToggle)
                                           userInfo:nil
                                            repeats:NO];
            
            

        }

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    return YES;
}

- (void)doToggle
{
    if (toggleWindow) 
    {
        NSRect frame = [[self window] frame];
        NSPoint pt = NSMakePoint(NSMidX(frame), NSMinY(frame));
        [self toggleAttachedWindowAtPoint:pt];
        toggleWindow = NO;
        
        if (![jbNiceWindow isVisible]) 
        {
            [[NSApplication sharedApplication] hide:nil];
        }         
       
    } else {
        NSRect frame = [[self window] frame];
        NSPoint pt = NSMakePoint(NSMidX(frame), NSMinY(frame));
        [self toggleAttachedWindowAtPoint:pt];
        toggleWindow = YES;

    }


}



- (void)toggleAttachedWindowAtPoint:(NSPoint)pt
{
//        // Attach/detach window.
//    if (!attachedWindow) {
//        attachedWindow = [[MAAttachedWindow alloc] initWithView:view 
//                                                attachedToPoint:pt 
//                                                       inWindow:nil 
//                                                         onSide:MAPositionBottom
//                                                     atDistance:5.0];
//        [textField setTextColor:[attachedWindow borderColor]];
//        NSString *gotItString = NSLocalizedString(@"Got It!", nil);
//
//        [textField setStringValue:gotItString];
//        [attachedWindow makeKeyAndOrderFront:self];
//    } else {
//        [attachedWindow orderOut:self];
//        [attachedWindow release];
//        attachedWindow = nil;
//    }    
}



    // If duplicate...

- (void)doToggleDup
{
    if (toggleWindow) 
    {
        NSRect frame = [[self window] frame];
        NSPoint pt = NSMakePoint(NSMidX(frame), NSMinY(frame));
        [self toggleAttachedWindowAtPointDup:pt];
        toggleWindow = NO;
        
        if (![jbNiceWindow isVisible]) 
        {
            [[NSApplication sharedApplication] hide:nil];
        }         
        
    } else {
        NSRect frame = [[self window] frame];
        NSPoint pt = NSMakePoint(NSMidX(frame), NSMinY(frame));
        [self toggleAttachedWindowAtPointDup:pt];
        toggleWindow = YES;
        
    }
    
    
}



- (void)toggleAttachedWindowAtPointDup:(NSPoint)pt
{
//        // Attach/detach window.
//    if (!attachedWindow) {
//        attachedWindow = [[MAAttachedWindow alloc] initWithView:view 
//                                                attachedToPoint:pt 
//                                                       inWindow:nil 
//                                                         onSide:MAPositionBottom
//                                                     atDistance:5.0];
//        [textField setTextColor:[attachedWindow borderColor]];
//        
//        NSString *alreadyGotIt = NSLocalizedString(@"Already Got It!", nil);
//
//        [textField setStringValue:alreadyGotIt];
//        [attachedWindow makeKeyAndOrderFront:self];
//    } else {
//        [attachedWindow orderOut:self];
//        [attachedWindow release];
//        attachedWindow = nil;
//    }    
}

- (NSManagedObjectContext*)managedObjectContext
{
    return [(Go2_AppDelegate *)[[NSApplication sharedApplication] delegate] managedObjectContext];
}


@end
