//
//  PPAnnotationView.h
//  Petrol Prices
//
//  Created by Marc Easen on 14/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PPAnnotationView : MKAnnotationView {

}

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
@end
