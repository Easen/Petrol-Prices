//
//  Petrol_PricesAppDelegate.h
//  Petrol Prices
//
//  Created by Marc Easen on 12/06/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSearchViewID 0
#define kResultsViewID 1
#define kAccountViewID 2

@interface Petrol_PricesAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

+ (Petrol_PricesAppDelegate *) sharedInstance;
- (void) setUpLoggedOutUI;
- (void) setUpLoggedInUI;

@end
