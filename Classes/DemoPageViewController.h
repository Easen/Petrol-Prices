//
//  DemoPageViewController.h
//  Petrol Prices
//
//  Created by Marc Easen on 20/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DemoPageViewController : UIViewController {
	NSString *fImageFileName;
	IBOutlet UIImageView *imageView;
}
@property (nonatomic, assign) UIImageView *imageView;

- (id) initWithImage:(NSString *) aFileName;

@end
