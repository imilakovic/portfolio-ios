//
//  ExperienceTimelineView.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "ExperienceTimelineView.h"

#import "NSString+P.h"
#import "UIColor+P.h"
#import "UIFont+P.h"

@interface ExperienceTimelineView ()

@property (strong, nonatomic) NSArray *labels;

@property (strong, nonatomic) UIView *progressBackgroundView;
@property (strong, nonatomic) UIView *progressView;

@end


@implementation ExperienceTimelineView

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        _progressBackgroundView = [UIView new];
        _progressBackgroundView.backgroundColor = [UIColor p_backgroundColor_shade1];
        _progressBackgroundView.clipsToBounds = YES;
        [self addSubview:_progressBackgroundView];
        
        _progressView = [UIView new];
        _progressView.backgroundColor = [UIColor p_textColor_faded];
        [_progressBackgroundView addSubview:_progressView];
    }
    return self;
}


#pragma mark - Public

- (void)setCompanies:(NSArray *)companies {
    _companies = nil;
    _companies = companies;
    
    [self createLabels];
    self.selectedIndex = 0;
}


- (void)setProgress:(float)progress {
    if (progress < 0.0) {
        _progress = 0.0;
    } else if (progress > 1.0) {
        _progress = 1.0;
    } else {
        _progress = progress;
    }
    
    [self updateProgress];
}


- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    [_labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        NSInteger index = _labels.count - 1 - idx; // Indexes are in reversed order
        label.textColor = _selectedIndex == index ? [UIColor p_textColor_default] : [UIColor p_textColor_faded];
    }];
}


#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
    _progressBackgroundView.frame = CGRectMake(size.width - 8.0, 20.0, 8.0, size.height - 40.0);
    [self updateProgress];
    
    CGFloat spacing = _progressBackgroundView.frame.size.height / (_labels.count - 1);
    [_labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.frame = CGRectMake(0.0, 0.0, size.width - _progressBackgroundView.frame.size.width - 5.0, 40.0);
        label.center = CGPointMake(label.center.x, roundf(_progressBackgroundView.frame.origin.y + idx * spacing));
    }];
}


#pragma mark - Private

- (void)createLabels {
    for (UILabel *label in _labels) {
        [label removeFromSuperview];
    }
    _labels = nil;
    
    NSMutableArray *labels = [NSMutableArray new];
    
    UIFont *font = [UIFont p_fontOfSize:10.0];
    UIColor *textColor = [UIColor p_textColor_faded];
    
    UILabel *nowLabel = [UILabel new];
    nowLabel.font = font;
    nowLabel.text = @"Today";
    nowLabel.textAlignment = NSTextAlignmentRight;
    nowLabel.textColor = textColor;
    [self addSubview:nowLabel];
    [labels addObject:nowLabel];
    
    for (NSInteger i = _companies.count - 1; i >= 0; i--) {
        NSDictionary *company = _companies[i];
        UILabel *label = [UILabel new];
        label.font = font;
        label.numberOfLines = 2;
        label.text = [NSString stringWithFormat:@"%@\n%@", [company[@"start_date"] p_formattedDateString], company[@"title"]];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = textColor;
        [self addSubview:label];
        [labels addObject:label];
    }
    
    self.labels = labels;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


- (void)updateProgress {
    CGFloat height = _progressBackgroundView.bounds.size.height * _progress;
    _progressView.frame = CGRectMake(0.0, _progressBackgroundView.bounds.size.height - height, _progressBackgroundView.bounds.size.width, height);
}


@end
