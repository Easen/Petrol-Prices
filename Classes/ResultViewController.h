//
//  ResultViewController.h
//  Petrol Prices
//
//  Created by Marc Easen on 12/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PPSearch.h"
#import "PPFuelStation.h"
#import "PPAnnotationView.h"

@interface ResultViewController : UIViewController <PPSearchDelegate> {
	IBOutlet UINavigationItem *fNavigationTitle;
	IBOutlet MKMapView *fMap;
	IBOutlet UILabel *fStatus;
	IBOutlet UIActivityIndicatorView *fSpinner;
}

@end
