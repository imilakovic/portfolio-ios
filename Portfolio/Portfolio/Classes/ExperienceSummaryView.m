//
//  ExperienceSummaryView.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "ExperienceSummaryView.h"

#import "PListLabel.h"
#import "UIColor+P.h"
#import "UIFont+P.h"
#import "UIView+IMFrame.h"

@interface ExperienceSummaryView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *experienceTitleLabel;
@property (strong, nonatomic) UILabel *experienceYearLabel;
@property (strong, nonatomic) UILabel *experienceMonthLabel;
@property (strong, nonatomic) UILabel *experienceDayLabel;
@property (strong, nonatomic) UILabel *skillsTitleLabel;
@property (strong, nonatomic) NSArray *skillLabels;

@end


@implementation ExperienceSummaryView

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont p_boldFontOfSize:12.0];
        _titleLabel.text = @"Summary";
        _titleLabel.textColor = [UIColor p_textColor_default];
        [self addSubview:_titleLabel];
        
        _experienceTitleLabel = [UILabel new];
        _experienceTitleLabel.font = [UIFont p_fontOfSize:12.0];
        _experienceTitleLabel.text = @"Total experience:";
        _experienceTitleLabel.textColor = [UIColor p_textColor_default];
        [self addSubview:_experienceTitleLabel];
        
        _experienceYearLabel = [UILabel new];
        _experienceYearLabel.font = [UIFont p_fontOfSize:12.0];
        _experienceYearLabel.textColor = [UIColor p_textColor_faded];
        [self addSubview:_experienceYearLabel];
        
        _experienceMonthLabel = [UILabel new];
        _experienceMonthLabel.font = [UIFont p_fontOfSize:12.0];
        _experienceMonthLabel.textColor = [UIColor p_textColor_faded];
        [self addSubview:_experienceMonthLabel];
        
        _experienceDayLabel = [UILabel new];
        _experienceDayLabel.font = [UIFont p_fontOfSize:12.0];
        _experienceDayLabel.textColor = [UIColor p_textColor_faded];
        [self addSubview:_experienceDayLabel];
        
        _skillsTitleLabel = [UILabel new];
        _skillsTitleLabel.font = [UIFont p_fontOfSize:12.0];
        _skillsTitleLabel.text = @"Skills and technologies:";
        _skillsTitleLabel.textColor = [UIColor p_textColor_default];
        [self addSubview:_skillsTitleLabel];
        
        NSArray *skills = @[@"Objective-C",
                            @"a bit of Swift",
                            @"iOS SDK",
                            @"Java",
                            @"Android SDK",
                            @"JSON API integration",
                            @"a bit of Node.js and MySQL",
                            @"Git version control",
                            @"project management"];
        NSMutableArray *skillLabels = [NSMutableArray new];
        for (NSString *skill in skills) {
            PListLabel *skillLabel = [PListLabel new];
            skillLabel.text = skill;
            [self addSubview:skillLabel];
            [skillLabels addObject:skillLabel];
        }
        self.skillLabels = skillLabels;
    }
    return self;
}


- (void)setStartDate:(NSString *)startDate {
    _startDate = nil;
    _startDate = startDate;
    
    [self updateExperienceLabels];
}


#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
    CGFloat margin = 10.0;
    CGFloat contentWidth = size.width - margin * 2.0;
    
    CGFloat y = 0.0;
    
    _titleLabel.frame = CGRectMake(margin, y, contentWidth, 16.0);
    y += _titleLabel.height + 16.0;
    
    _experienceTitleLabel.frame = CGRectMake(margin, y, contentWidth, 16.0);
    y += _experienceTitleLabel.height;
    
    _experienceYearLabel.frame = CGRectMake(margin, y, contentWidth, 16.0);
    y += _experienceYearLabel.height;
    
    _experienceMonthLabel.frame = CGRectMake(margin, y, contentWidth, 16.0);
    y += _experienceMonthLabel.height;
    
    _experienceDayLabel.frame = CGRectMake(margin, y, contentWidth, 16.0);
    y += _experienceDayLabel.height + 16.0;
    
    _skillsTitleLabel.frame = CGRectMake(margin, y, contentWidth, 16.0);
    y += _skillsTitleLabel.height + 1.0;
    
    for (PListLabel *skillLabel in _skillLabels) {
        skillLabel.frame = CGRectMake(margin, y, contentWidth, [skillLabel preferredHeightForWidth:contentWidth]);
        y += skillLabel.height + 2.0;
    }
}


#pragma mark - Private

- (NSAttributedString *)attributedStringForString:(NSString *)string length:(NSInteger)length {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont p_boldFontOfSize:12.0] range:NSMakeRange(0, length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor p_textColor_default] range:NSMakeRange(0, length)];
    return attributedString;
}


- (NSDateComponents *)elapsedDateComponents {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *fromDate = [dateFormatter dateFromString:_startDate];
    NSDate *toDate = [NSDate date];
    
    NSCalendarUnit components = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    return [[NSCalendar currentCalendar] components:components fromDate:fromDate toDate:toDate options:0];
}


- (void)updateExperienceLabels {
    NSDateComponents *components = [self elapsedDateComponents];
    
    NSString *year = @(components.year).stringValue;
    NSString *month = @(components.month).stringValue;
    NSString *day = @(components.day).stringValue;
    
    _experienceYearLabel.attributedText = [self attributedStringForString:[NSString stringWithFormat:@"%@ %@", year, year.integerValue == 1 ? @"year" : @"years"] length:year.length];
    _experienceMonthLabel.attributedText = [self attributedStringForString:[NSString stringWithFormat:@"%@ %@", month, month.integerValue == 1 ? @"month" : @"months"] length:month.length];
    _experienceDayLabel.attributedText = [self attributedStringForString:[NSString stringWithFormat:@"%@ %@", day, day.integerValue == 1 ? @"day" : @"days"] length:day.length];
}


@end
