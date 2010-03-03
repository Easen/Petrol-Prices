//
//  PPFuelTypeController.h
//  Petrol Prices
//
//  Created by Marc Easen on 19/07/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPFuelType.h"

@interface PPFuelTypeController : NSObject {
	NSArray *fArrayOfFuelTypes;
}

+ (PPFuelTypeController *) sharedInstance;
- (PPFuelType *)getFuelTypeForId:(NSInteger) aId;
- (PPFuelType *)getFuelTypeForPostValue:(NSInteger) aPostValue;
- (NSInteger) count;
@end
