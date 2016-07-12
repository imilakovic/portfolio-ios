//
//  PNavigationController.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "PNavigationController.h"

#import "UIColor+P.h"
#import "UIFont+P.h"
#import "UIImage+P.h"

@interface PNavigationController ()

@end


@implementation PNavigationController

#pragma mark - Init

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.navigationBar.shadowImage = [UIImage new];
        self.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont p_boldFontOfSize:16.0],
                                                   NSForegroundColorAttributeName: [UIColor p_textColor_default]};
        [self.navigationBar setBackgroundImage:[UIImage p_imageWithColor:[UIColor p_backgroundColor_shade1]] forBarMetrics:UIBarMetricsDefault];
    }
    return self;
}


@end
