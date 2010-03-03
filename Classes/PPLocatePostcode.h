//
//  PPLocatePostcode.h
//  Petrol Prices
//
//  Created by Marc Easen on 14/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@protocol PPLocatePostcodeDelegate;

@interface PPLocatePostcode : NSObject <CLLocationManagerDelegate, MKReverseGeocoderDelegate> {
	id<PPLocatePostcodeDelegate> delegate;
	CLLocation *currentLocation;
	CLLocationManager *locationManager;
	MKReverseGeocoder *reverseGeocoder;
}

@property (assign) id<PPLocatePostcodeDelegate> delegate;
@property (assign) CLLocation *currentLocation;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;

- (PPLocatePostcode *) initWithDelegate:(id<PPLocatePostcodeDelegate>) aDelegate;
- (void) findPostcode;

@end

@protocol PPLocatePostcodeDelegate

- (void) locatePostcodeSuccess:(PPLocatePostcode *)locatePostcodeObj Postcode:(NSString *)aPostcode;
- (void) locatePostcodeFailure:(PPLocatePostcode *)locatePostcodeObj ErrorMessage:(NSString *)aErrorMessage;

@end

