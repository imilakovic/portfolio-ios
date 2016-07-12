//
//  EducationInstitutionView.h
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EducationInstitutionView : UIView

@property (strong, nonatomic) NSDictionary *institution;
@property (assign, nonatomic) NSInteger institutionsCount;

@property (assign, nonatomic) CGFloat bottomMargin;

- (CGPoint)imageViewCenter;

@end
