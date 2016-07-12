//
//  UIView+IMFrame.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "UIView+IMFrame.h"

@implementation UIView (IMFrame)

- (CGFloat)top {
    return self.frame.origin.y;
}


- (CGFloat)left {
    return self.frame.origin.x;
}


- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


- (CGFloat)x {
    return self.frame.origin.x;
}


- (CGFloat)y {
    return self.frame.origin.y;
}


- (CGFloat)width {
    return self.frame.size.width;
}


- (CGFloat)height {
    return self.frame.size.height;
}


- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


@end
