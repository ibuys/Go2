//
//  Group.h
//  CloudChain
//
//  Created by Jonathan Buys on 9/6/17.
//  Copyright © 2017 Fall Harvest. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Group : NSObject <NSSecureCoding>
{
    NSString *title;
    NSString *identifier;
    NSImage *icon;
    NSInteger badgeValue;
    NSPredicate *smartPredicate;
    NSMutableArray *children;
    NSArray *draggedItems;
    Group *parent;
    BOOL expandedByDefault;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, retain) NSImage *icon;
@property NSInteger badgeValue;

@property (nonatomic, assign) NSMutableArray *children;
@property (nonatomic, copy) NSPredicate *smartPredicate;
@property (nonatomic, retain) Group *parent;
@property (nonatomic) BOOL expandedByDefault;



@property (readonly) BOOL isLeaf;

//Convenience methods
+ (Group*) groupWithTitle:(NSString *)title;
+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier;
+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier icon:(NSImage*)anIcon;
- (BOOL)hasBadge;
- (BOOL)hasChildren;
- (BOOL)hasIcon;

@end

