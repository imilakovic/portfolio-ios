//
//  EducationViewController.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "EducationViewController.h"

#import "EducationInstitutionView.h"
#import "PHintController.h"
#import "PMath.h"

#define BOTTOM_MARGIN 20.0

@interface EducationViewController ()

@property (strong, nonatomic) UIImageView *manImageView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *bornLabel;
@property (strong, nonatomic) NSArray *institutionViews;

@property (strong, nonatomic) NSArray *scales;
@property (assign, nonatomic) CGPoint manImageViewOriginalCenter;
@property (assign, nonatomic) BOOL needsLayout;

@end


@implementation EducationViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _manImageView = [[UIImageView alloc] initWithImage:[UIImage p_education_man]];
    _manImageView.contentMode = UIViewContentModeCenter;
    _manImageView.layer.anchorPoint = CGPointMake(0.5, 1.0);
    [self.view addSubview:_manImageView];
    
    _scrollView = [UIScrollView new];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _bornLabel = [UILabel new];
    _bornLabel.font = [UIFont p_fontOfSize:12.0];
    _bornLabel.text = @"1985";
    _bornLabel.textAlignment = NSTextAlignmentCenter;
    _bornLabel.textColor = [UIColor p_textColor_faded];
    [_scrollView addSubview:_bornLabel];
    
    NSArray *institutions = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"education" ofType:@"plist"]];
    
    NSMutableArray *institutionViews = [NSMutableArray new];
    [institutions enumerateObjectsUsingBlock:^(NSDictionary *institution, NSUInteger idx, BOOL *stop) {
        EducationInstitutionView *institutionView = [EducationInstitutionView new];
        institutionView.institution = institution;
        institutionView.institutionsCount = institutions.count;
        institutionView.tag = idx;
        [_scrollView addSubview:institutionView];
        [institutionViews addObject:institutionView];
    }];
    self.institutionViews = institutionViews;
    
    _scales = @[@(0.3), @(0.7), @(0.85), @(1.0)];
    _needsLayout = YES;
}


#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (!_needsLayout) {
        return;
    }
    
    CGSize size = self.view.bounds.size;
    
    _scrollView.frame = self.view.bounds;
    _scrollView.contentSize = CGSizeMake((_institutionViews.count + 1) * _scrollView.width, _scrollView.height);
    
    _manImageView.frame = CGRectMake(roundf((size.width - _manImageView.image.size.width) / 2.0),
                                     roundf((size.height - _manImageView.image.size.height) / 2.0 - _manImageView.image.size.height / 2.0),
                                     _manImageView.image.size.width,
                                     _manImageView.image.size.height);
    _manImageViewOriginalCenter = _manImageView.center;
    
    CGFloat scale = [_scales[0] floatValue];
    _manImageView.transform = CGAffineTransformMakeScale(scale, scale);
    
    CGFloat bornLabelHeight = 50.0;
    _bornLabel.frame = CGRectMake(0.0, _manImageView.top - bornLabelHeight, _scrollView.width, bornLabelHeight);
    
    [self.institutionViews enumerateObjectsUsingBlock:^(EducationInstitutionView *institutionView, NSUInteger idx, BOOL *stop) {
        institutionView.frame = CGRectMake((idx + 1) * _scrollView.width, 0.0, _scrollView.width, _scrollView.height);
        institutionView.bottomMargin = _manImageView.image.size.height + BOTTOM_MARGIN * 2.0;
    }];
    
    _needsLayout = NO;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    
    CGFloat pageWidth = scrollView.width;
    CGFloat maxOffset = _institutionViews.count * pageWidth;
    
    // Indexes
    NSInteger currentPageIndex = (NSInteger)floorf(offset / pageWidth);
    if (currentPageIndex < 0) {
        currentPageIndex = 0;
    }
    
    NSInteger previousPageIndex = currentPageIndex - 1;
    NSInteger nextPageIndex = currentPageIndex + 1;
    
    // Setting min and max boundaries
    if (offset < 0.0) {
        offset = 0.0;
    } else if (offset > maxOffset) {
        offset = maxOffset;
    }
    
    // Institution view scale and center
    CGFloat offsetLeft = currentPageIndex * pageWidth;
    CGFloat offsetRight = (currentPageIndex + 1) * pageWidth;
    CGFloat centerBottomY = self.view.bounds.size.height - BOTTOM_MARGIN;
    
    if (offset > offsetLeft && offsetLeft <= offsetRight) {
        // Scale
        CGFloat minScale = currentPageIndex >= 0 && currentPageIndex < _scales.count ? [_scales[currentPageIndex] floatValue] : 1.0;
        CGFloat maxScale = nextPageIndex >= 0 && nextPageIndex < _scales.count ? [_scales[nextPageIndex] floatValue] : 1.0;
        CGFloat scale = NewValueUsingRangeConversion(offset, offsetLeft, offsetRight, minScale, maxScale);
        _manImageView.transform = CGAffineTransformMakeScale(scale, scale);
        
        // Center
        EducationInstitutionView *currentInstitutionView = currentPageIndex >= 0 && currentPageIndex < _institutionViews.count ? _institutionViews[currentPageIndex] : nil;
        EducationInstitutionView *previousInstitutionView = previousPageIndex >= 0 && previousPageIndex < _institutionViews.count ? _institutionViews[previousPageIndex] : nil;
        CGFloat centerX = NewValueUsingRangeConversion(offset,
                                                       offsetLeft,
                                                       offsetRight,
                                                       previousInstitutionView ? previousInstitutionView.imageViewCenter.x : _manImageViewOriginalCenter.x,
                                                       currentInstitutionView ? currentInstitutionView.imageViewCenter.x : _manImageViewOriginalCenter.x);
        CGFloat centerY = NewValueUsingRangeConversion(offset, offsetLeft, offsetRight, previousInstitutionView ? centerBottomY : _manImageViewOriginalCenter.y, centerBottomY);
        _manImageView.center = CGPointMake(centerX, centerY);
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[PHintController shared] hideHintWithKey:HINT_KEY_EDUCATION_SCREEN];
}


#pragma mark - IMDrawersMenuControllerDelegate

- (void)menuControllerWillPresentMenuView:(IMDrawersMenuController *)menuController {
    [[PHintController shared] hideHintWithKey:nil];
}


- (void)menuControllerDidDismissMenuView:(IMDrawersMenuController *)menuController {
    [[PHintController shared] showHintWithKey:HINT_KEY_EDUCATION_SCREEN];
}


@end
