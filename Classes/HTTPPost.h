//
//  HTTPPost.h
//  HTTPExample
//
//  Created by Marc Easen on 19/01/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTTPPostDelegate;

@interface HTTPPost : NSObject {
    id <HTTPPostDelegate>fDelegate;
	NSString * fURL;
	NSDictionary * fRequestDictionary;
	NSString * fFileFieldName;
	NSString * fFileName;
	NSData * fRequestFile;
    
    NSURLConnection * fConnection;
    NSMutableData * fHTTPPostData;
	
	NSString * ReturnedData;
	bool Error;
	NSString * ErrorString;
}

- (id) initForURLWithFile: (NSString *) url 
		requestDictionary: (NSDictionary *) dictionary 
			fileFieldName: (NSString *) fileFieldName
				 fileName: (NSString *) fileName
				 fileData: (NSData *) fileData
			 withDelegate: (id) delegate;

- (void) startRequest;

@property (assign) NSString * ReturnedData;
@property bool Error;
@property (assign) NSString * ErrorString;

@end

@protocol HTTPPostDelegate<NSObject>

- (void) httpPostConnectionSuccessful:(HTTPPost *)theHTTPPost;
- (void) httpPostConnectionFail:(HTTPPost *)theHTTPPost withErrorMessage:(NSString *)errorMessage;

@end
