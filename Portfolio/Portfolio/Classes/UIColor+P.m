//
//  UIColor+P.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "UIColor+P.h"

@implementation UIColor (P)

+ (UIColor *)p_backgroundColor_default {
    return RGB_COLOR(33, 37, 43);
}


+ (UIColor *)p_backgroundColor_shade1 {
    return RGB_COLOR(43, 47, 53);
}


+ (UIColor *)p_backgroundColor_shade2 {
    return RGB_COLOR(48, 52, 58);
}


+ (UIColor *)p_backgroundColor_shade3 {
    return RGB_COLOR(53, 57, 63);
}


+ (UIColor *)p_backgroundColor_shade4 {
    return RGB_COLOR(58, 62, 68);
}


+ (UIColor *)p_backgroundColor_shade5 {
    return RGB_COLOR(63, 67, 73);
}


+ (UIColor *)p_backgroundColor_shade6 {
    return RGB_COLOR(68, 72, 78);
}


+ (UIColor *)p_textColor_default {
    return RGB_COLOR(250, 250, 250);
}


+ (UIColor *)p_textColor_faded {
    return RGBA_COLOR(250, 250, 250, 0.5);
}


@end
