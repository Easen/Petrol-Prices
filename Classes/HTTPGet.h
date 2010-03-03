//
//  HTTPGet.h
//  HTTPExample
//
//  Created by Marc Easen on 29/12/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTTPGetDelegate;

@interface HTTPGet : NSObject {
    id <HTTPGetDelegate>fDelegate;
	SEL fSelector;
	NSString * fURL;
	NSDictionary * fRequestDictionary;
    
    NSURLConnection * fConnection;
    NSMutableData * fHTTPGetData;
	
	NSString * ReturnedData;
	bool Error;
	NSString * ErrorString;
}

- (id) initForURL: (NSString *) url requestDictionary: (NSDictionary *) dictionary withDelegate: (id) delegate;
- (void) startRequest;

@property (retain) NSString * ReturnedData;
@property bool Error;
@property (retain) NSString * ErrorString;

@end

@protocol HTTPGetDelegate<NSObject>

- (void) httpGetConnectionSuccessful:(HTTPGet *)theHTTPGet;
- (void) httpGetConnectionFail:(HTTPGet *)theHTTPGet withErrorMessage:(NSString *)errorMessage;

@end
