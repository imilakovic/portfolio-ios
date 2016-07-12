//
//  UIColor+P.h
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB_COLOR(r,g,b)    [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]
#define RGBA_COLOR(r,g,b,a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]

@interface UIColor (P)

+ (UIColor *)p_backgroundColor_default;
+ (UIColor *)p_backgroundColor_shade1;
+ (UIColor *)p_backgroundColor_shade2;
+ (UIColor *)p_backgroundColor_shade3;
+ (UIColor *)p_backgroundColor_shade4;
+ (UIColor *)p_backgroundColor_shade5;
+ (UIColor *)p_backgroundColor_shade6;
+ (UIColor *)p_textColor_default;
+ (UIColor *)p_textColor_faded;

@end
