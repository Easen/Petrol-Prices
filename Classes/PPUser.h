//
//  PPUser.h
//  Petrol Prices
//
//  Created by Marc Easen on 12/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPPost.h"

@protocol PPUserDelegate;


@interface PPUser : NSObject <HTTPPostDelegate> {
	id<PPUserDelegate> fDelegate;
	bool LoggedIn;
	bool Remember;
	NSString *Username;
	NSString *Password;
}

@property (nonatomic, readonly) bool LoggedIn;
@property (nonatomic, assign) bool Remember;
@property (nonatomic, assign) NSString *Username;
@property (nonatomic, assign) NSString *Password;

+ (PPUser *) sharedInstance;
- (void) loginWithUsername:(NSString *)aUsername Password:(NSString *)aPassword RememberDetails:(bool)aRememeber WithDelegate:(id<PPUserDelegate>)delegate; 

@end

@protocol PPUserDelegate<NSObject>

- (void) loginSuccessful;
- (void) loginFail;

@end

