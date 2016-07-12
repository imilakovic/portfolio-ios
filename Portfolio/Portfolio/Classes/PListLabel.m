//
//  PListLabel.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "PListLabel.h"

#import "UIColor+P.h"
#import "UIFont+P.h"
#import "UIView+IMFrame.h"

@interface PListLabel ()

@property (strong, nonatomic) UILabel *listSymbolLabel;
@property (strong, nonatomic) UILabel *textLabel;

@end


@implementation PListLabel

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        _font = [UIFont p_fontOfSize:12.0];
        _textColor = [UIColor p_textColor_default];
        _listSymbolWidth = 12.0;
        
        _listSymbolLabel = [UILabel new];
        _listSymbolLabel.font = _font;
        _listSymbolLabel.text = @"•";
        _listSymbolLabel.textColor = _textColor;
        [self addSubview:_listSymbolLabel];
        
        _textLabel = [UILabel new];
        _textLabel.font = _font;
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = _textColor;
        [self addSubview:_textLabel];
    }
    return self;
}


#pragma mark - Public

- (void)setText:(NSString *)text {
    _text = nil;
    _text = text;
    
    _textLabel.text = _text;
}


#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
    CGFloat symbolHeight = ceilf([_listSymbolLabel.text sizeWithAttributes:@{NSFontAttributeName: _listSymbolLabel.font}].height);
    
    _listSymbolLabel.frame = CGRectMake(0.0, 0.0, _listSymbolWidth, symbolHeight);
    _textLabel.frame = CGRectMake(_listSymbolLabel.right, 0.0, size.width - _listSymbolLabel.right, size.height);
}


- (CGFloat)preferredHeightForWidth:(CGFloat)width {
    CGFloat textWidth = width - _listSymbolWidth;
    return ceilf([_textLabel.text boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName: _textLabel.font}
                                               context:nil].size.height);
}


@end
