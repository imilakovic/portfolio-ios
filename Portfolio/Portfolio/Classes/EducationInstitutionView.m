//
//  EducationInstitutionView.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "EducationInstitutionView.h"

#import "UIColor+P.h"
#import "UIFont+P.h"
#import "UIView+IMFrame.h"

@interface EducationInstitutionView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *timelineLabel;
@property (strong, nonatomic) UILabel *majorLabel;
@property (strong, nonatomic) UILabel *noteLabel;
@property (strong, nonatomic) UIImageView *imageView;

@end


@implementation EducationInstitutionView

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont p_boldFontOfSize:14.0];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor p_textColor_default];
        [self addSubview:_titleLabel];
        
        _timelineLabel = [UILabel new];
        _timelineLabel.font = [UIFont p_fontOfSize:12.0];
        _timelineLabel.textAlignment = NSTextAlignmentCenter;
        _timelineLabel.textColor = [UIColor p_textColor_faded];
        [self addSubview:_timelineLabel];
        
        _majorLabel = [UILabel new];
        _majorLabel.font = [UIFont p_fontOfSize:12.0];
        _majorLabel.textAlignment = NSTextAlignmentCenter;
        _majorLabel.textColor = [UIColor p_textColor_default];
        [self addSubview:_majorLabel];
        
        _noteLabel = [UILabel new];
        _noteLabel.font = [UIFont p_boldFontOfSize:12.0];
        _noteLabel.numberOfLines = 0;
        _noteLabel.textAlignment = NSTextAlignmentCenter;
        _noteLabel.textColor = [UIColor p_textColor_default];
        [self addSubview:_noteLabel];
        
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_imageView];
    }
    return self;
}


#pragma mark - Public

- (void)setInstitution:(NSDictionary *)institution {
    _institution = nil;
    _institution = institution;
    
    _titleLabel.text = _institution[@"title"];
    _timelineLabel.text = _institution[@"timeline"];
    _majorLabel.text = _institution[@"major"];
    _noteLabel.text = _institution[@"note"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    _imageView.image = [[UIImage class] performSelector:NSSelectorFromString(_institution[@"image"])];
#pragma clang diagnostic pop
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


#pragma mark - Layout

- (CGPoint)imageViewCenter {
    return _imageView.center;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
    CGFloat margin = 20.0;
    CGFloat contentWidth = size.width - margin * 2.0;
    CGFloat imageWidth = 60.0;
    CGFloat imageHeight = 60.0;
    CGFloat imageMargin = 40.0;
    CGFloat imagePadding = roundf((size.width - imageMargin * 2.0 - imageWidth * _institutionsCount) / (_institutionsCount - 1));
    
    CGFloat y = margin;
    
    _titleLabel.frame = CGRectMake(margin, y, contentWidth, 40.0);
    y += _titleLabel.height;
    
    _timelineLabel.frame = CGRectMake(margin, y, contentWidth, 20.0);
    y += _timelineLabel.height + 10.0;
    
    _majorLabel.frame = CGRectMake(margin, y, contentWidth, 20.0);
    y += _majorLabel.height + 10.0;
    
    _noteLabel.frame = CGRectMake(margin, y, contentWidth, 80.0);
    y += _noteLabel.height;
    
    _imageView.frame = CGRectMake(imageMargin + self.tag * (imageWidth + imagePadding), size.height - _bottomMargin - imageHeight, imageWidth, imageHeight);
}


@end
