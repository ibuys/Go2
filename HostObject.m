// 
//  HostObject.m
//  Go2
//
//  Created by Jonathan Buys on 10/24/10.
//  Copyright 2010 Farmdog Software. All rights reserved.
//

#import "HostObject.h"


@implementation HostObject

-(NSString *)generateGuid
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString* str = [(NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid) autorelease];
    CFRelease(uuid);
    return str;
}

-(NSString *)guid
{
    return [self generateGuid];
}

-(void)awakeFromInsert
{
    [super awakeFromInsert];
    [self setGuid:[self generateGuid]];
}



@dynamic customPort;
@dynamic hostName;
@dynamic iconImage;
@dynamic url;
@dynamic urlScheme;
@dynamic userName;
@dynamic isUp;
@dynamic isWindows;
@dynamic guid;


@end
