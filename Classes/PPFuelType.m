//
//  PPFuelType.m
//  Petrol Prices
//
//  Created by Marc Easen on 19/07/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PPFuelType.h"


@implementation PPFuelType

@synthesize fuelName, postValue;

- (id) init
{
	NSAssert(YES, @"Cannot call init");
	return NULL;
}

- (id) initWithFuelName:(NSString *)aFuelName PostValue:(NSInteger) aPostValue
{
	self = [super init];
	if (self != nil) {
		fuelName = aFuelName;
		postValue = aPostValue;
	}
	return self;
}



@end
