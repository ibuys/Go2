//
//  JBSourceListDelegate.h
//  Go2
//
//  Created by Jonathan Buys on 12/9/15.
//
//

#ifndef JBSourceListDelegate_h
#define JBSourceListDelegate_h


#endif /* JBSourceListDelegate_h */

#import <Cocoa/Cocoa.h>

@interface JBSourceListDelegate : NSObject <NSOutlineViewDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (retain) id dataModel;

@end


