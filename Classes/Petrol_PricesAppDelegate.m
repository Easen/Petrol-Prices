//
//  Petrol_PricesAppDelegate.m
//  Petrol Prices
//
//  Created by Marc Easen on 12/06/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "Petrol_PricesAppDelegate.h"
#import "PPUser.h"

const Petrol_PricesAppDelegate *fPetrol_PricesAppDelegateSharedInstance;

@implementation Petrol_PricesAppDelegate

@synthesize window;
@synthesize tabBarController;

- (id) init
{
	if (fPetrol_PricesAppDelegateSharedInstance != nil)
		return fPetrol_PricesAppDelegateSharedInstance;
	self = [super init];
	if (self != nil) {
		fPetrol_PricesAppDelegateSharedInstance = self;
	}
	return self;
}

+ (Petrol_PricesAppDelegate *) sharedInstance {
	return fPetrol_PricesAppDelegateSharedInstance;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
	[self setUpLoggedOutUI];
}


/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}


- (void) setUpLoggedOutUI {
	[tabBarController setSelectedIndex:kAccountViewID];
	/*
	UITabBarItem *searchBarItem = [[[tabBarController tabBar] items] objectAtIndex:kSearchViewID];
	UITabBarItem *viewBarItem = [[[tabBarController tabBar] items] objectAtIndex:kResultsViewID];
	searchBarItem.enabled = NO;
	viewBarItem.enabled = NO;
	 */
}

- (void) setUpLoggedInUI {
	/*
	UITabBarItem *searchBarItem = [[[tabBarController tabBar] items] objectAtIndex:kSearchViewID];
	UITabBarItem *viewBarItem = [[[tabBarController tabBar] items] objectAtIndex:kResultsViewID];
	searchBarItem.enabled = YES;
	viewBarItem.enabled = YES;
	 */
}

@end

