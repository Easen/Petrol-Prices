//
//  PPFuelType.h
//  Petrol Prices
//
//  Created by Marc Easen on 19/07/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PPFuelType : NSObject {
	NSString *fuelName;
	NSInteger postValue;
}

@property(nonatomic, readonly) NSString *fuelName;
@property(nonatomic, readonly) NSInteger postValue;

- (id) initWithFuelName:(NSString *)aFuelName PostValue:(NSInteger) aPostValue;

@end
