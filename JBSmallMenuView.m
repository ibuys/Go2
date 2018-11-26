//
//  JBSmallMenuView.m
//  Go2
//
//  Created by Jonathan Buys on 10/27/10.
//  Copyright 2010 Farmdog Software. All rights reserved.
//

#import "JBSmallMenuView.h"


@implementation JBSmallMenuView

- (id)initWithFrame:(NSRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}


- (void)viewDidMoveToWindow
{
        //NSLog(@"Anything?");
    [[self window] makeFirstResponder:searchField];
	[super viewDidMoveToWindow];
}


@end
