//
//  IMRatingSlider.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "IMRatingSlider.h"

#define RGB_COLOR(r,g,b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]

#pragma mark IMRatingSliderMaskView

@interface IMRatingSliderMaskView : UIView {
    CGRect roundedRects[4];
}

@property (strong, nonatomic) UIColor *color;

@end


@implementation IMRatingSliderMaskView

#pragma mark Init

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}


#pragma mark UIView

- (void)drawRect:(CGRect)rect {
    CGFloat verticalPadding = 2.0;
    CGFloat width = (rect.size.width - verticalPadding * 3.0) / 4.0;
    CGRect frame = CGRectMake(0.0, 0.0, width, rect.size.height);
    
    for (NSInteger i = 0; i < 4; i ++) {
        roundedRects[i] = CGRectOffset(frame, (frame.size.width + verticalPadding) * i, 0.0);
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, _color.CGColor);
    
    CGContextAddRect(ctx, self.bounds);
    for (NSInteger i = 0; i < 4; i ++) {
        CGMutablePathRef roundRect = CGPathCreateRoundedRect(roundedRects[i], 2.0);
        CGContextAddPath(ctx, roundRect);
        CGPathRelease(roundRect);
    }
    CGContextEOFillPath(ctx);
}


#pragma mark Private

CGMutablePathRef CGPathCreateRoundedRect(CGRect rect, CGFloat cornerRadius) {
    CGMutablePathRef result = CGPathCreateMutable();
    CGPathMoveToPoint(result, nil, CGRectGetMinX(rect) + cornerRadius, (CGRectGetMinY(rect)));
    CGPathAddArc(result, nil, (CGRectGetMinX(rect) + cornerRadius), (CGRectGetMinY(rect) + cornerRadius), cornerRadius, M_PI * 1.5, M_PI * 1.0, YES); // topLeft
    CGPathAddArc(result, nil, (CGRectGetMinX(rect) + cornerRadius), (CGRectGetMaxY(rect) - cornerRadius), cornerRadius, M_PI * 1.0, M_PI * 0.5, YES); // bottomLeft
    CGPathAddArc(result, nil, (CGRectGetMaxX(rect) - cornerRadius), (CGRectGetMaxY(rect) - cornerRadius), cornerRadius, M_PI * 0.5, 0.0, YES); // bottomRight
    CGPathAddArc(result, nil, (CGRectGetMaxX(rect) - cornerRadius), (CGRectGetMinY(rect) + cornerRadius), cornerRadius, 0.0, M_PI * 1.5, YES); // topRight
    CGPathCloseSubpath(result);
    return result;
}


@end


#pragma mark - IMRatingSlider

@interface IMRatingSlider ()

@property (strong, nonatomic) UIView *progressBackgroundView;
@property (strong, nonatomic) UIView *progressView;
@property (strong, nonatomic) IMRatingSliderMaskView *progressMaskView;

@property (strong, nonatomic) UIImageView *ratingContainerImageView;
@property (strong, nonatomic) UIImageView *ratingImageView;
@property (strong, nonatomic) UILabel *ratingLabel;

@property (strong, nonatomic) UILabel *instructionsLabel;
@property (strong, nonatomic) UIImageView *thumbImageView;

@property (assign, nonatomic) BOOL isLayoutNeeded;

@end


@implementation IMRatingSlider

#pragma mark Init

