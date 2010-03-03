//
//  LoggingViewController.h
//  Petrol Prices
//
//  Created by Marc Easen on 12/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoggingInViewController : UIViewController {
	IBOutlet UIActivityIndicatorView *fSpinner;
}
- (void) startSpinner;
- (void) stopSpinner;
@end
