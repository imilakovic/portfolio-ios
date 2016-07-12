//
//  PCrossfadingImageView.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "PCrossfadingImageView.h"

#import "UIView+IMFrame.h"

@interface PCrossfadingImageView ()

@property (strong, nonatomic) UIImageView *currentImageView;
@property (strong, nonatomic) UIImageView *nextImageView;
@property (strong, nonatomic) UIVisualEffectView *blurEffectView;
@property (strong, nonatomic) UIView *overlayView;

@end


@implementation PCrossfadingImageView

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        _nextImageView = [self imageView];
        [self addSubview:_nextImageView];
        
        _currentImageView = [self imageView];
        [self addSubview:_currentImageView];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [self addSubview:_blurEffectView];
        
        _overlayView = [UIView new];
        _overlayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        _overlayView.userInteractionEnabled = NO;
        [self addSubview:_overlayView];
        
        self.hasBlurEffect = YES;
        self.hasOverlay = YES;
        self.offset = 0.0;
    }
    return self;
}


#pragma mark - Public

- (void)setHasBlurEffect:(BOOL)hasBlurEffect {
    _hasBlurEffect = hasBlurEffect;
    
    _blurEffectView.hidden = !_hasBlurEffect;
}


- (void)setHasOverlay:(BOOL)hasOverlay {
    _hasOverlay = hasOverlay;
    
    _overlayView.hidden = !_hasOverlay;
}


- (void)setImageNames:(NSArray *)imageNames {
    _imageNames = nil;
    _imageNames = imageNames;
    
    self.offset = 0.0;
}


- (void)setOffset:(CGFloat)offset {
    _offset = offset;
    if (_offset < 0.0 || _offset > (_imageNames.count - 1) * self.width) {
        return;
    }
    
    NSInteger currentIndex = self.width > 0 ? (NSInteger)floorf(_offset / self.width) : 0;
    if (currentIndex >= 0 && currentIndex < _imageNames.count) {
        _currentImageView.image = [UIImage imageNamed:_imageNames[currentIndex]];
    }
    
    NSInteger nextIndex = currentIndex + 1;
    if (nextIndex >= 0 && nextIndex < _imageNames.count) {
        _nextImageView.image = [UIImage imageNamed:_imageNames[nextIndex]];
    }
    
    CGFloat currentAlpha = self.width > 0 ? (currentIndex + 1 - _offset / self.width) : 1.0;
    CGFloat nextAlpha = 1.0 - currentAlpha;
    
    _currentImageView.alpha = currentAlpha;
    _nextImageView.alpha = nextAlpha;
}


#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _nextImageView.frame = self.bounds;
    _currentImageView.frame = self.bounds;
    _blurEffectView.frame = self.bounds;
    _overlayView.frame = self.bounds;
}


#pragma mark - Private

- (UIImageView *)imageView {
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}


@end
