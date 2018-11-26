//
//  JBTableView.h
//  Go
//
//  Created by Jonathan Buys on 9/12/10.
//  Copyright 2010 Farmdog Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JBMenuItem.h"

@interface JBTableView : NSTableView 
{
	IBOutlet NSMenu *rightClickMenu;
}

@end
