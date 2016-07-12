//
//  ExperienceCompanyView.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "ExperienceCompanyView.h"

#import "NSString+P.h"
#import "PListLabel.h"
#import "UIColor+P.h"
#import "UIFont+P.h"
#import "UIView+IMFrame.h"

@interface ExperienceCompanyView ()

@property (strong, nonatomic) UILabel *positionLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *companyURLButton;
@property (strong, nonatomic) UILabel *timelineLabel;
@property (strong, nonatomic) NSArray *noteLabels;

@end


@implementation ExperienceCompanyView

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        _positionLabel = [UILabel new];
        _positionLabel.font = [UIFont p_boldFontOfSize:12.0];
        _positionLabel.textColor = [UIColor p_textColor_default];
        [self addSubview:_positionLabel];
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont p_fontOfSize:12.0];
        _titleLabel.textColor = [UIColor p_textColor_default];
        [self addSubview:_titleLabel];
        
        _companyURLButton = [UIButton new];
        _companyURLButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _companyURLButton.titleLabel.font = [UIFont p_fontOfSize:12.0];
        [_companyURLButton addTarget:self action:@selector(companyURLButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_companyURLButton setTitleColor:[UIColor p_textColor_default] forState:UIControlStateNormal];
        [_companyURLButton setTitleColor:[UIColor p_textColor_faded] forState:UIControlStateHighlighted];
        [self addSubview:_companyURLButton];
        
        _timelineLabel = [UILabel new];
        _timelineLabel.font = [UIFont p_fontOfSize:12.0];
        _timelineLabel.textColor = [UIColor p_textColor_faded];
        [self addSubview:_timelineLabel];
    }
    return self;
}


#pragma mark - UIViewGeometry

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return CGRectContainsPoint(_companyURLButton.frame, point);
}


#pragma mark - Public

- (void)setCompany:(NSDictionary *)company {
    _company = nil;
    _company = company;
    
    _positionLabel.text = _company[@"position"];
    _titleLabel.text = [NSString stringWithFormat:@"%@ | %@", _company[@"title"], _company[@"location"]];
    [_companyURLButton setTitle:_company[@"url"] forState:UIControlStateNormal];
    
    NSString *startDateString = [_company[@"start_date"] p_formattedDateString];
    NSString *endDateString = [_company[@"end_date"] p_formattedDateString];
    _timelineLabel.text = [NSString stringWithFormat:@"%@ - %@", startDateString, endDateString ? endDateString : @"now"];
    
    [self createNoteLabels];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
    CGFloat margin = 10.0;
    CGFloat contentWidth = size.width - margin * 2.0;
    
    CGFloat y = 0.0;
    
    _positionLabel.frame = CGRectMake(margin, y, contentWidth, 16.0);
    y += _positionLabel.height + 8.0;
    
    _titleLabel.frame = CGRectMake(margin, y, contentWidth, 16.0);
    y += _titleLabel.height;
    
    _companyURLButton.frame = CGRectMake(margin, y, contentWidth, 32.0);
    y += _companyURLButton.height;
    
    _timelineLabel.frame = CGRectMake(margin, y, contentWidth, 16.0);
    y += _timelineLabel.height + 16.0;
    
    for (PListLabel *noteLabel in _noteLabels) {
        noteLabel.frame = CGRectMake(margin, y, contentWidth, [noteLabel preferredHeightForWidth:contentWidth]);
        y += noteLabel.height + 2.0;
    }
}


#pragma mark - Button actions

- (void)companyURLButtonTapped:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:_company[@"url"]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}


#pragma mark - Private

- (void)createNoteLabels {
    for (PListLabel *noteLabel in _noteLabels) {
        [noteLabel removeFromSuperview];
    }
    _noteLabels = nil;
    
    NSMutableArray *noteLabels = [NSMutableArray new];
    for (NSString *note in _company[@"notes"]) {
        PListLabel *noteLabel = [PListLabel new];
        noteLabel.text = note;
        [self addSubview:noteLabel];
        [noteLabels addObject:noteLabel];
    }
    self.noteLabels = noteLabels;
}


@end
