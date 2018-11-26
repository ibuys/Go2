//
//  JBStringToIconTransformer.m
//  Go
//
//  Created by Jonathan Buys on 9/14/10.
//  Copyright 2010 Farmdog Software. All rights reserved.
//

#import "JBStringToIconTransformer.h"


@implementation JBStringToIconTransformer

+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return YES; }

- (id)transformedValue:(id)value {
		
	if(value){
		return [[NSWorkspace sharedWorkspace] iconForFile: value];
	}else{
		return nil;
	}
}

@end
