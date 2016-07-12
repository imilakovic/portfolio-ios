//
//  NSString+P.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "NSString+P.h"

@implementation NSString (P)

- (NSString *)p_formattedDateString {
    if (!self) {
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDate *date = [dateFormatter dateFromString:self];
    
    dateFormatter.dateFormat = @"MMM yyyy";
    return [dateFormatter stringFromDate:date];
}


@end
