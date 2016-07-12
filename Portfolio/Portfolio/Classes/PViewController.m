//
//  PViewController.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "PViewController.h"

@interface PViewController ()

@end


@implementation PViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor p_backgroundColor_default];
    
    self.navigationItem.title = self.navigationController.title;
    
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage p_icon_menu]
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(menuBarButtonItemTapped:)];
    } else if (self.needsBackButton) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage p_icon_back]
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(backBarButtonItemTapped:)];
        
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.im_menuController.delegate = self;
}


#pragma mark - Public

- (BOOL)needsBackButton {
    return self.navigationController.viewControllers.count > 1;
}


#pragma mark - Button actions

- (void)backBarButtonItemTapped:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)menuBarButtonItemTapped:(UIBarButtonItem *)sender {
    [self.im_menuController toggleMenuView];
}


@end
