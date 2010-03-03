//
//  PPAnnotationView.m
//  Petrol Prices
//
//  Created by Marc Easen on 14/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PPAnnotationView.h"
#import <QuartzCore/CABase.h>
#import "PPFuelStation.h"

@interface PPAnnotationView (Private)

- (void) createPriceLabel;

@end


@implementation PPAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	self.image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"station_pin.png"]];
	self.canShowCallout = YES;
	CGPoint offset;
	offset.y = (self.image.size.height / 2) * -1;
	offset.x = 0;
	self.centerOffset = offset;
	[self createPriceLabel];
	return self;
}

#pragma mark Private Functions
- (void) createPriceLabel {
	CGRect frame = [self frame];
	frame.origin.y = 0;
	frame.origin.x = 32;
	frame.size.height = 30;
	frame.size.width = 60;
	
	
	UILabel *priceLabel = [[UILabel alloc] initWithFrame:frame];
	priceLabel.text = ((PPFuelStation *)self.annotation).price;
	priceLabel.adjustsFontSizeToFitWidth = YES;
	priceLabel.backgroundColor = [UIColor clearColor];
	
	[self addSubview:priceLabel];
	 
	[priceLabel autorelease];
}
@end
