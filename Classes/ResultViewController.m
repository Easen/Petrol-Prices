//
//  ResultViewController.m
//  Petrol Prices
//
//  Created by Marc Easen on 12/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ResultViewController.h"
#import "PPFuelTypeController.h"

#define kCurrentlySearching @"Currently Searching, Please Wait..."
#define kAnErrorOccured @"An error has occured, please try again"
#define kNavigationTitle @"%@ near %@"

@implementation ResultViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	PPSearch *search = [PPSearch sharedInstance];
	if(search.results != nil) {
		[self searchSuccessfulWithResults:search.results MapRegion:search.resultsMapRegion];
	}
    [super viewDidLoad];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark PPSearch Delegates
- (void) searchBusy {
	PPSearch *searchObj = [PPSearch sharedInstance];
	fStatus.hidden = NO;
	fMap.hidden = YES;
	fStatus.text = kCurrentlySearching;
	fNavigationTitle.title = [NSString stringWithFormat:kNavigationTitle, 
							  [[PPFuelTypeController sharedInstance] getFuelTypeForPostValue:searchObj.fuelType].fuelName,
							  searchObj.postcode];
	[fSpinner startAnimating];
}
- (void) searchSuccessfulWithResults:(NSArray *)results MapRegion:(MKCoordinateRegion)mapRegion{
	PPSearch *searchObj = [PPSearch sharedInstance];
	fStatus.hidden = YES;
	fMap.hidden = NO;
	[fSpinner stopAnimating];
	[fMap removeAnnotations:[fMap annotations]];
	[fMap addAnnotations:results];
	[fMap setRegion:mapRegion animated:YES];
	[fMap setShowsUserLocation:searchObj.showUsersLocation];
}

- (void) searchFailWithTitle:(NSString *)aTitle Message:(NSString *)aErrorMessage {
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:aTitle message:aErrorMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[myAlertView show];
	[myAlertView release];
	fStatus.hidden = NO;
	fStatus.text = aTitle;
	[fSpinner stopAnimating];
	
}

#pragma mark MKMapView Delegates
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	if (annotation == mapView.userLocation) return nil;
	
	NSLog(@"%@", [annotation class]);
	PPFuelStation *fuelStation = annotation;
	NSString *name = [NSString stringWithFormat:@"%@ - %@", [fuelStation name], [fuelStation fuelType]];
	PPAnnotationView *ppAV;
	ppAV = (PPAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:name];
	if (ppAV == nil) {
		ppAV = [[PPAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:name];
	}
	
	return ppAV;
}

@end
