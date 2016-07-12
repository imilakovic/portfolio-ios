//
//  IMRatingSlider.h
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IMRatingSliderDelegate;

@interface IMRatingSlider : UIControl

@property (weak, nonatomic) id<IMRatingSliderDelegate> delegate;
@property (assign, nonatomic) float rating;

@property (strong, nonatomic) UIFont *ratingFont;
@property (strong, nonatomic) UIFont *instructionsFont;

- (void)setRating:(float)rating animated:(BOOL)animated;

@end


@protocol IMRatingSliderDelegate <NSObject>

@optional
- (void)ratingSlider:(IMRatingSlider *)ratingSlider didSetRating:(float)rating;

@end
