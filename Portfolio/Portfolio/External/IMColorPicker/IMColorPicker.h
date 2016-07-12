//
//  IMColorPicker.h
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark IMColorPicker

@protocol IMColorPickerDelegate;

@interface IMColorPicker : UIControl <UIScrollViewDelegate>

@property (weak, nonatomic) id<IMColorPickerDelegate> delegate;
@property (strong, nonatomic) NSString *selectedRGBColor;

@property (assign, nonatomic) CGFloat pageWidth;
@property (assign, nonatomic) CGFloat normalDiameter;   // Normal diameter for color dot
@property (assign, nonatomic) CGFloat selectedDiameter; // Selected diameter for color dot

- (instancetype)initWithFile:(NSString *)path;
- (void)setSelectedRGBColor:(NSString *)selectedRGBColor animated:(BOOL)animated;

@end


@protocol IMColorPickerDelegate <NSObject>

@optional
- (void)colorPicker:(IMColorPicker *)colorPicker didSelectColor:(NSString *)color;

@end


#pragma mark - NSString (IMColor)

@interface NSString (IMColor)

- (UIColor *)im_color;
- (BOOL)im_rgbColorIsEqualToRGBColor:(NSString *)rgbColor;

@end
