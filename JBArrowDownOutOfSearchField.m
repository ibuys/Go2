//
//  JBArrowDownOutOfSearchField.m
//  Go2
//
//  Created by Jonathan Buys on 9/21/11.
//  Copyright 2011 Farmdog Software. All rights reserved.
//

#import "JBArrowDownOutOfSearchField.h"

@implementation JBArrowDownOutOfSearchField

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector {
    BOOL result = NO;
    if (commandSelector == @selector(moveDown:)) {
            // down arrow pressed
            // NSLog(@"OK, now move to the next key view");
        [[textView window] makeFirstResponder:myTableView];
        
		result = YES;
	}
    return result;
}


@end
