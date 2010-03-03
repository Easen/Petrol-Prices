//
//  PPLocatePostcode.m
//  Petrol Prices
//
//  Created by Marc Easen on 14/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PPLocatePostcode.h"
#import "PPPostcode.h"

@interface PPLocatePostcode (Private)
BOOL bIgnoredFirstLocation;
- (id) init;
- (void) processCurrentLocation;
- (NSString *) findClosestPostcode:(NSMutableArray *)postcodes;
- (void) callBackSuccess:(NSString *)aPostcode;
- (void) callBackFail:(NSString *)aErrorMessage;

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;
- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error;

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder 
	   didFailWithError:(NSError *)error;
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder 
	   didFindPlacemark:(MKPlacemark *)placemark;
@end


@implementation PPLocatePostcode

@synthesize delegate, currentLocation, locationManager, reverseGeocoder;

- (id) init
{
	self = [super init];
	if (self != nil) {
		
	}
	return self;
}

- (PPLocatePostcode *) initWithDelegate:(id<PPLocatePostcodeDelegate>) aDelegate {
	[self init];
	delegate = aDelegate;
	return self;
}

- (void) dealloc
{
	if(currentLocation != nil) [currentLocation release];
	if(locationManager != nil) [locationManager release];
	[super dealloc];
}

- (void) findPostcode {
	bIgnoredFirstLocation = NO;
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self; // Tells the location manager to send updates to this object
	if (self.locationManager.locationServicesEnabled != YES) {
		[self callBackFail:@"CoreLocation has been disabled"];
		return;
	}
	[self.locationManager startUpdatingLocation];
}


#pragma mark Private Functions

- (void) processCurrentLocation {
	self.reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate: self.currentLocation.coordinate];
	self.reverseGeocoder.delegate = self;
	[self.reverseGeocoder start];
}

- (void) callBackSuccess:(NSString *)aPostcode {
	if (delegate)
		[delegate locatePostcodeSuccess:self Postcode:aPostcode];
}

- (void) callBackFail:(NSString *)aErrorMessage {
	if (delegate)
		[delegate locatePostcodeFailure:self ErrorMessage:aErrorMessage];
}

#pragma mark CLLocation Delegates
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
		
	if(newLocation.horizontalAccuracy < 500 
	   && newLocation.verticalAccuracy < 500
	   && oldLocation != NULL) {
		self.currentLocation = [newLocation copy];
		[self processCurrentLocation];
		[manager stopUpdatingLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error {
	
	NSMutableString *errorString = [[[NSMutableString alloc] init] autorelease];
	
	if ([error domain] == kCLErrorDomain) {		
		switch ([error code]) {
			case kCLErrorDenied:
				[errorString appendString:@"Access to your location has been denied."];
				break;
			case kCLErrorLocationUnknown:
				[errorString appendString:@"Location unknown, please try again."];
				break;
			default:
				[errorString appendFormat:@"%@ %d\n", @"Unknown error, code: ", [error code]];
				break;
		}
	} else {
		[errorString appendFormat:@"Error domain: \"%@\"  Error code: %d\n", [error domain], [error code]];
		[errorString appendFormat:@"Description: \"%@\"\n", [error localizedDescription]];
	}
	[self callBackFail:errorString];
}

#pragma mark MKReverseGeocoder Delegates
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder 
	   didFailWithError:(NSError *)error
{
	[geocoder release];
	[self callBackFail:@"Could not find current location"];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder 
	   didFindPlacemark:(MKPlacemark *)placemark
{
	[self callBackSuccess:[placemark.postalCode copy]];
	[geocoder release];
	
}

@end
