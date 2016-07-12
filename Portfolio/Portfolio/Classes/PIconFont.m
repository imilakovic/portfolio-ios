//
//  PIconFont.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "PIconFont.h"

@implementation PIconFont

+ (NSString *)codeForIconType:(PIconType)iconType {
    switch (iconType) {
        case PIconTypeArrowLeft3:   return @"\uedc5";
        case PIconTypeBook4:        return @"\ue993";
        case PIconTypeCertificate:  return @"\ue9eb";
        case PIconTypeCheckmark:    return @"\ued6f";
        case PIconTypeDragLeft:     return @"\ued33";
        case PIconTypeEqualizer:    return @"\ueb5b";
        case PIconTypeLibrary3:     return @"\ue998";
        case PIconTypeMail:         return @"\uea30";
        case PIconTypeMan:          return @"\uecfb";
        case PIconTypeMenu7:        return @"\uec71";
        case PIconTypeMobile:       return @"\uea78";
        case PIconTypeOffice:       return @"\ue909";
        case PIconTypePhone2:       return @"\uea1d";
        case PIconTypeWarning:      return @"\ued4f";
            
        default:                    return nil;
    }
}


@end
