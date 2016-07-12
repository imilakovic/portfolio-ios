//
//  PMath.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "PMath.h"

@implementation PMath

Float32 NewValueUsingRangeConversion(Float32 oldValue, Float32 oldMin, Float32 oldMax, Float32 newMin, Float32 newMax) {
    Float32 oldRange = (oldMax - oldMin);
    Float32 newRange = (newMax - newMin);
    return (((oldValue - oldMin) * newRange) / oldRange) + newMin;
};


@end
