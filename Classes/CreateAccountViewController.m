//
//  CreateAccountViewController.m
//  Petrol Prices
//
//  Created by Marc Easen on 13/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CreateAccountViewController.h"


@implementation CreateAccountViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	// Navigate to the sign up page
	[fWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://passport.fubra.com/site/pp/signup/?passback=a%3A1%3A%7Bs%3A8%3A%22redirect%22%3Bs%3A36%3A%22http%253A%252F%252Fwww.petrolprices.com%252F%22%3B%7D"]]];
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


- (IBAction) done:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

@end
