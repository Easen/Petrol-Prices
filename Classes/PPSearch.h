//
//  PPSearch.h
//  Petrol Prices
//
//  Created by Marc Easen on 12/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "HTTPGet.h"
#import "PPFuelStation.h"

typedef enum  {
	PPSearchFuelTypeNone = 0,
	PPSearchFuelTypeSuperUnleaded = 1,
	PPSearchFuelTypeUnleaded = 2,
	PPSearchFuelTypeLRP = 4,
	PPSearchFuelTypePremiumDiesel = 5,
	PPSearchFuelTypeDiesel = 6,
	PPSearchFuelTypeLPG = 7	
}PPSearchFuelType;

@protocol PPSearchDelegate;

@interface PPSearch : NSObject <HTTPGetDelegate> {
	id<PPSearchDelegate> delegate;
	BOOL isBusy;
	NSString *postcode;
	NSString *distance;
	PPSearchFuelType fuelType;
	NSArray *results;
	MKCoordinateRegion resultsMapRegion;
	BOOL showUsersLocation;
}

@property (readonly) BOOL isBusy;
@property (readonly) NSString *postcode;
@property (readonly) NSString *distance;
@property (readonly) PPSearchFuelType fuelType;
@property (readonly) NSArray *results;
@property (readonly) MKCoordinateRegion resultsMapRegion;
@property (readonly) BOOL showUsersLocation;

+ (PPSearch *) sharedInstance;
- (void) searchWithPostcode:(NSString *)aPostcode 
				   Distance:(NSString *)aDistance 
				   FuelType:(PPSearchFuelType)aFuelType 
	 ShowUsersLocationOnMap:(BOOL)aShowUsersLocation	
				   Delegate:(id<PPSearchDelegate>)aDelegate;
- (PPSearchFuelType) getFuelTypeFromString:(NSString *) aFuelType;

@end

@protocol PPSearchDelegate<NSObject>

- (void) searchBusy;
- (void) searchSuccessfulWithResults:(NSArray *)results MapRegion:(MKCoordinateRegion)mapRegion;
- (void) searchFailWithTitle:(NSString *)aTitle Message:(NSString *)aErrorMessage;

@end
