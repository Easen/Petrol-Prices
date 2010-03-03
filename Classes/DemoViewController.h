//
//  DemoViewController.h
//  Petrol Prices
//
//  Created by Marc Easen on 17/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoPageViewController.h"


@interface DemoViewController : UIViewController <UIScrollViewDelegate> {
	IBOutlet UIWindow *window;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    NSMutableArray *viewControllers;
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;

- (IBAction) changePage:(id)sender;
- (IBAction) done:(id)sender;

@end
