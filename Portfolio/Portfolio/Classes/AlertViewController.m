//
//  AlertViewController.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "AlertViewController.h"

#import "PAlertView.h"

@interface AlertViewController () <IMAlertViewDelegate>

@property (strong, nonatomic) UITextField *messageTextField;
@property (strong, nonatomic) UITextField *cancelTextField;
@property (strong, nonatomic) UITextField *confirmTextField;
@property (strong, nonatomic) UIButton *showButton;
@property (strong, nonatomic) UIButton *predefinedAlertButton;
@property (strong, nonatomic) UILabel *statusLabel;

@end


@implementation AlertViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
    
    self.navigationItem.title = @"Alert View";
    
    _messageTextField = [self textField];
    _messageTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Message" attributes:@{NSForegroundColorAttributeName: [UIColor p_textColor_faded]}];
    [self.view addSubview:_messageTextField];
    
    _cancelTextField = [self textField];
    _cancelTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Cancel button" attributes:@{NSForegroundColorAttributeName: [UIColor p_textColor_faded]}];
    [self.view addSubview:_cancelTextField];
    
    _confirmTextField = [self textField];
    _confirmTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm button" attributes:@{NSForegroundColorAttributeName: [UIColor p_textColor_faded]}];
    [self.view addSubview:_confirmTextField];
    
    _showButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _showButton.backgroundColor = [UIColor p_backgroundColor_shade1];
    _showButton.titleLabel.font = [UIFont p_fontOfSize:12.0];
    [_showButton addTarget:self action:@selector(showButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_showButton setTitle:@"Show" forState:UIControlStateNormal];
    [_showButton setTitleColor:[UIColor p_textColor_default] forState:UIControlStateNormal];
    [self.view addSubview:_showButton];
    
    _predefinedAlertButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _predefinedAlertButton.backgroundColor = [UIColor p_backgroundColor_shade1];
    _predefinedAlertButton.titleLabel.font = [UIFont p_fontOfSize:12.0];
    [_predefinedAlertButton addTarget:self action:@selector(predefinedAlertButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_predefinedAlertButton setTitle:@"Show predefined alert" forState:UIControlStateNormal];
    [_predefinedAlertButton setTitleColor:[UIColor p_textColor_default] forState:UIControlStateNormal];
    [self.view addSubview:_predefinedAlertButton];
    
    _statusLabel = [UILabel new];
    _statusLabel.font = [UIFont p_fontOfSize:12.0];
    _statusLabel.text = @"Status: none";
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.textColor = [UIColor p_textColor_default];
    [self.view addSubview:_statusLabel];
}


#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    
    CGFloat margin = 20.0;
    CGFloat contentWidth = size.width - margin * 2.0;
    CGFloat textFieldHeight = 40.0;
    
    CGFloat y = margin;
    
    _messageTextField.frame = CGRectMake(margin, y, contentWidth, textFieldHeight);
    y += _messageTextField.frame.size.height + 20.0;
    
    CGFloat buttonTextFieldWidth = roundf((contentWidth - margin) / 2.0);
    _cancelTextField.frame = CGRectMake(margin, y, buttonTextFieldWidth, textFieldHeight);
    _confirmTextField.frame = CGRectMake(size.width - margin - buttonTextFieldWidth, y, buttonTextFieldWidth, textFieldHeight);
    y += textFieldHeight + 20.0;
    
    _showButton.frame = CGRectMake(margin, y, contentWidth, 60.0);
    y += _showButton.frame.size.height + 20.0;
    
    _predefinedAlertButton.frame = CGRectMake(margin, y, contentWidth, 60.0);
    y += _predefinedAlertButton.frame.size.height + 20.0;
    
    _statusLabel.frame = CGRectMake(margin, y, contentWidth, 40.0);
}


#pragma mark - Button actions

- (void)predefinedAlertButtonTapped:(UIButton *)sender {
    [self dismissKeyboard];
    
    _statusLabel.text = @"Status: none";
    
    [[[PAlertView alloc] initWithTitleImage:[UIImage p_imageFromIconType:PIconTypeBook4 fontSize:80.0 canvasSize:CGSizeZero color:[UIColor p_textColor_default] shadowColor:nil ellipseStrokeWidth:0.0]
                                    message:@"This is an example of the alert view with a very long message.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                         confirmButtonTitle:nil] show];
}


- (void)showButtonTapped:(UIButton *)sender {
    [self dismissKeyboard];
    
    _statusLabel.text = @"Status: none";
    
    UIImage *successImage = [UIImage p_imageFromIconType:PIconTypeCheckmark fontSize:40.0 canvasSize:CGSizeZero color:[UIColor p_textColor_default] shadowColor:nil ellipseStrokeWidth:0.0];
    UIImage *errorImage = [UIImage p_imageFromIconType:PIconTypeWarning fontSize:40.0 canvasSize:CGSizeZero color:[UIColor p_textColor_default] shadowColor:nil ellipseStrokeWidth:0.0];
    
    NSString *message = _messageTextField.text.length > 0 ? _messageTextField.text : nil;
    NSString *cancelTitle = _cancelTextField.text.length > 0 ? _cancelTextField.text : nil;
    NSString *confirmTitle = _confirmTextField.text.length > 0 ? _confirmTextField.text : nil;
    UIImage *titleImage = message ? successImage : errorImage;
    id<IMAlertViewDelegate> delegate = message && cancelTitle && confirmTitle > 0 ? self : nil;
    
    if (!message) {
        message = @"Please enter the alert message.";
        cancelTitle = nil;
        confirmTitle = nil;
    }
    
    [[[PAlertView alloc] initWithTitleImage:titleImage message:message delegate:delegate cancelButtonTitle:cancelTitle confirmButtonTitle:confirmTitle] show];
}


#pragma mark - Gestures

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    [self dismissKeyboard];
}


#pragma mark - Private

- (void)dismissKeyboard {
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
    }
}


- (UITextField *)textField {
    UITextField *textField = [UITextField new];
    textField.backgroundColor = [UIColor p_backgroundColor_shade1];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    textField.font = [UIFont p_fontOfSize:12.0];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.textColor = [UIColor p_textColor_default];
    textField.tintColor = [UIColor p_textColor_faded];
    return textField;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - IMAlertViewDelegate

- (void)im_alertView:(IMAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    _statusLabel.text = buttonIndex == 0 ? @"Status: cancelled" : @"Status: confirmed";
}


@end
