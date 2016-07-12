//
//  PListLabel.h
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PListLabel : UIView

@property (strong, nonatomic) NSString *text;
@property (copy, nonatomic) UIFont *font;
@property (strong, nonatomic) UIColor *textColor;

@property (assign, nonatomic) CGFloat listSymbolWidth;

- (CGFloat)preferredHeightForWidth:(CGFloat)width;

@end
