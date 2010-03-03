//
//  SearchViewController.m
//  Petrol Prices
//
//  Created by Marc Easen on 12/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "Petrol_PricesAppDelegate.h"
#import "PPSearch.h"

@implementation SearchViewController

@synthesize selectedFuelType;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	fPostcode.text = [PPSearch sharedInstance].postcode;
	[self setFuelTypeId:0];
	[self textFieldDidEndEditing:fPostcode];
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

- (IBAction) search:(id)sender {
	NSString *postcode = fPostcode.text;
	NSString *distance = [fDistance titleForSegmentAtIndex:[fDistance selectedSegmentIndex]];
	
	//NSLog(@"Search for Postcode:>%@<, Distance:>%@<, FuelType:>%@<", postcode, distance, fuelType);
	
	PPSearch *search = [PPSearch sharedInstance];
	if (search.isBusy == YES){
		UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please wait." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[myAlertView show];
		[myAlertView release];
	} else {
		Petrol_PricesAppDelegate *ppApp = [Petrol_PricesAppDelegate sharedInstance];
		[ppApp setUpLoggedInUI];
		[ppApp.tabBarController setSelectedIndex:kResultsViewID];
		
		id delegate = ppApp.tabBarController.selectedViewController;
		[search searchWithPostcode:postcode 
						  Distance:distance 
						  FuelType:self.selectedFuelType.postValue 
			ShowUsersLocationOnMap:locateMeCalled
						  Delegate:delegate];
	}
	
}
- (IBAction) locateMe:(id)sender {
	fLocateMeButton.enabled = NO;
	[fLocateMeSpinner startAnimating];
	PPLocatePostcode *locateMe = [[PPLocatePostcode alloc] initWithDelegate:self];
	[locateMe findPostcode];
}

- (IBAction) showFuelPicker: (id) sender {
	//fFuelTypeView.bounds.origin.y = self.view.bounds.size.height - fFuelType.bounds.size.height;
	Petrol_PricesAppDelegate *appDelegate = (Petrol_PricesAppDelegate *)[[UIApplication sharedApplication] delegate];
	CGRect frame = fFuelTypeView.frame;
	frame.origin.y = 220;
	[fFuelTypeView setFrame:frame];
	[appDelegate.window addSubview:fFuelTypeView]; 
	
	
}

- (IBAction) doneFuelPicking: (id)sender {
	[fFuelTypeView removeFromSuperview];
	[self setFuelTypeId:[fFuelTypePickerView selectedRowInComponent:0]];
}

- (void) setFuelTypeId:(NSInteger)aId {
	PPFuelType *fuelType = [[PPFuelTypeController sharedInstance] getFuelTypeForId:aId];
	if (nil == fuelType) return;
	
	self.selectedFuelType = fuelType;
	[fFuelType setText:self.selectedFuelType.fuelName];
}

#pragma mark Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if ([fPostcode.text length] > 0) {
		fSearchButton.enabled = YES;
		fSearchBarButton.enabled = YES;
	} else {
		fSearchButton.enabled = NO;
		fSearchBarButton.enabled = NO;
	}
}

#pragma mark UIPickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [[PPFuelTypeController sharedInstance] count];
}

#pragma mark UIPickerView Delegates
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [[PPFuelTypeController sharedInstance] getFuelTypeForId:row].fuelName;
}

#pragma mark PPLocatePostcode Delegates
- (void) locatePostcodeSuccess:(PPLocatePostcode *)locatePostcodeObj Postcode:(NSString *)aPostcode {
	NSArray *splitPostCode = [aPostcode componentsSeparatedByString:@" "];
	fPostcode.text = [splitPostCode objectAtIndex:0];
	[self textFieldDidEndEditing:fPostcode];
	locateMeCalled = YES;
	fLocateMeButton.enabled = YES;
	[fLocateMeSpinner stopAnimating];
}

- (void) locatePostcodeFailure:(PPLocatePostcode *)locatePostcodeObj ErrorMessage:(NSString *)aErrorMessage {
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"An Error Has Occured\n%@", aErrorMessage] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[myAlertView show];
	[myAlertView release];
	fLocateMeButton.enabled = YES;
	[fLocateMeSpinner stopAnimating];
	
}

@end
