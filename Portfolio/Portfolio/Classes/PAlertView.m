//
//  PAlertView.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "PAlertView.h"

#import "UIColor+P.h"
#import "UIFont+P.h"

@implementation PAlertView

#pragma mark - Init

- (instancetype)initWithTitleImage:(UIImage *)titleImage
                           message:(NSString *)message
                          delegate:(id<IMAlertViewDelegate>)delegate
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                confirmButtonTitle:(NSString *)confirmButtonTitle {
    self = [super initWithTitleImage:titleImage message:message delegate:delegate cancelButtonTitle:cancelButtonTitle confirmButtonTitle:confirmButtonTitle];
    if (self) {
        self.backgroundColor = [UIColor p_backgroundColor_shade1];
        
        self.messageLabel.font = [UIFont p_fontOfSize:12.0];
        self.messageLabel.textColor = [UIColor p_textColor_faded];
        
        self.cancelButton.backgroundColor = [UIColor p_backgroundColor_shade4];
        self.cancelButton.titleLabel.font = [UIFont p_fontOfSize:14.0];
        [self.cancelButton setTitleColor:[UIColor p_textColor_default] forState:UIControlStateNormal];
        
        self.confirmButton.backgroundColor = [UIColor p_backgroundColor_shade4];
        self.confirmButton.titleLabel.font = [UIFont p_boldFontOfSize:14.0];
        [self.confirmButton setTitleColor:[UIColor p_textColor_default] forState:UIControlStateNormal];
    }
    return self;
}


@end
