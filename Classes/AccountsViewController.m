//
//  AccountsViewController.m
//  Petrol Prices
//
//  Created by Marc Easen on 12/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AccountsViewController.h"
#import "PPUser.h"
#import "Petrol_PricesAppDelegate.h"
#import "QuartzCore/CAAnimation.h"
#import "QuartzCore/CAMediaTimingFunction.h"

#define kUserData @"UserData.plist"

@interface AccountsViewController (Private)

BOOL fLoadedUserData;

- (void) changeToLoggedInState;
- (void) changeToLoggedOutState;
- (void) saveUserData;
- (void) loadUserData;

@end



@implementation AccountsViewController
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
	UILabel *leftLabel = [[[[[[fRemember subviews] lastObject] subviews] objectAtIndex:2] subviews] objectAtIndex:0]; 
	UILabel *rightLabel = [[[[[[fRemember subviews] lastObject] subviews] objectAtIndex:2] subviews] objectAtIndex:1]; 
	[leftLabel setText:@"Yes"];
	[rightLabel setText:@"No"];
	
	[self loadUserData];
	
	[super viewDidLoad];
	PPUser *user  = [PPUser sharedInstance];
	
	[self changeToLoggedOutState];
	
	if(user.LoggedIn == YES){
		[self changeToLoggedInState];
	} else {
		if (fRemember.on == YES && [fUsername.text length] > 0 && user.LoggedIn == NO)
			[self login:self];   
	}
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


- (IBAction) login:(id)sender {
	/*
	fLoggingInViewController = [[LoggingInViewController alloc] init];
	[self.view addSubview: fLoggingInViewController.view];
	
	CATransition *animation = [CATransition animation];
	
	[animation setDelegate:self];
	//kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade
	//kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
	[animation setType:kCATransitionMoveIn];
	[animation setSubtype:kCATransitionFromTop];
	[animation setDuration:0.75];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	
	[[fLoggingInViewController.view layer] addAnimation:animation forKey:kCATransition];
	*/
	[fUsername resignFirstResponder];
	[fPassword resignFirstResponder];
	[self presentModalViewController: fLoggingInViewController animated: YES];
	[fLoggingInViewController startSpinner];
	
	PPUser *user = [PPUser sharedInstance];
	[user loginWithUsername:[fUsername text] Password:[fPassword text] RememberDetails:fRemember.on WithDelegate:self];
	
}

- (IBAction) logout:(id)sender 
{
	NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray *cookies = [cookieJar cookies];
	for (NSHTTPCookie * aCookie in cookies) {
		[cookieJar deleteCookie:aCookie];
	}
	[self changeToLoggedOutState];
}

- (IBAction) createAccount:(id)sender {
	[fUsername resignFirstResponder];
	[fPassword resignFirstResponder];
	[self presentModalViewController: fCreateAccountViewController animated: YES];
}

#pragma mark Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if ([fUsername.text length] > 0) {
		fLogin.enabled = YES;
		fLogin.enabled = YES;
	} else {
		fLogin.enabled = NO;
		fLogin.enabled = NO;
	}
}

#pragma mark PPUser Delegates
- (void) loginSuccessful {
	[self saveUserData];
	[self dismissModalViewControllerAnimated:YES];
	
	[self changeToLoggedInState];
	
	Petrol_PricesAppDelegate *ppApp = [Petrol_PricesAppDelegate sharedInstance];
	[ppApp setUpLoggedInUI];
	[ppApp.tabBarController setSelectedIndex:kSearchViewID];
}

- (void) loginFail {
	[self dismissModalViewControllerAnimated:YES];
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Login Failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[myAlertView show];
	[myAlertView release];
	
	fUsername.enabled = YES;
	fPassword.enabled = YES;
	fRemember.enabled = YES;
	fLogin.enabled = YES;
	
}

#pragma mark Private Functions
- (void) changeToLoggedInState {
	fLogin.hidden = YES;
	fLogout.hidden = NO;
	fCreateAccount.hidden = YES;
	fLoggedIn.hidden = NO;
	fUsername.enabled = NO;
	fPassword.enabled = NO;
	fRemember.enabled = NO;
}

- (void) changeToLoggedOutState {
	fLogin.hidden = NO;
	fLogout.hidden = YES;
	fCreateAccount.hidden = NO;
	fLoggedIn.hidden = YES;
	fUsername.enabled = YES;
	fPassword.enabled = YES;
	fRemember.enabled = YES;
	[self textFieldDidEndEditing:fUsername];
}

- (void) saveUserData {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathToUserCopyOfPlist = [documentsDirectory stringByAppendingPathComponent:kUserData];
	
	NSMutableDictionary * root = [[NSMutableDictionary alloc] init];
	
	NSNumber *remember = [NSNumber numberWithInt:(int)fRemember.on];
	[root setValue:remember forKey:@"Remember"];
	if([remember intValue] == 0) {
		[root setValue:@"" forKey:@"Username"];
		[root setValue:@"" forKey:@"Password"];
	} else {
		[root setValue:fUsername.text forKey:@"Username"];
		[root setValue:fPassword.text forKey:@"Password"];
	}
	[root writeToFile:pathToUserCopyOfPlist atomically:YES];
}

- (void) loadUserData {
	if (fLoadedUserData == YES){
		PPUser *user = [PPUser sharedInstance];
		fUsername.text = user.Username;
		fPassword.text = user.Password;
		fRemember.on = user.Remember;
		
		[self changeToLoggedInState];
		return;
	}
	// Check if the file exisits
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathToUserCopyOfPlist = [documentsDirectory stringByAppendingPathComponent:kUserData];
    if ([fileManager fileExistsAtPath:pathToUserCopyOfPlist] == NO) {
        NSString *pathToDefaultPlist = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:kUserData];
        if ([fileManager copyItemAtPath:pathToDefaultPlist toPath:pathToUserCopyOfPlist error:&error] == NO) {
            NSAssert1(0, @"Failed to copy data with error message '%@'.", [error localizedDescription]);
        }
		
		// Show demo screen as this is the first time the app has been ran
		[self showHelp: nil];
		
    }
	
	NSDictionary * root = [[NSDictionary alloc] initWithContentsOfFile:pathToUserCopyOfPlist];

	NSNumber *remember = [root objectForKey:@"Remember"];
	fRemember.on = (BOOL)[remember intValue];
	
	if (fRemember.on == YES) {
		fUsername.text = [root objectForKey:@"Username"];
		fPassword.text = [root objectForKey:@"Password"];
	}
	
	[root release];
	fLoadedUserData = YES;	
}

- (IBAction) showHelp:(id)sender 
{
	DemoViewController *fDemoViewController = [[DemoViewController alloc] initWithNibName:@"DemoViewController" bundle:[NSBundle mainBundle]];
	[self presentModalViewController: fDemoViewController animated: YES];
	[fDemoViewController release];
}

@end
