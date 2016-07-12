//
//  UIFont+P.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "UIFont+P.h"

@implementation UIFont (P)

+ (UIFont *)p_boldFontOfSize:(CGFloat)fontSize {
    return [self fontWithName:@"Menlo-Bold" size:fontSize];
}


+ (UIFont *)p_fontOfSize:(CGFloat)fontSize {
    return [self fontWithName:@"Menlo-Regular" size:fontSize];
}


+ (UIFont *)p_iconFontOfSize:(CGFloat)fontSize {
    return [self fontWithName:@"IcoMoon-Ultimate" size:fontSize];
}


@end
