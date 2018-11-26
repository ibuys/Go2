//
//  HostObject.h
//  Go2
//
//  Created by Jonathan Buys on 10/24/10.
//  Copyright 2010 Farmdog Software. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface HostObject : NSManagedObject  
{
}

@property (nonatomic, retain) NSString * customPort;
@property (nonatomic, retain) NSString * hostName;
@property (nonatomic, retain) NSString * iconImage;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * urlScheme;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * guid;

@property (nonatomic) BOOL * isUp;
@property (nonatomic) BOOL * isWindows;

@end
