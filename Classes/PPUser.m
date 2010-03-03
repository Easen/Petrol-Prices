//
//  PPUser.m
//  Petrol Prices
//
//  Created by Marc Easen on 12/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PPUser.h"

const PPUser *fPPUserSharedInstance = nil;

@interface PPUser (Private)
- (void) callBackSuccessful;
- (void) callBackFail;
@end


@implementation PPUser

@synthesize LoggedIn;
@synthesize Remember;
@synthesize Username;
@synthesize Password;

- (id) init
{
	if (fPPUserSharedInstance != nil)
		return fPPUserSharedInstance;
	self = [super init];
	if (self != nil) {
		fPPUserSharedInstance = self;
	}
	return self;
}


+ (PPUser *) sharedInstance {
	if (fPPUserSharedInstance == nil)
		fPPUserSharedInstance = [[PPUser alloc] init];
	return fPPUserSharedInstance;
}

- (void) loginWithUsername:(NSString *)aUsername Password:(NSString *)aPassword RememberDetails:(bool)aRememeber WithDelegate:(id)delegate {
	fDelegate = delegate;
	if (self.LoggedIn)
		[self callBackSuccessful];
	self.Remember = aRememeber;
	self.Username = [aUsername copy];
	self.Password = [aPassword copy];
	
	NSDictionary *requestDict = [NSDictionary dictionaryWithObjectsAndKeys:
								 self.Username, @"form[login][username]",
								self.Password, @"form[login][password]",
								 @"Log-in and Continue", @"form[login][action][true]",
								 nil ]; // terminate the list
	HTTPPost *loginPost = [[HTTPPost alloc] initForURLWithFile:@"https://passport.fubra.com/site/pp/login/?tracking_code=pp_4a318ac500a09&passback=a%3A1%3A%7Bs%3A8%3A%22redirect%22%3Bs%3A36%3A%22http%253A%252F%252Fwww.petrolprices.com%252F%22%3B%7D" 
											 requestDictionary:requestDict 
												 fileFieldName:nil 
													  fileName:nil 
													  fileData:nil 
												  withDelegate:self];
	[loginPost startRequest];
	
}

#pragma mark Private Functions
- (void) callBackSuccessful {
	LoggedIn = YES;
	if (fDelegate)
		[fDelegate loginSuccessful];
}

- (void) callBackFail {
	LoggedIn = NO;
	if (fDelegate)
		[fDelegate loginFail];
}

#pragma mark HTTPPost Delegates

- (void) httpPostConnectionSuccessful:(HTTPPost *)theHTTPPost {
	NSString *data = theHTTPPost.ReturnedData;
	NSRange range = [data rangeOfString:@"form_error"];
	if (range.location != NSNotFound){
		// error
		[self callBackFail];
	} else {
		// logged in
		[self callBackSuccessful];
	}
	[theHTTPPost release];
}

- (void) httpPostConnectionFail:(HTTPPost *)theHTTPPost withErrorMessage:(NSString *)errorMessage {
	[self callBackFail];
	[theHTTPPost release];
}


@end
