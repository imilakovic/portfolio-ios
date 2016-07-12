//
//  PViewController.h
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PMenuController.h"
#import "UIColor+P.h"
#import "UIFont+P.h"
#import "UIImage+P.h"
#import "UIImage+PIconFont.h"
#import "UIView+IMFrame.h"

@interface PViewController : UIViewController <IMDrawersMenuControllerDelegate>

// Public
- (BOOL)needsBackButton;

// Button actions
- (void)backBarButtonItemTapped:(UIBarButtonItem *)sender;
- (void)menuBarButtonItemTapped:(UIBarButtonItem *)sender;

@end
