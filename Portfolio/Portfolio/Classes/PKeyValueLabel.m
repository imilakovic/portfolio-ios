//
//  PKeyValueLabel.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "PKeyValueLabel.h"

#import "UIColor+P.h"
#import "UIFont+P.h"

@interface PKeyValueLabel ()

@property (strong, nonatomic) UILabel *keyLabel;
@property (strong, nonatomic) UILabel *valueLabel;

@end


@implementation PKeyValueLabel

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        _keyLabel = [UILabel new];
        _keyLabel.font = [UIFont p_fontOfSize:12.0];
        _keyLabel.textColor = [UIColor p_textColor_default];
        [self addSubview:_keyLabel];
        
        _valueLabel = [UILabel new];
        _valueLabel.font = [UIFont p_boldFontOfSize:12.0];
        _valueLabel.textColor = [UIColor p_textColor_default];
        [self addSubview:_valueLabel];
    }
    return self;
}


#pragma mark - Public

- (void)setKey:(NSString *)key {
    _key = nil;
    _key = key;
    
    _keyLabel.text = _key;
}


- (void)setValue:(NSString *)value {
    _value = nil;
    _value = value;
    
    _valueLabel.text = _value;
}


#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
    CGFloat keyWidth = 148.0;
    
    _keyLabel.frame = CGRectMake(0.0, 0.0, keyWidth, size.height);
    _valueLabel.frame = CGRectMake(keyWidth, 0.0, size.width - keyWidth, size.height);
}


@end
