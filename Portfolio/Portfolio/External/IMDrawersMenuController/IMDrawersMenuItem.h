//
//  IMDrawersMenuItem.h
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMDrawersMenuItem : UIControl

@property (assign, nonatomic) CGFloat contentHeight;
@property (assign, nonatomic) CGFloat imageWidth;

@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *highlightedImage;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *highlightedTextColor;

@end
