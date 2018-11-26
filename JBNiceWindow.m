//
//  JBNiceWindow.m
//  Scout
//
//  Created by Jonathan Buys on 1/29/10.
//  Copyright 2010 B6 Systems Inc.. All rights reserved.
//

#import "JBNiceWindow.h"
#define DEFAULT_PREDICATE @"name CONTAINS[cd] '' AND address CONTAINS[cd] ''" 


@implementation JBNiceWindow

- (id)init {
    [self makeKeyAndOrderFront: self ];
    return self;
}

//- (id)initWithContentRect:(NSRect)contentRect styleMask:
//(NSUInteger)windowStyle backing:(NSBackingStoreType)bufferingType
//					defer:(BOOL)deferCreation
//{
//	self = [super initWithContentRect:contentRect styleMask:windowStyle
//							  backing:bufferingType defer:deferCreation];
//	
//	if (self) {
//		[self setContentBorderThickness:22.0 forEdge:NSMinYEdge];
//	}
//	
//	return self;
//}

- (void)toggleToolbarShown:(id)sender
{
	//NSLog(@"Toggled the toolbar!");
	
	if ([myToolBar isVisible])
	{
		[myToolBar setVisible:NO];
		[self makeFirstResponder:hostTableView];
	} else {
		[myToolBar setVisible:YES];
	}

}
//
//
//
//
//
//- (IBAction)openEditor:(id)sender
//{
//	//
//	// Predicate Stuff
//	//
//	
//	NSPredicateEditorRowTemplate * template = [[NSPredicateEditorRowTemplate alloc] initWithLeftExpressions:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"hostName"]] 
//								   rightExpressionAttributeType:NSStringAttributeType
//													   modifier:NSDirectPredicateModifier
//													  operators:[NSArray arrayWithObject:
//																 [NSNumber numberWithUnsignedInteger:NSContainsPredicateOperatorType]]
//														options:(NSCaseInsensitivePredicateOption|NSDiacriticInsensitivePredicateOption)];
//	
//	NSMutableArray * templates = [[myPredicateEditor rowTemplates] mutableCopy];
//	[templates addObject:template];
//	[template release];
//	[myPredicateEditor setRowTemplates:templates];
//	[templates release];
//	[myPredicateEditor setObjectValue:[NSPredicate predicateWithFormat:DEFAULT_PREDICATE]];
//	
//	
//	//
//	// Window resize stuff
//	//
//	
//	// The original placement of the splitview
//	NSRect originalSplitFrame = [view0 frame];
//	
//
//	// The new placement of the splitview, same origin, same width, height reduced by 15 pixels, which for some reason is double what I subtract
//	
//	// NSMakeRect(horizontal(x), veritcal(y), width, height)
//	
//	NSRect newSplitFrame = originalSplitFrame;
//	newSplitFrame.size.height -= 79;
//
//	
//	
//	NSRect searchFrameZero = NSMakeRect(0, originalSplitFrame.size.height, originalSplitFrame.size.width, 0);
//	
//	
//	NSRect searchFrame = NSMakeRect(0, originalSplitFrame.size.height - 79, originalSplitFrame.size.width, 79);
//	NSLog(@"here: %f", originalSplitFrame.size.height - 79 );
//	
//	//NSRect searchFrame = originalSplitFrame;
//	
//	//searchFrame.origin.y += newSplitFrame.size.height;
//	
//	[[view0 superview] addSubview:view1];
//	[view1  setFrame:searchFrameZero];
//
//	[NSAnimationContext beginGrouping];
//	
//	[[view0 animator] setFrame:newSplitFrame];
//	[[view1 animator] setFrame:searchFrame];
//	
//	[NSAnimationContext endGrouping];
//}



@end
