//
//  JBCView.m
//  Servers
//
//  Created by Jonathan Buys on 3/25/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "JBCView.h"


@implementation JBCView


- (void)dealloc
{
    [super dealloc];
}


-(id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) 
	{
		[self setWantsLayer:YES];
    }
    return self;
}



- (BOOL)isFlipped
{
    return NO;
}

@end
