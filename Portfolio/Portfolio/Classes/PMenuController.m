//
//  PMenuController.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "PMenuController.h"

#import "AppsViewController.h"
#import "ContactViewController.h"
#import "ControlsViewController.h"
#import "EducationViewController.h"
#import "ExperienceViewController.h"
#import "IntroViewController.h"
#import "LanguageViewController.h"
#import "PNavigationController.h"

@interface PMenuController ()

@end


@implementation PMenuController

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        PNavigationController *appsNavigationController = [[PNavigationController alloc] initWithRootViewController:[AppsViewController new]];
        appsNavigationController.title = @"Apps";
        
        PNavigationController *controlsNavigationController = [[PNavigationController alloc] initWithRootViewController:[ControlsViewController new]];
        controlsNavigationController.title = @"Controls";
        
        PNavigationController *experienceNavigationController = [[PNavigationController alloc] initWithRootViewController:[ExperienceViewController new]];
        experienceNavigationController.title = @"Experience";
        
        PNavigationController *educationNavigationController = [[PNavigationController alloc] initWithRootViewController:[EducationViewController new]];
        educationNavigationController.title = @"Education";
        
        PNavigationController *languageNavigationController = [[PNavigationController alloc] initWithRootViewController:[LanguageViewController new]];
        languageNavigationController.title = @"Language";
        
        PNavigationController *contactNavigationController = [[PNavigationController alloc] initWithRootViewController:[ContactViewController new]];
        contactNavigationController.title = @"Contact";
        
        self.viewControllers = @[appsNavigationController,
                                 controlsNavigationController,
                                 experienceNavigationController,
                                 educationNavigationController,
                                 languageNavigationController,
                                 contactNavigationController,
                                 [IntroViewController new]];
        
        NSArray *colors = @[[UIColor p_backgroundColor_shade6],
                            [UIColor p_backgroundColor_shade5],
                            [UIColor p_backgroundColor_shade4],
                            [UIColor p_backgroundColor_shade3],
                            [UIColor p_backgroundColor_shade2],
                            [UIColor p_backgroundColor_shade1]];
        NSArray *defaultImages = @[[UIImage p_menu_apps_default],
                                   [UIImage p_menu_controls_default],
                                   [UIImage p_menu_experience_default],
                                   [UIImage p_menu_education_default],
                                   [UIImage p_menu_language_default],
                                   [UIImage p_menu_contact_default]];
        NSArray *selectedImages = @[[UIImage p_menu_apps_selected],
                                    [UIImage p_menu_controls_selected],
                                    [UIImage p_menu_experience_selected],
                                    [UIImage p_menu_education_selected],
                                    [UIImage p_menu_language_selected],
                                    [UIImage p_menu_contact_selected]];
        [self.menuView.items enumerateObjectsUsingBlock:^(IMDrawersMenuItem *item, NSUInteger idx, BOOL *stop) {
            item.backgroundColor = colors[idx];
            item.font = [UIFont p_boldFontOfSize:16.0];
            item.image = defaultImages[idx];
            item.highlightedImage = selectedImages[idx];
            item.highlightedTextColor = [UIColor p_textColor_default];
            item.textColor = [UIColor p_textColor_faded];
        }];
    }
    return self;
}


#pragma mark - Public

- (NSString *)excludedViewControllerClass {
    return @"IntroViewController";
}


@end
