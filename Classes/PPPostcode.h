//
//  PPPostcode.h
//  Petrol Prices
//
//  Created by Marc Easen on 20/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PPPostcode : NSObject {
	CLLocationCoordinate2D coord;
	NSString *postcode;
}
@property (assign) CLLocationCoordinate2D coord;
@property (assign) NSString *postcode;

- (id) initWithPostcode:(NSString *)aPostcode Coordinate:(CLLocationCoordinate2D)aCoord;
@end
