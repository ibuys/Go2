    //
    //  SourceListItem.m
    //  PXSourceList
    //
    //  Created by Alex Rozanski on 08/01/2010.
    //  Copyright 2010 Alex Rozanski http://perspx.com
    //
    //  GC-enabled code revised by Stefan Vogt http://byteproject.net
    //

#import "SourceListItem.h"


@implementation SourceListItem

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

#pragma mark -
#pragma mark Init/Dealloc/Finalize


- (id)init
{
	if((self=[super init]))
	{
		badgeValue = -1;	//We don't want a badge value by default
	}
	
	return self;
}

- (void)dealloc
{
	[title release];
	[identifier release];
	[icon release];
	[children release];
	[parent release];
    [smartPredicate release];
	[super dealloc];
}

- (void)finalize
{
	title = nil;
	identifier = nil;
	icon = nil;
	children = nil;
	
	[super finalize];
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
		
		badgeValue = -1;	//We don't want a badge value by default
		
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

#pragma mark -
#pragma mark Basics

+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier
{	
	SourceListItem *item = [SourceListItem itemWithTitle:aTitle identifier:anIdentifier icon:nil];
	
	return item;
}


+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier icon:(NSImage*)anIcon
{
	SourceListItem *item = [[[SourceListItem alloc] init] autorelease];
	
	[item setTitle:aTitle];
	[item setIdentifier:anIdentifier];
	[item setIcon:anIcon];
	
	return item;
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
#pragma mark Overridden Setters

- (void)setChildren:(NSArray *)newChildren
{
	if ([newChildren isEqualToArray:children]) return;
	
	for (SourceListItem *anItem in newChildren) {
            [anItem setParent:self];
	}
	
	[children release];
	children = [NSMutableArray arrayWithArray:newChildren];
	[children retain];
}

@end





















