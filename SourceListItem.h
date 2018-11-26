    //
    //  SourceListItem.h
    //  PXSourceList
    //
    //  Created by Alex Rozanski on 08/01/2010.
    //  Copyright 2010 Alex Rozanski http://perspx.com
    //

#import <Cocoa/Cocoa.h>


@interface SourceListItem : NSObject  <NSCoding>
{
	NSString *title;
	NSString *identifier;
	NSImage *icon;
	NSInteger badgeValue;
	NSPredicate *smartPredicate;
	NSMutableArray *children;
    NSArray *draggedItems;

    SourceListItem *parent;
	BOOL expandedByDefault;
    
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, retain) NSImage *icon;
@property NSInteger badgeValue;

@property (nonatomic, copy) NSMutableArray *children;
@property (nonatomic, copy) NSPredicate *smartPredicate;
@property (nonatomic, retain) SourceListItem *parent;
@property (nonatomic) BOOL expandedByDefault;

    //Convenience methods
+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier;
+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier icon:(NSImage*)anIcon;


- (BOOL)hasBadge;
- (BOOL)hasChildren;
- (BOOL)hasIcon;

@end
