//
//  ExperienceViewController.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "ExperienceViewController.h"

#import "ExperienceCompanyView.h"
#import "ExperienceSummaryView.h"
#import "ExperienceTimelineView.h"
#import "PHintController.h"
#import "PMath.h"

@interface ExperienceViewController ()

@property (strong, nonatomic) NSArray *companies;
@property (assign, nonatomic) NSInteger lastItemIndex;

@property (strong, nonatomic) ExperienceTimelineView *timelineView;
@property (strong, nonatomic) ExperienceCompanyView *companyView;
@property (strong, nonatomic) ExperienceSummaryView *summaryView;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) BOOL needsLayout;

@end


@implementation ExperienceViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _companies = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"experience" ofType:@"plist"]];
    _lastItemIndex = 0;
    
    _timelineView = [ExperienceTimelineView new];
    _timelineView.companies = _companies;
    [self.view addSubview:_timelineView];
    
    _summaryView = [ExperienceSummaryView new];
    [self.view addSubview:_summaryView];
    
    _scrollView = [UIScrollView new];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _companyView = [ExperienceCompanyView new];
    _companyView.company = _companies.count > _lastItemIndex ? _companies[_lastItemIndex] : nil;
    [self.view addSubview:_companyView];
    
    _needsLayout = YES;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _summaryView.startDate = _companies.count > 0 ? _companies[0][@"start_date"] : nil;
}


#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (!_needsLayout) {
        return;
    }
    
    _scrollView.frame = self.view.bounds;
    _scrollView.contentSize = CGSizeMake(_scrollView.width * (_companies.count + 1), _scrollView.height);
    
    _timelineView.frame = CGRectMake(0.0, 0.0, 80.0, self.view.height);
    _companyView.frame = CGRectMake(_timelineView.right + 10.0, 20.0, self.view.width - _timelineView.right - 20.0, self.view.height - 40.0);
    _summaryView.frame = CGRectMake(_companyView.right + 10.0, _companyView.y, _companyView.width, _companyView.height);
    
    _needsLayout = NO;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    
    CGFloat pageWidth = scrollView.width;
    CGFloat maxOffset = _companies.count * pageWidth;
    
    // Indexes
    NSInteger currentPageIndex = (NSInteger)floorf(offset / pageWidth);
    NSInteger currentItemIndex = (NSInteger)floor((offset - pageWidth / 2) / pageWidth) + 1;
    
    // Setting min and max boundaries
    if (offset < 0.0) {
        offset = 0.0;
    } else if (offset > maxOffset) {
        offset = maxOffset;
    }
    
    // Update timeline
    float progress = NewValueUsingRangeConversion(offset, 0.0, maxOffset, 0.0, 1.0);
    _timelineView.progress = progress;
    _timelineView.selectedIndex = currentItemIndex;
    
    // Update company view with current company
    if (currentItemIndex >= 0 && currentItemIndex < _companies.count && _lastItemIndex != currentItemIndex) {
        _companyView.company = _companies[currentItemIndex];
        _lastItemIndex = currentItemIndex;
    }
    
    // Item positioning
    CGFloat itemLeft = _timelineView.right;
    CGFloat itemCenter = _timelineView.right + 10.0;
    CGFloat itemRight = _timelineView.right + 20.0;
    
    // Company view frame
    CGFloat offsetLeft = currentPageIndex * pageWidth;
    CGFloat offsetCenter = currentPageIndex * pageWidth + pageWidth / 2;
    CGFloat offsetRight = (currentPageIndex + 1) * pageWidth;
    CGFloat companiesMaxOffset = _companies.count * pageWidth - pageWidth / 2.0;
    
    CGFloat companyAlpha = 1.0;
    CGFloat companyOriginX = itemCenter;
    if (offset > companiesMaxOffset) {
        companyOriginX = itemLeft;
        companyAlpha = 0.0;
    } else if (offset > offsetLeft && offset <= offsetCenter) {
        companyOriginX = NewValueUsingRangeConversion(offset, offsetLeft, offsetCenter, itemCenter, itemLeft);
        companyAlpha = NewValueUsingRangeConversion(offset, offsetLeft, offsetCenter, 1.0, 0.0);
    } else if (offset > offsetCenter && offset < offsetRight) {
        companyOriginX = NewValueUsingRangeConversion(offset, offsetCenter, offsetRight, itemRight, itemCenter);
        companyAlpha = NewValueUsingRangeConversion(offset, offsetCenter, offsetRight, 0.0, 1.0);
    }
    
    _companyView.alpha = companyAlpha;
    [_companyView setX:companyOriginX];
    
    // Summary view frame
    CGFloat summaryAlpha = 0.0;
    CGFloat summaryOriginX = itemRight;
    if (offset > companiesMaxOffset && offset <= maxOffset) {
        summaryOriginX = NewValueUsingRangeConversion(offset, companiesMaxOffset, maxOffset, itemRight, itemCenter);
        summaryAlpha = NewValueUsingRangeConversion(offset, companiesMaxOffset, maxOffset, 0.0, 1.0);
    } else if (offset > maxOffset) {
        summaryOriginX = itemCenter;
        summaryAlpha = 1.0;
    }
    
    _summaryView.alpha = summaryAlpha;
    [_summaryView setX:summaryOriginX];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[PHintController shared] hideHintWithKey:HINT_KEY_EXPERIENCE_SCREEN];
}


#pragma mark - IMDrawersMenuControllerDelegate

- (void)menuControllerWillPresentMenuView:(IMDrawersMenuController *)menuController {
    [[PHintController shared] hideHintWithKey:nil];
}


- (void)menuControllerDidDismissMenuView:(IMDrawersMenuController *)menuController {
    [[PHintController shared] showHintWithKey:HINT_KEY_EXPERIENCE_SCREEN];
}


@end
