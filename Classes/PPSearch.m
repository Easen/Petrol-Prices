//
//  PPSearch.m
//  Petrol Prices
//
//  Created by Marc Easen on 12/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PPSearch.h"


const PPSearch *fPPSearchSharedInstance;

@interface PPSearch (Private)

- (void) createSearch;
- (void) parseData:(NSString *)aData;

@end


@implementation PPSearch

@synthesize isBusy;
@synthesize postcode;
@synthesize distance;
@synthesize fuelType;
@synthesize results;
@synthesize resultsMapRegion;
@synthesize showUsersLocation;

- (id) init
{
	if (fPPSearchSharedInstance != nil)
		return fPPSearchSharedInstance;
	self = [super init];
	if (self != nil) {
		fPPSearchSharedInstance = self;
	}
	return self;
}

+ (PPSearch *) sharedInstance {
	if (fPPSearchSharedInstance == nil)
		fPPSearchSharedInstance = [[PPSearch alloc] init];
	return (PPSearch *)fPPSearchSharedInstance;
}

- (void) searchWithPostcode:(NSString *)aPostcode 
				   Distance:(NSString *)aDistance 
				   FuelType:(PPSearchFuelType)aFuelType  
	 ShowUsersLocationOnMap:(BOOL)aShowUsersLocation
				   Delegate:(id)aDelegate{
	delegate = aDelegate;
	postcode = [aPostcode copy];
	distance = [aDistance copy];
	fuelType = aFuelType;
	showUsersLocation = aShowUsersLocation;
	isBusy = YES;
	if(delegate)
		[delegate searchBusy];
	[self createSearch];
}

- (PPSearchFuelType) getFuelTypeFromString:(NSString *) aFuelType {
	
	NSString *lowerFuelType = [aFuelType lowercaseString];
	
	if (![lowerFuelType compare:@"petrol"])
		return PPSearchFuelTypeUnleaded;
	if (![lowerFuelType compare:@"diesel"])
		return PPSearchFuelTypeDiesel;
	
	return PPSearchFuelTypeNone;
}

#pragma mark Private functions

- (void) createSearch {
	NSDictionary *requestDict = [NSDictionary dictionaryWithObjectsAndKeys:
								 [self.postcode copy], @"search",
								 [self.distance copy], @"range",
								 [NSString stringWithFormat:@"%d",self.fuelType], @"fueltype",
								 nil ]; // terminate the list
	
	HTTPGet *searchGet = [[HTTPGet alloc] initForURL:@"http://www.petrolprices.com/members/" 
								   requestDictionary:requestDict 
										withDelegate:self];

	[searchGet startRequest];
}

- (void) parseData:(NSString *)aData {
	NSArray *split = [aData componentsSeparatedByString:@"map.centerAndZoom"];
	if([split count] == 2){
		// Get the map region
		NSString *trimmedData = [[split objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		NSArray *region = [trimmedData componentsSeparatedByString:@"new GPoint("];
		NSArray *points = [[region objectAtIndex:3] componentsSeparatedByString:@","];
		MKCoordinateRegion mapRegion;
		mapRegion.center.latitude = [[points objectAtIndex:1] floatValue];
		mapRegion.center.longitude = [[points objectAtIndex:0] floatValue];
		mapRegion.span.latitudeDelta = 0.25;
		
		// Get the results
		NSArray *split2 = [[split objectAtIndex:1] componentsSeparatedByString:@"}"];
		NSString *rawData = [[split2 objectAtIndex:0] copy];
		trimmedData = [rawData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		[rawData release];
		
		PPFuelStation *fuelStation;
		NSMutableArray *fuelStations = [[NSMutableArray alloc] init];
		
		NSArray *lines = [trimmedData componentsSeparatedByString:@";"];
		int i;
		for (i = 0; i < [lines count]; i++) {
			NSString *aLine = [lines objectAtIndex:i];
			NSString *trimmedLine = [aLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			if ([trimmedLine length] > 0) {
				NSArray *splitLine;
				splitLine = [trimmedLine componentsSeparatedByString:@"GPoint("];
				if([splitLine count] == 2) {
					NSArray *data = [[splitLine objectAtIndex:1] componentsSeparatedByString:@","];
					CLLocationCoordinate2D coord;
					coord.latitude = [[data objectAtIndex:1] floatValue];
					coord.longitude = [[data objectAtIndex:0] floatValue];
					fuelStation = [[PPFuelStation alloc] initWithCoordinate:coord];
				}
				
				splitLine = [trimmedLine componentsSeparatedByString:@"createMarker("];
				if([splitLine count] == 2) {
					NSArray *data = [[splitLine objectAtIndex:1] componentsSeparatedByString:@","];
					NSString *address = [NSString stringWithFormat:@"%@, %@, %@, %@",
										 [[data objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]],
										 [[data objectAtIndex:3] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]],
										 [[data objectAtIndex:4] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]],
										 [[data objectAtIndex:5] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]]];
					fuelStation.address = address;
					fuelStation.name = [[data objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
					
					NSArray *tableData = [[split objectAtIndex:0] componentsSeparatedByString:fuelStation.name];
					NSArray *tdData = [[tableData objectAtIndex:1] componentsSeparatedByString:@"<td align='right'>"];
					fuelStation.price = [[tdData objectAtIndex:2] stringByReplacingOccurrencesOfString:@"</td>" withString:@""];
					
					
				}
				
				splitLine = [trimmedLine componentsSeparatedByString:@"map.addOverlay"];
				if([splitLine count] == 2) {
					[fuelStations addObject:fuelStation];
				}
			}
		}		
		results = fuelStations;
		resultsMapRegion = mapRegion;
		if (delegate)
			[delegate searchSuccessfulWithResults:fuelStations MapRegion:mapRegion];
		return;
	} 
	
	// Lets see what when wrong
	NSRange find;
	find = [aData rangeOfString:@"Create a Fubra Passport to access PetrolPrices.com"];
	if (find.location != NSNotFound){
		if (delegate)
			[delegate searchFailWithTitle:@"Please login first" Message:@"Please login first. If you dont have an account your can create one within the \"Account\" section."];
		return;
	}
	
	find = [aData rangeOfString:@"Your passport account is nearly ready"];
	if(find.location != NSNotFound) {
		if (delegate)
			[delegate searchFailWithTitle:@"Please Activte Your Account" Message:@"Your email address needs to be verified, please check your email account for instructions."];
		return;
	}
	
	find = [aData rangeOfString:@"You have used up all your searches for this week."];
	if(find.location != NSNotFound) {
		if (delegate)
			[delegate searchFailWithTitle:@"No search credits." Message:@"Unfortunately you have used up all your searches for this week, a total of 20. Try again next week."];
		return;
	}
	if (delegate)
		[delegate searchFailWithTitle:@"Unknown error, please try again." Message:@"It is possible that it was not possible to fulfill your request to the restrictions in your search query, try setting the distance to 20 miles."];
	
}

#pragma mark HTTP Get Delegates
- (void) httpGetConnectionSuccessful:(HTTPGet *)theHTTPGet {
	[self parseData: theHTTPGet.ReturnedData];
	isBusy = NO;
	[theHTTPGet release];
}

- (void) httpGetConnectionFail:(HTTPGet *)theHTTPGet withErrorMessage:(NSString *)errorMessage {
	if (delegate)
		[delegate searchFailWithTitle:@"No network connectivity" Message:@"No network connectivity, please ensure you are connected to the Internet"];
	isBusy = NO;
	[theHTTPGet release];
}
@end
