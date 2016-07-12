//
//  IMAlertView.h
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IMAlertViewDelegate;

@interface IMAlertView : UIView

@property (weak, nonatomic) id<IMAlertViewDelegate> delegate;

@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat minimumHorizontalMargin;

@property (strong, nonatomic) UIImageView *titleImageView;
@property (strong, nonatomic) UIView *messageContainerView;
@property (strong, nonatomic) UIScrollView *messageScrollView;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *confirmButton;

- (instancetype)initWithTitleImage:(UIImage *)titleImage
                           message:(NSString *)message
                          delegate:(id<IMAlertViewDelegate>)delegate
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                confirmButtonTitle:(NSString *)confirmButtonTitle;

- (void)show;

@end


@protocol IMAlertViewDelegate <NSObject>

@optional
- (void)im_alertView:(IMAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)im_alertView:(IMAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex;

@end
