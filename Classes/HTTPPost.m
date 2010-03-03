//
//  HTTPPost.m
//  HTTPExample
//
//  Created by Marc Easen on 19/01/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HTTPPost.h"

@interface HTTPPost (Private)

- (void) callBackSuccessful;
- (void) callBackFailWithErrorMessage: (NSString *)errorMessage;

@end

// Public
@implementation HTTPPost;

@synthesize ReturnedData;
@synthesize Error;
@synthesize ErrorString;

- (id) initForURLWithFile: (NSString *) url 
		requestDictionary: (NSDictionary *) dictionary 
			fileFieldName: (NSString *) fileFieldName
				 fileName: (NSString *) fileName
				 fileData: (NSData *) fileData
			 withDelegate: (id) delegate 
{
	self = [super init];
	if (self != nil) {
		fURL = [url copy];
		if(dictionary){
			fRequestDictionary = [dictionary copy];
		}
		
		if(fileFieldName && fileName && fileData){
			fFileFieldName = [fileFieldName copy];
			fFileName = [fileName copy];
			fRequestFile = [fileData copy];
		}
		fDelegate = delegate;
		Error = false;
		
	}
	return self;
}

- (void) startRequest
{	
    NSMutableURLRequest * dataRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fURL]];
	[dataRequest setHTTPMethod:@"POST"];
	
	NSString *stringBoundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
	[dataRequest addValue:contentType forHTTPHeaderField: @"Content-Type"]; 
	
	NSMutableData *postBody = [NSMutableData data];
	
	if(fRequestDictionary){
		// Post the request dictionary
		NSArray * allKeys = [fRequestDictionary allKeys];
		for (NSString *key in allKeys)
		{
			[postBody appendData:[[NSString stringWithFormat:@"\r\n\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
			[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
			[postBody appendData:[[NSString stringWithString:[fRequestDictionary objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];		
		}		
	}

	// Post the file
	if(fRequestFile){
		[postBody appendData: [[NSString stringWithFormat:@"\r\n\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData: [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n\r\n", fFileFieldName, fFileName] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData: fRequestFile];
		[postBody appendData: [[NSString stringWithFormat:@"\r\n--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
		
	}
	[dataRequest setHTTPBody:postBody];
    
    if (fDelegate != nil){
		if(fConnection = [[NSURLConnection alloc] initWithRequest: dataRequest delegate: self])
			fHTTPPostData = [[NSMutableData alloc] init];
		else
			[self callBackFailWithErrorMessage:@"Unable to post data: failed to initiate connection"];
	
	}else{
		NSURLResponse * fResponse;
		NSError * fError;
		NSData * fData = [NSURLConnection sendSynchronousRequest:dataRequest returningResponse:&fResponse error:&fError];
		if (fData){
			NSString *dataString = [[NSString alloc] initWithData: fData encoding: NSUTF8StringEncoding];
			self.ReturnedData = dataString;
			
		}else{
			[self callBackFailWithErrorMessage:@"Unable to get data: possible memory issue"];
		}
	}
}

// Functions required for the NSURLConnection request 
- (void) connection: (NSURLConnection *) connection didReceiveResponse: (NSURLResponse *) response
{
    [fHTTPPostData setLength: 0];
}

- (void) connection: (NSURLConnection *) connection didReceiveData: (NSData *) data
{
    [fHTTPPostData appendData: data];
}

- (void) connection: (NSURLConnection *) connection didFailWithError: (NSError *) error
{
	[self callBackFailWithErrorMessage:[[error localizedDescription] copy]];
}

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
    NSString * dataString = [[NSString alloc] initWithData: fHTTPPostData encoding: NSUTF8StringEncoding];
    [fHTTPPostData release];
    fHTTPPostData = nil;
    
    if (dataString)
    {
        ReturnedData = dataString;
		[self callBackSuccessful];
    }
    else
    {
		[self callBackFailWithErrorMessage:@"Unable to get data: possible memory issue"];
	}
}


@end


// Private
@implementation HTTPPost (Private)
- (void) callBackSuccessful {    
    if (fDelegate)
        [fDelegate httpPostConnectionSuccessful: self];
}

- (void) callBackFailWithErrorMessage: (NSString *)errorMessage {
	Error = true;
	ErrorString = [errorMessage copy];
	if (fDelegate) 
		[fDelegate httpPostConnectionFail:self withErrorMessage:errorMessage];
}
@end

