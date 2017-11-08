//
//  ContactViewController.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "ContactViewController.h"

#import "PAlertView.h"

@interface ContactViewController () <IMAlertViewDelegate>

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *firstAddressLabel;
@property (strong, nonatomic) UILabel *secondAddressLabel;
@property (strong, nonatomic) UIButton *emailButton;
@property (strong, nonatomic) UIButton *phoneButton;

@end


@implementation ContactViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont p_boldFontOfSize:14.0];
    _nameLabel.text = @"Igor Milakovic";
    _nameLabel.textColor = [UIColor p_textColor_default];
    [self.view addSubview:_nameLabel];
    
    _firstAddressLabel = [UILabel new];
    _firstAddressLabel.font = [UIFont p_fontOfSize:12.0];
    _firstAddressLabel.text = @"Apt 416 - 254 Gorge Rd East";
    _firstAddressLabel.textColor = [UIColor p_textColor_default];
    [self.view addSubview:_firstAddressLabel];
    
    _secondAddressLabel = [UILabel new];
    _secondAddressLabel.font = [UIFont p_fontOfSize:12.0];
    _secondAddressLabel.text = @"Victoria, BC, V9A 6W4, Canada";
    _secondAddressLabel.textColor = [UIColor p_textColor_default];
    [self.view addSubview:_secondAddressLabel];
    
    _emailButton = [self button];
    [_emailButton addTarget:self action:@selector(emailButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_emailButton setImage:[UIImage p_contact_email] forState:UIControlStateNormal];
    [_emailButton setTitle:@"igor.milakovic@gmail.com" forState:UIControlStateNormal];
    [self.view addSubview:_emailButton];
    
    _phoneButton = [self button];
    [_phoneButton addTarget:self action:@selector(phoneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_phoneButton setImage:[UIImage p_contact_phone] forState:UIControlStateNormal];
    [_phoneButton setTitle:@"+1 (778) 587-7985" forState:UIControlStateNormal];
    [self.view addSubview:_phoneButton];
}


#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    
    CGFloat margin = 20.0;
    CGFloat contentWidth = size.width - margin * 2.0;
    
    CGFloat y = margin;
    
    _nameLabel.frame = CGRectMake(margin, y, contentWidth, 20.0);
    y += _nameLabel.height + 8.0;
    
    _firstAddressLabel.frame = CGRectMake(margin, y, contentWidth, 20.0);
    y += _firstAddressLabel.height + 6.0;
    
    _secondAddressLabel.frame = CGRectMake(margin, y, contentWidth, 20.0);
    y += _secondAddressLabel.height + 40.0;
    
    _emailButton.frame = CGRectMake(margin, y, contentWidth, 44.0);
    y += _emailButton.height;
    
    _phoneButton.frame = CGRectMake(margin, y, contentWidth, 44.0);
}


#pragma mark - Button actions

- (void)emailButtonTapped:(UIButton *)sender {
    if (![MFMailComposeViewController canSendMail]) {
        return;
    }
    
    MFMailComposeViewController *mailComposeViewController = [MFMailComposeViewController new];
    mailComposeViewController.mailComposeDelegate = self;
    [mailComposeViewController setSubject:@"[Portfolio] Contact"];
    [mailComposeViewController setToRecipients:@[@"igor.milakovic@gmail.com"]];
    [self.navigationController presentViewController:mailComposeViewController animated:YES completion:nil];
}


- (void)phoneButtonTapped:(UIButton *)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[self phoneURL]]) {
        [[[PAlertView alloc] initWithTitleImage:[UIImage p_contact_phone] message:@"Make the call?" delegate:self cancelButtonTitle:@"No" confirmButtonTitle:@"Yes"] show];
    }
}


#pragma mark - Private

- (UIButton *)button {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, 12.0, 0.0, 0.0);
    button.titleLabel.font = [UIFont p_boldFontOfSize:14.0];
    [button setTitleColor:[UIColor p_textColor_default] forState:UIControlStateNormal];
    return button;
}


- (NSURL *)phoneURL {
    return [NSURL URLWithString:@"tel://+17785877985"];
}


#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:^{
        if (result == MFMailComposeResultSent) {
            [[[PAlertView alloc] initWithTitleImage:[UIImage p_contact_email]
                                            message:@"Thank you for reaching out to me! I will make sure to respond within 24 hours."
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                 confirmButtonTitle:nil] show];
        }
    }];
}


#pragma mark - IMAlertViewDelegate

- (void)im_alertView:(IMAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[self phoneURL]];
    }
}


@end
