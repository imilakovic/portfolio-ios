//
//  IMAlertView.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "IMAlertView.h"

#define MARGIN                      15.0
#define MAXIMUM_IMAGE_HEIGHT        150.0
#define MESSAGE_VERTICAL_MARGIN     10.0
#define MESSAGE_HORIZONTAL_MARGIN   8.0
#define BUTTON_HEIGHT               50.0
#define BUTTON_SPACING              1.0

@interface IMAlertView ()

@property (weak, nonatomic) UIWindow *mainWindow;
@property (strong, nonatomic) UIWindow *alertWindow;

@end


@implementation IMAlertView

#pragma mark - Init

- (instancetype)initWithTitleImage:(UIImage *)titleImage
                           message:(NSString *)message
                          delegate:(id<IMAlertViewDelegate>)delegate
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                confirmButtonTitle:(NSString *)confirmButtonTitle {
    self = [super init];
    if (self) {
        _delegate = delegate;
        
        _titleImageView = [UIImageView new];
        _titleImageView.image = titleImage;
        [self addSubview:_titleImageView];
        
        _messageContainerView = [UIView new];
        [self addSubview:_messageContainerView];
        
        _messageScrollView = [UIScrollView new];
        _messageScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        [_messageContainerView addSubview:_messageScrollView];
        
        _messageLabel = [UILabel new];
        _messageLabel.font = [UIFont systemFontOfSize:14.0];
        _messageLabel.numberOfLines = 0;
        _messageLabel.text = message;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        [_messageScrollView addSubview:_messageLabel];
        
        _cancelButton = [self alertButton];
        [_cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:cancelButtonTitle ? cancelButtonTitle : @"Dismiss" forState:UIControlStateNormal];
        [self addSubview:_cancelButton];
        
        if (confirmButtonTitle) {
            _confirmButton = [self alertButton];
            _confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
            [_confirmButton addTarget:self action:@selector(confirmButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [_confirmButton setTitle:confirmButtonTitle forState:UIControlStateNormal];
            [self addSubview:_confirmButton];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleDeviceOrientationDidChangeNotification:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        
        // Defaults
        _width = 270.0;
        _minimumHorizontalMargin = 25.0;
        self.backgroundColor = [UIColor colorWithRed:55.0 / 255.0 green:58.0 / 255.0 blue:64.0 / 255.0 alpha:1.0];
        _cancelButton.backgroundColor = [UIColor colorWithRed:80.0 / 255.0 green:84.0 / 255.0 blue:90.0 / 255.0 alpha:1.0];
        _confirmButton.backgroundColor = [UIColor colorWithRed:80.0 / 255.0 green:84.0 / 255.0 blue:90.0 / 255.0 alpha:1.0];
    }
    return self;
}


#pragma mark - Public

- (void)show {
    _mainWindow = [[UIApplication sharedApplication] keyWindow];
    
    _alertWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _alertWindow.alpha = 0.0;
    _alertWindow.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    _alertWindow.windowLevel = UIWindowLevelStatusBar + 1.0;
    [_alertWindow makeKeyAndVisible];
    
    [_alertWindow addSubview:self];
    
    [self performInAnimation];
}


#pragma mark - Layout

- (CGFloat)imageHeight {
    return MIN(_titleImageView.image.size.height, MAXIMUM_IMAGE_HEIGHT);
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
    CGFloat contentWidth = size.width - MARGIN * 2.0;
    
    CGFloat y = MARGIN;
    
    // Title image
    _titleImageView.frame = CGRectMake(MARGIN, y, contentWidth, [self imageHeight]);
    y += _titleImageView.frame.size.height + MARGIN;
    
    BOOL largeImage = _titleImageView.image.size.width > _titleImageView.frame.size.width || _titleImageView.image.size.height > _titleImageView.frame.size.height;
    _titleImageView.contentMode = largeImage ? UIViewContentModeScaleAspectFit : UIViewContentModeCenter;
    
    // Message
    CGFloat messageHeight = MIN([self messageHeight], [self maximumMessageHeight]);
    _messageLabel.frame = CGRectMake(MESSAGE_VERTICAL_MARGIN, MESSAGE_HORIZONTAL_MARGIN, contentWidth - MESSAGE_VERTICAL_MARGIN * 2.0, [self messageHeight]);
    _messageContainerView.frame = CGRectMake(MARGIN, y, contentWidth, messageHeight + MESSAGE_HORIZONTAL_MARGIN * 2.0);
    _messageScrollView.frame = _messageContainerView.bounds;
    _messageScrollView.contentSize = CGSizeMake(_messageScrollView.frame.size.width, _messageLabel.frame.size.height + MESSAGE_HORIZONTAL_MARGIN * 2.0);
    _messageScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(MESSAGE_VERTICAL_MARGIN, 0.0, MESSAGE_VERTICAL_MARGIN, 0.0);
    
    if ([self messageHeight] > [self maximumMessageHeight]) {
        [self addMaskAboveScrollViewWithMargin:MESSAGE_VERTICAL_MARGIN * 2.0];
    }
    
    y += _messageContainerView.frame.size.height + MARGIN;
    
    // Buttons
    if (_confirmButton) {
        CGFloat buttonWidth = roundf(size.width / 2.0) - BUTTON_SPACING / 2.0;
        _cancelButton.frame = CGRectMake(0.0, y, buttonWidth, BUTTON_HEIGHT);
        _confirmButton.frame = CGRectMake(size.width - buttonWidth, y, buttonWidth, BUTTON_HEIGHT);
    } else {
        _cancelButton.frame = CGRectMake(0.0, y, size.width, BUTTON_HEIGHT);
    }
}


- (CGFloat)maximumMessageHeight {
    return _mainWindow.frame.size.height - MARGIN - [self imageHeight] - MARGIN - MESSAGE_HORIZONTAL_MARGIN * 2.0 - MARGIN - BUTTON_HEIGHT - _minimumHorizontalMargin * 2.0;
}



- (CGFloat)messageHeight {
    return ceilf([_messageLabel.text boundingRectWithSize:CGSizeMake(_width - MARGIN * 2.0 - MESSAGE_VERTICAL_MARGIN * 2.0, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName: _messageLabel.font}
                                                  context:nil].size.height);
}


- (CGFloat)totalHeight {
    CGFloat messageHeight = MIN([self messageHeight], [self maximumMessageHeight]);
    return MARGIN + [self imageHeight] + MARGIN + messageHeight + MESSAGE_HORIZONTAL_MARGIN * 2.0 + MARGIN + BUTTON_HEIGHT;
}


#pragma mark - Notifications

- (void)handleDeviceOrientationDidChangeNotification:(NSNotification *)notification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.4];
    
    self.transform = CGAffineTransformMakeRotation([self animationAngle]);
    
    [UIView commitAnimations];
}


#pragma mark - Button actions

- (void)cancelButtonTapped:(UIButton *)sender {
    [self performOutAnimationWithButtonIndex:0];
}


- (void)confirmButtonTapped:(UIButton *)sender {
    [self performOutAnimationWithButtonIndex:1];
}


#pragma mark - Animation

- (void)performInAnimation {
    self.frame = [self animationBeginFrame];
    self.transform = CGAffineTransformMakeRotation([self animationAngle] + 0.2);
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        _alertWindow.alpha = 1.0;
        
        self.transform = CGAffineTransformMakeRotation([self animationAngle]);
        self.frame = [self animationEndFrame];
    } completion:nil];
}