- (instancetype)init {
    self = [super init];
    if (self) {
        // Defaults
        _ratingFont = [UIFont boldSystemFontOfSize:18.0];
        _instructionsFont = [UIFont boldSystemFontOfSize:10.0];
        
        _progressBackgroundView = [UIView new];
        _progressBackgroundView.backgroundColor = RGB_COLOR(242, 240, 237);
        [self addSubview:_progressBackgroundView];
        
        _progressView = [UIView new];
        [self addSubview:_progressView];
        
        _progressMaskView = [IMRatingSliderMaskView new];
        _progressMaskView.color = self.superview.backgroundColor;
        [self addSubview:_progressMaskView];
        
        _ratingContainerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"im_rate_slider_pop_up"]];
        _ratingContainerImageView.alpha = 0.0;
        [self addSubview:_ratingContainerImageView];
        
        _ratingImageView = [UIImageView new];
        _ratingImageView.contentMode = UIViewContentModeCenter;
        [_ratingContainerImageView addSubview:_ratingImageView];
        
        _ratingLabel = [UILabel new];
        _ratingLabel.font = _ratingFont;
        _ratingLabel.textColor = RGB_COLOR(100, 88, 77);
        [_ratingContainerImageView addSubview:_ratingLabel];
        
        _instructionsLabel = [UILabel new];
        _instructionsLabel.font = _instructionsFont;
        _instructionsLabel.text = @"Slide to rate".uppercaseString;
        _instructionsLabel.textAlignment = NSTextAlignmentCenter;
        _instructionsLabel.textColor = RGB_COLOR(203, 196, 188);
        [self addSubview:_instructionsLabel];
        
        _thumbImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"im_rate_slider_thumb"]];
        _thumbImageView.contentMode = UIViewContentModeCenter;
        _thumbImageView.userInteractionEnabled = YES;
        [_thumbImageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)]];
        [self addSubview:_thumbImageView];
        
        _isLayoutNeeded = YES;
    }
    return self;
}


#pragma mark Public

- (void)setInstructionsFont:(UIFont *)instructionsFont {
    _instructionsFont = nil;
    _instructionsFont = instructionsFont;
    
    _instructionsLabel.font = _instructionsFont;
}


- (void)setRating:(float)rating {
    [self setRating:rating animated:NO];
}


- (void)setRating:(float)rating animated:(BOOL)animated {
    CGPoint center = _thumbImageView.center;
    center.x = _progressBackgroundView.frame.origin.x;
    _thumbImageView.center = center;
    
    [self updateUIWithProgress:[self progressForRating:rating]];
    
    [UIView animateWithDuration:animated ? 0.2 : 0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        _ratingContainerImageView.alpha = 1.0;
        _instructionsLabel.alpha = 0.0;
    } completion:nil];
    
    [self slideToRating:rating animated:animated completion:nil];
}


- (void)setRatingFont:(UIFont *)ratingFont {
    _ratingFont = nil;
    _ratingFont = ratingFont;
    
    _ratingLabel.font = _ratingFont;
}


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_isLayoutNeeded) {
        return;
    }
    
    CGSize size = self.bounds.size;
    
    CGSize ratingSize = _ratingContainerImageView.image.size;
    CGFloat y = 0.0;
    
    _ratingContainerImageView.frame = CGRectMake(0.0, y, ratingSize.width, ratingSize.height);
    y += _ratingContainerImageView.frame.size.height + 12.0;
    
    CGRect ratingFrame = CGRectMake(2.0, 1.0, ratingSize.width - 2.0, ratingSize.height - 5.0);
    CGFloat x = ratingFrame.origin.x;
    _ratingImageView.frame = CGRectMake(x, ratingFrame.origin.y, 26.0, ratingFrame.size.height);
    x += _ratingImageView.frame.size.width;
    
    _ratingLabel.frame = CGRectMake(x, ratingFrame.origin.y, ratingFrame.size.width - x, ratingFrame.size.height);
    
    CGFloat progressVerticalMargin = 35.0;
    CGFloat progressWidth = size.width - progressVerticalMargin * 2.0;
    CGFloat progressHeight = 6.0;
    CGRect progressFrame = CGRectMake(progressVerticalMargin, y, progressWidth, progressHeight);
    _progressBackgroundView.frame = progressFrame;
    _progressView.frame = CGRectMake(progressFrame.origin.x, progressFrame.origin.y, 0.0, progressFrame.size.height);
    _progressMaskView.frame = progressFrame;
    y += progressFrame.size.height;
    
    _instructionsLabel.frame = CGRectMake(0.0, y, size.width, 35.0);
    
    _thumbImageView.frame = CGRectMake(0.0, 0.0, 70.0, 70.0);
    _thumbImageView.center = _progressBackgroundView.center;
    
    _isLayoutNeeded = NO;
}


