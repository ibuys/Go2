//
//  JBValidateTextField.m
//  Go
//
//  Created by Jon Buys on 7/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JBValidateTextField.h"

@implementation JBValidateTextField

- (void)awakeFromNib
{
	setButtonOK = NO;
	[saveSearchMenuItem setEnabled:NO];

}

- (void)controlTextDidChange:(NSNotification *)aNotification
{
	
	if ([urlTextField stringValue]) 
	{
		
		if ([self validateUrl:[urlTextField stringValue]])
		{
			[urlOKButton setEnabled:YES];
		//	NSLog(@"Ok, we have url: %@", [urlTextField stringValue]);
			
		} else {
			
			[urlOKButton setEnabled:NO];
			
		//	NSLog(@"No url");
		}
	}
	
	if ([editUrlTextField stringValue]) 
	{
		
		
		if ([self validateUrl:[editUrlTextField stringValue]])
		{
			[editUrlOKButton setEnabled:YES];
			
		} else {
			[editUrlOKButton setEnabled:NO];
		}
	}
	
	if ([createEditSmartFolderTextField stringValue]) 
	{				
		//NSLog(@"setButtonOK: %i", setButtonOK);
		[createEditSmartFolderButton setEnabled:YES];

	}
	
	if ([searchField stringValue]) 
	{
//		NSLog(@"searchField: %@", [searchField stringValue]);
//		NSLog(@"String length: %lu",[[searchField stringValue] length] );
		
		if ([[searchField stringValue] length] == 0) {
			[saveSearchMenuItem setEnabled:NO];
		} else {
			[saveSearchMenuItem setEnabled:YES];

		}

		
	} else {
		[saveSearchMenuItem setEnabled:NO];
	}
}



- (IBAction)checkEnter:(id)sender
{
	
	if ([self validateUrl:[urlTextField stringValue]])
	{
		
	} else {
		
		NSBeep();
	}	
}

- (IBAction)checkEditEnter:(id)sender
{
	
	if (![self validateUrl:[editUrlTextField stringValue]])
	{
	} else {
		NSBeep();
	}
	
}

- (IBAction)setButtonOKBoolNO:(id)sender
{
	setButtonOK = NO;
}

- (IBAction)setButtonOKBoolYES:(id)sender
{
	setButtonOK = YES;
	if ([createEditSmartFolderTextField stringValue]) 
	{
		[createEditSmartFolderButton setEnabled:YES];
	}
}

- (BOOL) validateUrl: (NSString *) candidate {
	//   NSString *urlRegEx = @"(?i)\\b((?:[a-z][\\w-]+:(?:/{1,3}|[a-z0-9%])|www\\d{0,3}[.]|[a-z0-9.\\-]+[.][a-z]{2,4}/)(?:[^\\s()<>]+|\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\))+(?:\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\)|[^\\s`!()\\[\\]{};:'\".,<>?«»“”‘’]))";
 	NSString *urlRegEx = @"[a-z]{2,9}://[a-z|0-9]*.*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx]; 
    return [urlTest evaluateWithObject:candidate];
        //return YES;
}



@end


//		if (setButtonOK) 
//		{
//			[createEditSmartFolderButton setEnabled:YES];
//		} else {
//			[createEditSmartFolderButton setEnabled:NO];
//		}
//	} else {
//		[createEditSmartFolderButton setEnabled:NO];

