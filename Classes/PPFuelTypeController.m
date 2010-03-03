//
//  PPFuelTypeController.m
//  Petrol Prices
//
//  Created by Marc Easen on 19/07/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PPFuelTypeController.h"

const PPFuelTypeController *fPPFuelTypeControllerSharedInstance = nil;

@implementation PPFuelTypeController


- (id) init
{
	if (fPPFuelTypeControllerSharedInstance != nil)
		return fPPFuelTypeControllerSharedInstance;
	self = [super init];
	if (self != nil) {
		
		fArrayOfFuelTypes = [[NSArray arrayWithObjects:
							  [[PPFuelType alloc] initWithFuelName:@"Unleaded" PostValue:2],
							  [[PPFuelType alloc] initWithFuelName:@"Super Unleaded" PostValue:1],
							  [[PPFuelType alloc] initWithFuelName:@"Diesel" PostValue:6],
							  [[PPFuelType alloc] initWithFuelName:@"Premium Diesel" PostValue:6],
							  [[PPFuelType alloc] initWithFuelName:@"LPG" PostValue:7],
							  [[PPFuelType alloc] initWithFuelName:@"LRP" PostValue:4],
							 nil] retain];
		fPPFuelTypeControllerSharedInstance = self;
	}
	return self;
}

+ (PPFuelTypeController *) sharedInstance {
	if (fPPFuelTypeControllerSharedInstance == nil)
		fPPFuelTypeControllerSharedInstance = [[PPFuelTypeController alloc] init];
	return fPPFuelTypeControllerSharedInstance;
}

- (PPFuelType *)getFuelTypeForId:(NSInteger) aId {
	if (aId > [fArrayOfFuelTypes count])
		return nil;
	return [fArrayOfFuelTypes objectAtIndex:aId];
}

- (PPFuelType *)getFuelTypeForPostValue:(NSInteger) aPostValue {
	for(PPFuelType *fuelType in fArrayOfFuelTypes) {
		if(aPostValue == fuelType.postValue)
			return fuelType;
	}
	return nil;
}

- (NSInteger) count {
	return [fArrayOfFuelTypes count];
}
@end
