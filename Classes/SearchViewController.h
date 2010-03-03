//
//  SearchViewController.h
//  Petrol Prices
//
//  Created by Marc Easen on 12/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPLocatePostcode.h"
#import "PPFuelTypeController.h"
#import "PPFuelType.h"

@interface SearchViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, PPLocatePostcodeDelegate> {
	IBOutlet UITextField *fPostcode;
	IBOutlet UISegmentedControl *fDistance;
	IBOutlet UIButton *fSearchButton;
	IBOutlet UIButton *fLocateMeButton;
	IBOutlet UIActivityIndicatorView *fLocateMeSpinner;
	IBOutlet UIBarButtonItem *fSearchBarButton;
	
	IBOutlet UILabel *fFuelType;
	IBOutlet UIView *fFuelTypeView;
	IBOutlet UIPickerView *fFuelTypePickerView;
	
	PPFuelType *selectedFuelType;
	BOOL locateMeCalled;
}
@property (nonatomic) PPFuelType *selectedFuelType;

- (IBAction) search:(id)sender;
- (IBAction) locateMe:(id)sender;
- (IBAction) showFuelPicker: (id) sender;
- (IBAction) doneFuelPicking: (id)sender;

- (void) setFuelTypeId:(NSInteger)aId;

@end
