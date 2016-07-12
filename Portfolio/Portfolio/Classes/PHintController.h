//
//  PHintController.h
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HINT_KEY_APPS_SCREEN        @"kHintKeyAppsScreen"
#define HINT_KEY_EDUCATION_SCREEN   @"kHintKeyEducationScreen"
#define HINT_KEY_EXPERIENCE_SCREEN  @"kHintKeyExperienceScreen"

@interface PHintController : NSObject

// Singleton
+ (instancetype)shared;

// Public
- (void)hideHintWithKey:(NSString *)key;
- (void)showHintWithKey:(NSString *)key;

@end
