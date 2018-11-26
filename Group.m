//
//  Group.m
//  CloudChain
//
//  Created by Jonathan Buys on 9/6/17.
//  Copyright © 2017 Fall Harvest. All rights reserved.
//

#import "Group.h"

@implementation Group

@synthesize title;
@synthesize identifier;
@synthesize icon;
@synthesize badgeValue;
@synthesize children;
@synthesize parent;
@synthesize smartPredicate;
@synthesize expandedByDefault;

static NSString *TitleArchiveKey = @"titleKey";
static NSString *identifierArchiveKey = @"identifierKey";
static NSString *iconArchiveKey = @"iconKey";
static NSString *badgeValueArchiveKey = @"badgeValueKey";
static NSString *childrenArchiveKey = @"childrenKey";
static NSString *smartPredicateArchiveKey = @"smartPredicateKey";

+ (Group*) groupWithTitle:(NSString *)title
{
    Group *result = [[self alloc] init];
    [result autorelease];
    result.title = title;
    return result;
}

+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier
{
    Group *item = [Group itemWithTitle:aTitle identifier:anIdentifier icon:nil];
    
    return item;
}

+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier icon:(NSImage*)anIcon
{
    Group *item = [[[Group alloc] init] autorelease];
    
    [item setTitle:aTitle];
    [item setIdentifier:anIdentifier];
    [item setIcon:anIcon];
    
    return item;
}

-(BOOL)isLeaf
{
    return YES;
}

- (void)dealloc
{
    [title release];
    [identifier release];
    [icon release];
    [parent release];
    [smartPredicate release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Accessors

- (BOOL)hasBadge
{
    return badgeValue!=-1;
}

- (BOOL)hasChildren
{
    return [children count]>0;
}

- (BOOL)hasIcon
{
    return icon!=nil;
}


#pragma mark -
#pragma mark Encoding Methods

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self=[super init]))
    {
        //NSLog(@"Super Init!!!");
        title = [[decoder decodeObjectForKey:TitleArchiveKey] retain];
        //NSLog(@"title = %@", title);
        
        identifier = [[decoder decodeObjectForKey:identifierArchiveKey] retain];
        //NSLog(@"identifier = %@", identifier);
        
        icon = [[decoder decodeObjectForKey:iconArchiveKey] retain];
        //NSLog(@"icon = %@", icon);
        
        badgeValue = [decoder decodeIntegerForKey:badgeValueArchiveKey];
        //NSLog(@"badgeValue = %lu", badgeValue);
        
        children = [[decoder decodeObjectForKey:childrenArchiveKey] retain];
        //NSLog(@"children = %@", children);
        
        smartPredicate = [[decoder decodeObjectForKey:smartPredicateArchiveKey] retain];
        //NSLog(@"smartPredicate = %@", smartPredicate);
        
        badgeValue = -1;    //We don't want a badge value by default
        
        //NSLog(@"END OF initWithCoder!!");
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:title forKey:TitleArchiveKey];
    //NSLog(@"Step 1");
    
    [encoder encodeObject:identifier forKey:identifierArchiveKey];
    //NSLog(@"Step 2");
    
    [encoder encodeObject:icon forKey:iconArchiveKey];
    //NSLog(@"Step 3");
    
    [encoder encodeInteger:badgeValue forKey:badgeValueArchiveKey];
    [encoder encodeObject:children forKey:childrenArchiveKey];
    //NSLog(@"Step 4");
    
    [encoder encodeObject:smartPredicate forKey:smartPredicateArchiveKey];
    //NSLog(@"Step 5");
    
}

@end
