//
//  PHintController.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "PHintController.h"

#import "UIColor+P.h"
#import "UIImage+PIconFont.h"
#import "UIView+IMFrame.h"

@interface PHintController ()

@property (assign, nonatomic) BOOL hintVisible;

@property (strong, nonatomic) UIImageView *fingerImageView;

@end


@implementation PHintController

#pragma mark - Singleton

+ (instancetype)shared {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


#pragma mark - Public

- (void)hideHintWithKey:(NSString *)key {
    if (!_hintVisible) {
        return;
    }
    
    if (key) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [_fingerImageView.layer removeAllAnimations];
    [_fingerImageView removeFromSuperview];
    _fingerImageView = nil;
    
    _hintVisible = NO;
}


- (void)showHintWithKey:(NSString *)key {
    if (_hintVisible) {
        return;
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:key]) {
        return;
    }
    
    _hintVisible = YES;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    CGFloat fingerSide = 50.0;
    UIImage *image = [UIImage p_imageFromIconType:PIconTypeDragLeft fontSize:24.0 canvasSize:CGSizeZero color:[UIColor p_textColor_default] shadowColor:nil ellipseStrokeWidth:0.0];
    _fingerImageView = [[UIImageView alloc] initWithImage:image];
    _fingerImageView.contentMode = UIViewContentModeCenter;
    _fingerImageView.frame = CGRectMake(keyWindow.width - fingerSide, keyWindow.height - fingerSide, fingerSide, fingerSide);
    [keyWindow addSubview:_fingerImageView];
    
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat animations:^{
        _fingerImageView.alpha = 0.0;
        [_fingerImageView setX:_fingerImageView.x - 60.0];
    } completion:^(BOOL finished) {
        
    }];
}


@end
