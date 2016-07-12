//
//  IMDrawersMenuController.h
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>

#import "IMDrawersMenuItem.h"
#import "IMDrawersMenuView.h"

@protocol IMDrawersMenuControllerDelegate;

@interface IMDrawersMenuController : UIViewController

@property (copy, nonatomic) NSArray *viewControllers;
@property (weak, nonatomic) id<IMDrawersMenuControllerDelegate> delegate;
@property (strong, nonatomic) IMDrawersMenuView *menuView;
@property (nonatomic) NSUInteger selectedIndex;

- (NSString *)excludedViewControllerClass;
- (UIViewController *)selectedViewController;
- (void)toggleMenuView;

@end


@protocol IMDrawersMenuControllerDelegate <NSObject>

@optional
- (void)menuControllerWillPresentMenuView:(IMDrawersMenuController *)menuController;
- (void)menuControllerDidPresentMenuView:(IMDrawersMenuController *)menuController;
- (void)menuControllerWillDismissMenuView:(IMDrawersMenuController *)menuController;
- (void)menuControllerDidDismissMenuView:(IMDrawersMenuController *)menuController;

@end


@interface UIViewController (IMDrawersMenuController)

@property (readonly, nonatomic) IMDrawersMenuController *im_menuController;

@end
