//
//  RatingSliderViewController.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "RatingSliderViewController.h"

#import "IMRatingSlider.h"

@interface RatingSliderViewController ()

@property (strong, nonatomic) NSArray *testRatings;

@property (strong, nonatomic) IMRatingSlider *ratingSlider;
@property (strong, nonatomic) NSArray *ratingButtons;
@property (strong, nonatomic) UIButton *resetButton;

@end


@implementation RatingSliderViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Rating Slider";
    
    _testRatings = @[@(2.0), @(4.5)];
    
    [self createSlider];
    
    NSMutableArray *ratingButtons = [NSMutableArray new];
    [_testRatings enumerateObjectsUsingBlock:^(NSNumber *rating, NSUInteger idx, BOOL *stop) {
        UIButton *ratingButton = [UIButton buttonWithType:UIButtonTypeSystem];
        ratingButton.backgroundColor = [UIColor p_backgroundColor_shade1];
        ratingButton.tag = idx;
        ratingButton.titleLabel.font = [UIFont p_fontOfSize:12.0];
        [ratingButton addTarget:self action:@selector(ratingButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [ratingButton setTitle:[NSString stringWithFormat:@"Select: %.1f", rating.floatValue] forState:UIControlStateNormal];
        [ratingButton setTitleColor:[UIColor p_textColor_default] forState:UIControlStateNormal];
        [self.view addSubview:ratingButton];
        [ratingButtons addObject:ratingButton];
    }];
    self.ratingButtons = ratingButtons;
    
    _resetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _resetButton.backgroundColor = [UIColor p_backgroundColor_shade1];
    _resetButton.titleLabel.font = [UIFont p_fontOfSize:12.0];
    [_resetButton addTarget:self action:@selector(resetButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [_resetButton setTitleColor:[UIColor p_textColor_default] forState:UIControlStateNormal];
    [self.view addSubview:_resetButton];
}


#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    
    CGFloat margin = 20.0;
    CGFloat contentWidth = size.width - margin * 2.0;
    
    CGFloat y = margin;
    
    _ratingSlider.frame = CGRectMake(0.0, y, size.width, 90.0);
    y += _ratingSlider.frame.size.height + 20.0;
    
    for (UIButton *ratingButton in _ratingButtons) {
        ratingButton.frame = CGRectMake(margin, y, contentWidth, 60.0);
        y += ratingButton.frame.size.height + 20.0;
    }
    
    _resetButton.frame = CGRectMake(margin, y, contentWidth, 60.0);
}


#pragma mark - Button actions

- (void)ratingButtonTapped:(UIButton *)sender {
    [self createSlider];
    
    NSNumber *rating = _testRatings[sender.tag];
    [_ratingSlider setRating:rating.floatValue animated:YES];
}


- (void)resetButtonTapped:(UIButton *)sender {
    [self createSlider];
}


#pragma mark - Private

- (void)createSlider {
    [_ratingSlider removeFromSuperview];
    _ratingSlider = nil;
    
    _ratingSlider = [IMRatingSlider new];
    _ratingSlider.instructionsFont = [UIFont p_fontOfSize:10.0];
    _ratingSlider.ratingFont = [UIFont p_fontOfSize:14.0];
    [self.view addSubview:_ratingSlider];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}


@end
