//
//  AppsViewController.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "AppsViewController.h"

#import "AppViewController.h"
#import "PCrossfadingImageView.h"
#import "PHintController.h"

@interface AppsViewController ()

@property (strong, nonatomic) NSArray *viewControllers;
@property (assign, nonatomic) NSInteger currentViewControllerIndex;
@property (weak, nonatomic) AppViewController *currentViewController;
@property (weak, nonatomic) AppViewController *previousViewController;
@property (weak, nonatomic) AppViewController *nextViewController;

@property (strong, nonatomic) PCrossfadingImageView *crossfadingImageView;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) BOOL firstAppearance;

@end


@implementation AppsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _crossfadingImageView = [PCrossfadingImageView new];
    [self.view addSubview:_crossfadingImageView];
    
    _scrollView = [UIScrollView new];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    NSArray *apps = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"apps" ofType:@"plist"]];
    
    NSMutableArray *imageNames = [NSMutableArray new];
    NSMutableArray *viewControllers = [NSMutableArray new];
    for (NSDictionary *app in apps) {
        [imageNames addObject:app[@"image"]];
        
        AppViewController *appViewController = [[AppViewController alloc] initWithAppDictionary:app];
        [viewControllers addObject:appViewController];
    }
    
    _crossfadingImageView.imageNames = imageNames;
    self.viewControllers = viewControllers;
    _currentViewControllerIndex = -1;
    _firstAppearance = YES;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_firstAppearance) {
        return;
    }
    
    self.currentViewControllerIndex = 0;
    
    _firstAppearance = NO;
}


#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _crossfadingImageView.frame = self.view.bounds;
    _scrollView.frame = self.view.bounds;
    
    _currentViewController.view.frame = CGRectMake(_currentViewControllerIndex * _scrollView.width, 0.0, _scrollView.width, _scrollView.height);
    _previousViewController.view.frame = CGRectMake((_currentViewControllerIndex - 1) * _scrollView.width, 0.0, _scrollView.width, _scrollView.height);
    _nextViewController.view.frame = CGRectMake((_currentViewControllerIndex + 1) * _scrollView.width, 0.0, _scrollView.width, _scrollView.height);
    
    _scrollView.contentSize = CGSizeMake(_viewControllers.count * _scrollView.width, _scrollView.height);
}


#pragma mark - Private

- (void)setCurrentViewControllerIndex:(NSInteger)currentViewControllerIndex {
    if (_currentViewControllerIndex == currentViewControllerIndex) {
        return;
    }
    _currentViewControllerIndex = currentViewControllerIndex;
    
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
    self.currentViewController = nil;
    
    [self.previousViewController.view removeFromSuperview];
    [self.previousViewController removeFromParentViewController];
    self.previousViewController = nil;
    
    [self.nextViewController.view removeFromSuperview];
    [self.nextViewController removeFromParentViewController];
    self.nextViewController = nil;
    
    NSInteger previousViewControllerIndex = _currentViewControllerIndex - 1;
    NSInteger nextViewControllerIndex = _currentViewControllerIndex + 1;
    
    self.currentViewController = _viewControllers[_currentViewControllerIndex];
    [self addChildViewController:self.currentViewController];
    [_scrollView addSubview:self.currentViewController.view];
    
    if (previousViewControllerIndex >= 0) {
        self.previousViewController = _viewControllers[previousViewControllerIndex];
        [self addChildViewController:self.previousViewController];
        [_scrollView addSubview:self.previousViewController.view];
    }
    
    if (nextViewControllerIndex < _viewControllers.count) {
        self.nextViewController = _viewControllers[nextViewControllerIndex];
        [self addChildViewController:self.nextViewController];
        [_scrollView addSubview:self.nextViewController.view];
    }
    
    [self.view setNeedsLayout];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _crossfadingImageView.offset = _scrollView.contentOffset.x;
    self.currentViewControllerIndex = (NSInteger)(_scrollView.contentOffset.x / _scrollView.width);
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[PHintController shared] hideHintWithKey:HINT_KEY_APPS_SCREEN];
}


#pragma mark - IMDrawersMenuControllerDelegate

- (void)menuControllerWillPresentMenuView:(IMDrawersMenuController *)menuController {
    [[PHintController shared] hideHintWithKey:nil];
}


- (void)menuControllerDidDismissMenuView:(IMDrawersMenuController *)menuController {
    [[PHintController shared] showHintWithKey:HINT_KEY_APPS_SCREEN];
}


@end
