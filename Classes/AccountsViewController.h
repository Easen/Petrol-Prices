//
//  AccountsViewController.h
//  Petrol Prices
//
//  Created by Marc Easen on 12/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPUser.h"
#import "LoggingInViewController.h"
#import "CreateAccountViewController.h"
#import "DemoViewController.h"

@interface AccountsViewController : UIViewController <PPUserDelegate> {
	IBOutlet UITextField *fUsername;
	IBOutlet UITextField *fPassword;
	IBOutlet UISwitch *fRemember;
	IBOutlet UIButton *fLogin;
	IBOutlet UIButton *fLogout;
	IBOutlet UILabel *fLoggedIn;
	IBOutlet UIButton *fCreateAccount;
	IBOutlet LoggingInViewController *fLoggingInViewController;
	IBOutlet CreateAccountViewController *fCreateAccountViewController;
}

- (IBAction) login:(id)sender;
- (IBAction) logout:(id)sender;
- (IBAction) createAccount:(id)sender;
- (IBAction) showHelp:(id)sender;

@end
