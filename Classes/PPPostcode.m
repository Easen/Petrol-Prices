//
//  PPPostcode.m
//  Petrol Prices
//
//  Created by Marc Easen on 20/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PPPostcode.h"


@implementation PPPostcode

@synthesize coord;
@synthesize postcode;


- (id) initWithPostcode:(NSString *)aPostcode Coordinate:(CLLocationCoordinate2D)aCoord;
{
	self = [super init];
	if (self != nil) {
		postcode = aPostcode;
		coord = aCoord;
	}
	return self;
}

@end
