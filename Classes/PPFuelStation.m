//
//  PPFuelStation.m
//  Petrol Prices
//
//  Created by Marc Easen on 13/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PPFuelStation.h"


@implementation PPFuelStation

@synthesize coordinate;
@synthesize name;
@synthesize address;
@synthesize fuelType;
@synthesize price;

- (id) initWithCoordinate:(CLLocationCoordinate2D) aCoordinate;
{
	self = [super init];
	if (self != nil) {
		coordinate = aCoordinate;
	}
	return self;
}

- (NSString *)title {
	return [NSString stringWithFormat:@"%@ - %@", self.price, self.name];
}
- (NSString *)subtitle {
	return [NSString stringWithFormat:@"%@", self.address];
}
@end