#pragma mark Gestures

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut animations:^{
            _ratingContainerImageView.alpha = 1.0;
            _instructionsLabel.alpha = 0.0;
        } completion:nil];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self];
        CGPoint center = sender.view.center;
        center.x = sender.view.center.x + translation.x;
        
        if (center.x < [self minimumX]) {
            center.x = [self minimumX];
        } else if (center.x > [self maximumX]) {
            center.x = [self maximumX];
        }
        
        sender.view.center = center;
        [sender setTranslation:CGPointZero inView:self];
        
        CGRect progressFrame = _progressView.frame;
        progressFrame.size.width = center.x - [self minimumX];
        _progressView.frame = progressFrame;
        
        CGPoint ratingContainerCenter = _ratingContainerImageView.center;
        ratingContainerCenter.x = center.x;
        _ratingContainerImageView.center = ratingContainerCenter;
        
        CGFloat progress = _progressView.frame.size.width / _progressBackgroundView.frame.size.width;
        [self updateUIWithProgress:progress];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        float rating = _ratingLabel.text.floatValue;
        [self slideToRating:rating animated:YES completion:^{
            if ([_delegate respondsToSelector:@selector(ratingSlider:didSetRating:)]) {
                [_delegate ratingSlider:self didSetRating:rating];
            }
        }];
    }
}


#pragma mark Private

- (UIColor *)colorForProgress:(float)progress {
    if (progress >= 0.00 && progress < 0.25)        return RGB_COLOR(216, 92, 1);
    else if (progress >= 0.25 && progress < 0.50)   return RGB_COLOR(255, 175, 2);
    else if (progress >= 0.50 && progress < 0.75)   return RGB_COLOR(187, 194, 50);
    else                                            return RGB_COLOR(139, 163, 5);
}


- (NSString *)imageNameForProgress:(float)progress {
    if (progress >= 0.00 && progress < 0.25)        return @"im_rate_slider_smile_bad";
    else if (progress >= 0.25 && progress < 0.50)   return @"im_rate_slider_smile_average";
    else if (progress >= 0.50 && progress < 0.75)   return @"im_rate_slider_smile_good";
    else                                            return @"im_rate_slider_smile_great";
}


- (CGFloat)maximumX {
    return _progressBackgroundView.frame.origin.x + _progressBackgroundView.frame.size.width;
}


- (CGFloat)minimumX {
    return _progressBackgroundView.frame.origin.x;
}


- (void)slideToRating:(float)rating animated:(BOOL)animated completion:(void (^)())completion {
    _rating = rating;
    float progress = [self progressForRating:_rating];
    CGFloat centerX = [self minimumX] + roundf(progress * _progressBackgroundView.frame.size.width);
    
    [UIView animateWithDuration:animated ? 0.2 : 0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
        CGPoint thumbCenter = _thumbImageView.center;
        thumbCenter.x = centerX;
        _thumbImageView.center = thumbCenter;
        
        CGPoint ratingContaierCenter = _ratingContainerImageView.center;
        ratingContaierCenter.x = centerX;
        _ratingContainerImageView.center = ratingContaierCenter;
        
        CGRect progressFrame = _progressView.frame;
        progressFrame.size.width = centerX - [self minimumX];
        _progressView.frame = progressFrame;
    } completion:^(BOOL finished) {
        [self updateUIWithProgress:progress];
        if (completion) {
            completion();
        }
    }];
}


- (float)progressForRating:(float)rating {
    return (rating - 1.0) / (5.0 - 1.0);
}


- (float)ratingForProgress:(float)progress {
    if (progress >= 0.00 && progress < 0.07)        return 1.0;
    else if (progress >= 0.07 && progress < 0.19)   return 1.5;
    else if (progress >= 0.19 && progress < 0.31)   return 2.0;
    else if (progress >= 0.31 && progress < 0.44)   return 2.5;
    else if (progress >= 0.44 && progress < 0.56)   return 3.0;
    else if (progress >= 0.56 && progress < 0.69)   return 3.5;
    else if (progress >= 0.69 && progress < 0.81)   return 4.0;
    else if (progress >= 0.81 && progress < 0.93)   return 4.5;
    else                                            return 5.0;
}


- (void)updateUIWithProgress:(float)progress {
    _progressView.backgroundColor = [self colorForProgress:progress];
    _ratingImageView.image = [UIImage imageNamed:[self imageNameForProgress:progress]];
    _ratingLabel.text = [NSString stringWithFormat:@"%.1f", [self ratingForProgress:progress]];
}


@end
