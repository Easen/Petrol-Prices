//
//  HTTPGet.m
//  HTTPExample
//
//  Created by Marc Easen on 29/12/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "HTTPGet.h"

@interface HTTPGet (Private)

- (NSString *)urlEncodeValue:(NSString *)str;

- (void) callBackSuccessful;
- (void) callBackFailWithErrorMessage: (NSString *)errorMessage;

@end

// Public
@implementation HTTPGet

@synthesize ReturnedData;
@synthesize Error;
@synthesize ErrorString;

- (id) initForURL: (NSString *) url requestDictionary: (NSDictionary *) dictionary withDelegate: (id) delegate {
	self = [super init];
	if (self != nil) {
		fURL = [url copy];
		if(dictionary){
			fRequestDictionary = [dictionary copy];
		}
		fDelegate = delegate;
		Error = false;
	}
	return self;
}


- (void) dealloc {
	if(fURL != nil) [fURL release];
    if(fConnection != nil) [fConnection release];
    if(fHTTPGetData != nil) [fHTTPGetData release];	
	if(ReturnedData != nil) [ReturnedData release];
	if(ErrorString != nil) [ErrorString release];
	
	[super dealloc];
}

- (void) startRequest {
    NSString *newURL;
	if(fRequestDictionary)
	{
		NSMutableString * requestStringURL = [[NSMutableString alloc] init];
		NSArray * allKeys = [fRequestDictionary allKeys];
		for (NSString *key in allKeys)
		{
			[requestStringURL appendFormat:@"%@=%@&", [self urlEncodeValue:key], [self urlEncodeValue:[fRequestDictionary objectForKey:key]]];
		}
		// Check if there's a ? in the url
		
		NSRange questionMark = [fURL rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"?"] ];
		NSString *concaternateString; 
		if(questionMark.location == NSNotFound)
			concaternateString = [NSString stringWithString:@"?"];
		else
			concaternateString = [NSString stringWithString:@"&"];
			
		newURL = [NSString stringWithFormat:@"%@%@%@", fURL, concaternateString, requestStringURL];
		//[requestStringURL release];
	}else{
		newURL = [fURL copy];
	}
	
    NSURLRequest * dataRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:newURL]];
    
    if ((fConnection = [[NSURLConnection alloc] initWithRequest: dataRequest delegate: self]))
        fHTTPGetData = [[NSMutableData alloc] init];
    else
    {
		[self callBackFailWithErrorMessage:@"Unable to get data: failed to initiate connection"];
    }
}


// Functions required for the NSURLConnection request 
- (void) connection: (NSURLConnection *) connection didReceiveResponse: (NSURLResponse *) response
{
    [fHTTPGetData setLength: 0];
}

- (void) connection: (NSURLConnection *) connection didReceiveData: (NSData *) data
{
    [fHTTPGetData appendData: data];
}

- (void) connection: (NSURLConnection *) connection didFailWithError: (NSError *) error
{
	[self callBackFailWithErrorMessage:[[error localizedDescription] copy]];
}

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
    NSString * dataString = [[NSString alloc] initWithData: fHTTPGetData encoding: NSUTF8StringEncoding];
    [fHTTPGetData release];
    fHTTPGetData = nil;
    
    if (dataString)
    {
        ReturnedData = dataString;
		[self callBackSuccessful];
    }
    else
    {
		[self callBackFailWithErrorMessage:@"HTTPGet, Unable to get data: invalid data received"];
	}
	
}

@end

#pragma mark Private Functions
@implementation HTTPGet (Private)
- (NSString *)urlEncodeValue:(NSString *)str
{
	NSString *tempStr = [str stringByReplacingOccurrencesOfString:@" " withString:@"+"];
	[str release];
	str = tempStr;
	return str;
	NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR("?=&+"), kCFStringEncodingMacRoman);
	return [result autorelease];
}

- (void) callBackSuccessful{    
    if (fDelegate)
		[fDelegate httpGetConnectionSuccessful: self];
}
- (void) callBackFailWithErrorMessage: (NSString *)errorMessage {
	Error = true;
	ErrorString = [errorMessage copy];
	if (fDelegate) 
		[fDelegate httpGetConnectionFail:self withErrorMessage:errorMessage];
}

@end