//
//  JBSplitView.h
//  Scout
//
//  Created by Jonathan Buys on 9/18/10.
//  Copyright 2010 Farmdog Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JBSplitView : NSObject 
{
    IBOutlet NSSplitView *mySplitView;
    NSRect saveLeftFrame;
    NSRect saveRightFrame;
    
    IBOutlet NSMenuItem *toggleSplitViewMenuItem;
}

//-(IBAction)toggleRightView:(id)sender;;
-(IBAction)toggleLeftView:(id)sender;;

@end
