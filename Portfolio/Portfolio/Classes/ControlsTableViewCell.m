//
//  ControlsTableViewCell.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "ControlsTableViewCell.h"

#import "UIColor+P.h"
#import "UIFont+P.h"
#import "UIView+IMFrame.h"

@implementation ControlsTableViewCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _appImageView = [UIImageView new];
        _appImageView.clipsToBounds = YES;
        [self.contentView addSubview:_appImageView];
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont p_boldFontOfSize:14.0];
        _titleLabel.textColor = [UIColor p_textColor_default];
        [self.contentView addSubview:_titleLabel];
        
        _projectLabel = [UILabel new];
        _projectLabel.font = [UIFont p_fontOfSize:12.0];
        _projectLabel.textColor = [UIColor p_textColor_faded];
        [self.contentView addSubview:_projectLabel];
    }
    return self;
}


#pragma mark - Public

- (void)setControl:(NSDictionary *)control {
    _control = nil;
    _control = control;
    
    _appImageView.image = [UIImage imageNamed:_control[@"image"]];
    _titleLabel.text = _control[@"title"];
    _projectLabel.text = _control[@"project"];
}


#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.contentView.bounds.size;
    
    CGFloat margin = 20.0;
    CGFloat imageSide = 60.0;
    CGFloat textHeight = 20.0;
    
    CGFloat x = margin;
    
    _appImageView.frame = CGRectMake(x, roundf((size.height - imageSide) / 2.0), imageSide, imageSide);
    _appImageView.layer.cornerRadius = imageSide * 0.2;
    x += _appImageView.width + margin;
    
    CGFloat textWidth = size.width - x - margin;
    _titleLabel.frame = CGRectMake(x, CGRectGetMidY(self.contentView.bounds) - textHeight, textWidth, textHeight);
    _projectLabel.frame = CGRectMake(x, CGRectGetMidY(self.contentView.bounds), textWidth, textHeight);
}


@end
