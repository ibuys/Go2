//
//  JBSplitView.m
//  Scout
//
//  Created by Jonathan Buys on 9/18/10.
//  Copyright 2010 Farmdog Software. All rights reserved.
//

#import "JBSplitView.h"


@implementation JBSplitView

-(void)awakeFromNib
{
    
    
    if ([[NSUserDefaults standardUserDefaults]  valueForKey:@"firstLaunch16"])
	{
		//NSLog(@"Not first launch of Go2 v1.6");
        BOOL tabViewCollapsed = [[NSUserDefaults standardUserDefaults] boolForKey:@"tabViewCollapsed"];
      //  NSLog(@"tabViewCollapsed = %d", tabViewCollapsed);
        
        // OK, this seems backwards to me, but it works.
        if (tabViewCollapsed == YES)
        {
        //    NSLog(@"This should be collappsed.");
            [self collapseTabView];
        }

		
	} else {
		
		NSLog(@"First Launch of Go2 v1.6 from JBSplitView");
        
	}
}


/*
 * Controls the minimum size of the left subview (or top subview in a horizonal NSSplitView)
 */
- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex;
{
	//NSLog(@"%@:%s proposedMinimum: %f",[self class], _cmd, proposedMinimumPosition);
	return proposedMinimumPosition + 150;
}

/*
 * Controls the minimum size of the right subview (or lower subview in a horizonal NSSplitView)
 */
- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex;
{
	//NSLog(@"%@:%s proposedMaximum: %f",[self class], _cmd, proposedMaximumPosition);
	return proposedMaximumPosition - 200;
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview;
{
    NSView* rightView = [[splitView subviews] objectAtIndex:0];
    return ([subview isEqual:rightView]);
}

- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex;
{
    return YES;
}

- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex;
{
    NSView* rightView = [[splitView subviews] objectAtIndex:1];
    return ([subview isEqual:rightView]);
}

//-(IBAction)toggleRightView:(id)sender;
//{
//    BOOL rightViewCollapsed = [mySplitView isSubviewCollapsed:[[mySplitView subviews] objectAtIndex: 1]];
//    if (rightViewCollapsed) {
//        [self uncollapseRightView];
//    } else {
//        [self collapseRightView];
//    }
//}  
//-(void)collapseRightView
//{  
//    NSView *right = [[mySplitView subviews] objectAtIndex:1];
//    NSView *left  = [[mySplitView subviews] objectAtIndex:0];
//    NSRect leftFrame = [left frame];
//    NSRect overallFrame = [mySplitView frame]; //???
//    [right setHidden:YES];
//    [left setFrameSize:NSMakeSize(overallFrame.size.width,leftFrame.size.height)];
//    [mySplitView display];
//}
//
//-(void)uncollapseRightView
//{
//    NSView *left  = [[mySplitView subviews] objectAtIndex:0];
//    NSView *right = [[mySplitView subviews] objectAtIndex:1];
//    [right setHidden:NO];  
//    CGFloat dividerThickness = [mySplitView dividerThickness];  
//    // get the different frames
//    NSRect leftFrame = [left frame];
//    NSRect rightFrame = [right frame];
//    // Adjust left frame size
//    leftFrame.size.width = (leftFrame.size.width-rightFrame.size.width-dividerThickness);
//    rightFrame.origin.x = leftFrame.size.width + dividerThickness;
//    [left setFrameSize:leftFrame.size];
//    [right setFrame:rightFrame];
//    [mySplitView display];
//}

-(IBAction)toggleLeftView:(id)sender
{
    BOOL tabViewCollapsed = [mySplitView isSubviewCollapsed:[[mySplitView subviews] objectAtIndex: 0]];
    if (tabViewCollapsed) {
        [self uncollapseTabView];
        NSString *hideLibrary = NSLocalizedString(@"Hide Library", nil);

        [toggleSplitViewMenuItem setTitle:hideLibrary];
    } else {
        [self collapseTabView];
        NSString *showLibrary = NSLocalizedString(@"Show Library", nil);

        [toggleSplitViewMenuItem setTitle:showLibrary];

    }
    
    [[NSUserDefaults standardUserDefaults] setBool:tabViewCollapsed forKey:@"tabViewCollapsed"];
   //NSLog(@"Should tabViewCollapsed? = %d", tabViewCollapsed);


}  


//-(void)collapseTabView
//{  
//    NSView *left  = [[mySplitView subviews] objectAtIndex:0];
//    NSView *right = [[mySplitView subviews] objectAtIndex:1];
//    
//    NSRect leftFrame = [left frame];
//    saveLeftFrame = leftFrame;
//    saveRightFrame = [right frame];
//    NSRect overallFrame = [mySplitView frame]; //???
//    [self animateDividerToPosition:0];
//
//    [left setHidden:YES];
//    [right setFrameSize:NSMakeSize(overallFrame.size.width,leftFrame.size.height)];
//    [mySplitView display];
//}
//
//-(void)uncollapseTabView
//{
//    NSView *left  = [[mySplitView subviews] objectAtIndex:0];
//    NSView *right = [[mySplitView subviews] objectAtIndex:1];
//    [left setHidden:NO];
//    
//    CGFloat dividerThickness = [mySplitView dividerThickness];  
//    
//    // get the different frames
//    NSRect leftFrame = [left frame];
//    NSRect rightFrame = [right frame];
//
//    // Adjust right frame size
////    rightFrame.size.width = (save.size.width-rightFrame.size.width-dividerThickness);
//    rightFrame.size.width = saveRightFrame.size.width;
//    leftFrame.origin.x = rightFrame.size.width + dividerThickness;
//    [right setFrameSize:rightFrame.size];
//    [left setFrame:saveLeftFrame];
//    [mySplitView display];
//}

-(void)collapseTabView
{
    [self animateDividerToPosition:0];
    [self performSelector:@selector(setLeftHidden) withObject:nil afterDelay:0.15f];
    [mySplitView display];
}

-(void)uncollapseTabView
{
    [self animateDividerToPosition:150];
    NSView *left  = [[mySplitView subviews] objectAtIndex:0];
    [left setHidden:NO];

    [mySplitView display];
}

- (void)setLeftHidden
{
    NSView *left  = [[mySplitView subviews] objectAtIndex:0];
    [left setHidden:YES];

}

- (void)animateDividerToPosition:(CGFloat)dividerPosition
{
    
    // Get the views named
    NSView *view0 = [[mySplitView subviews] objectAtIndex:0];
    NSView *view1 = [[mySplitView subviews] objectAtIndex:1];
    
    // Get the size of each view
    NSRect view0Rect = [view0 frame];
    NSRect view1Rect = [view1 frame];
    
    // Get the size of the entire window
    NSRect overalRect = [mySplitView frame];
    
    // Get the size of the divider
    CGFloat dividerSize = [mySplitView dividerThickness];
    
    // Find out if we shoudl auto resize the subviews (should be yes?)
    BOOL view0AutoResizes = [view0 autoresizesSubviews];
    BOOL view1AutoResizes = [view1 autoresizesSubviews];
    
    // set subviews target size
    
    view0Rect.origin.x = MIN(0, dividerPosition);
    view0Rect.size.width = MAX(0, dividerPosition);
    
    
    view1Rect.origin.x = MAX(0, dividerPosition + dividerSize);
    view1Rect.size.width = MAX(0, overalRect.size.width - view0Rect.size.width - dividerSize);
    
    
    // make sure views are visible after previous collapse
    [view0 setHidden:NO];
    [view1 setHidden:NO];
    
    // disable delegate interference
    id delegate = [mySplitView delegate];
    [mySplitView setDelegate:nil];
    
	[NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.15f];
    [[NSAnimationContext currentContext] setCompletionHandler:^(void)
     {
         [view0 setAutoresizesSubviews:view0AutoResizes];
         [view1 setAutoresizesSubviews:view1AutoResizes];
         [mySplitView setDelegate:delegate];
     }];
    
    [[view1 animator] setFrame: view1Rect];
    [[view0 animator] setFrame: view0Rect];
    
	[NSAnimationContext endGrouping];
    
}


@end