- (void)performOutAnimationWithButtonIndex:(NSInteger)buttonIndex {
    if ([_delegate respondsToSelector:@selector(im_alertView:willDismissWithButtonIndex:)]) {
        [_delegate im_alertView:self willDismissWithButtonIndex:buttonIndex];
    }
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.frame = [self animationEndFrame];
        self.transform = CGAffineTransformMakeRotation([self animationAngle] - 0.1);
    } completion:nil];
    
    [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _alertWindow.alpha = 0.0;
    } completion:^(BOOL finished) {
        _alertWindow = nil;
        [_mainWindow makeKeyWindow];
        
        if ([_delegate respondsToSelector:@selector(im_alertView:didDismissWithButtonIndex:)]) {
            [_delegate im_alertView:self didDismissWithButtonIndex:buttonIndex];
        }
    }];
}


#pragma mark - Animation helpers

- (CGFloat)animationAngle {
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:  return M_PI;
        case UIInterfaceOrientationLandscapeLeft:       return -M_PI_2;
        case UIInterfaceOrientationLandscapeRight:      return M_PI_2;
        default:                                        return 0.0;
    }
}


- (CGRect)animationBeginFrame {
    CGFloat height = [self totalHeight];
    CGFloat x = roundf((_alertWindow.bounds.size.width - _width) / 2.0);
    CGFloat y = roundf((_alertWindow.bounds.size.height - height) / 2.0);
    
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:  return CGRectMake(x - [UIScreen mainScreen].bounds.size.width, y, _width, height);
        case UIInterfaceOrientationLandscapeLeft:       return CGRectMake(x, y - [UIScreen mainScreen].bounds.size.height, _width, height);
        case UIInterfaceOrientationLandscapeRight:      return CGRectMake(x, y + [UIScreen mainScreen].bounds.size.height, _width, height);
        default:                                        return CGRectMake(x + [UIScreen mainScreen].bounds.size.width, y, _width, height);
    }
}


- (CGRect)animationEndFrame {
    CGRect frame = self.frame;
    
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:  frame.origin.x += [UIScreen mainScreen].bounds.size.width;  break;
        case UIInterfaceOrientationLandscapeLeft:       frame.origin.y += [UIScreen mainScreen].bounds.size.height; break;
        case UIInterfaceOrientationLandscapeRight:      frame.origin.y -= [UIScreen mainScreen].bounds.size.height; break;
        default:                                        frame.origin.x -= [UIScreen mainScreen].bounds.size.width;  break;
    }
    
    return frame;
}


#pragma mark - Private

- (void)addMaskAboveScrollViewWithMargin:(CGFloat)margin {
    CGFloat fadePercentage = margin / _messageScrollView.frame.size.height;
    
    NSObject *transparentColor = (NSObject *)[UIColor colorWithWhite:0.0 alpha:0.0].CGColor;
    NSObject *opaqueColor = (NSObject *)[UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[transparentColor, opaqueColor, opaqueColor, transparentColor];
    gradientLayer.frame = _messageScrollView.frame;
    gradientLayer.locations = @[@(0.0), @(fadePercentage), @(1.0 - fadePercentage), @(1.0)];
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = _messageScrollView.bounds;
    [maskLayer addSublayer:gradientLayer];
    
    _messageContainerView.layer.mask = maskLayer;
}


- (UIButton *)alertButton {
    UIButton *alertButton = [UIButton buttonWithType:UIButtonTypeSystem];
    alertButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [alertButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return alertButton;
}


#pragma mark - Memory management

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
