//
//  PPFuelStation.h
//  Petrol Prices
//
//  Created by Marc Easen on 13/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PPFuelStation : NSObject {
	CLLocationCoordinate2D coordinate;
	NSString *name;
	NSString *address;
	NSString *fuelType;
	NSString *price;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (readwrite, retain) NSString *name;
@property (readwrite, retain) NSString *address;
@property (readwrite, retain) NSString *fuelType;
@property (readwrite, retain) NSString *price;

- (id) initWithCoordinate:(CLLocationCoordinate2D) aCoordinate;
- (NSString *)title;
- (NSString *)subtitle;

@end
