//
//  JBGetDefaultApps.h
//  Go
//
//  Created by Jonathan Buys on 9/14/10.
//  Copyright 2010 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>


@interface JBGetDefaultApps : NSObject {

}

- (NSURL *)getDefaultApp:(NSString *)nameOfURL;

@end
