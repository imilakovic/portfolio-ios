//
//  PIconFont.h
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PIconType) {
    PIconTypeArrowLeft3,
    PIconTypeBook4,
    PIconTypeCertificate,
    PIconTypeCheckmark,
    PIconTypeDragLeft,
    PIconTypeEqualizer,
    PIconTypeLibrary3,
    PIconTypeMail,
    PIconTypeMan,
    PIconTypeMenu7,
    PIconTypeMobile,
    PIconTypeOffice,
    PIconTypePhone2,
    PIconTypeWarning,
};

@interface PIconFont : NSObject

+ (NSString *)codeForIconType:(PIconType)iconType;

@end
