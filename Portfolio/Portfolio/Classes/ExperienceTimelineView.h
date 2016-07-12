//
//  ExperienceTimelineView.h
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExperienceTimelineView : UIView

@property (strong, nonatomic) NSArray *companies;
@property (assign, nonatomic) float progress;
@property (assign, nonatomic) NSInteger selectedIndex;

@end
