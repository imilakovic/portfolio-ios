//
//  IMDrawersMenuView.h
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMDrawersMenuItem;

@protocol IMDrawersMenuViewDelegate;

@interface IMDrawersMenuView : UIView

@property (weak, nonatomic) id<IMDrawersMenuViewDelegate> delegate;
@property (copy, nonatomic) NSArray *items;
@property (weak, nonatomic) IMDrawersMenuItem *selectedItem;

- (void)performAnimationWithDuration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)())completion;
- (void)prepareForAnimation;

@end


@protocol IMDrawersMenuViewDelegate <NSObject>

- (void)menuView:(IMDrawersMenuView *)menuView didSelectItemAtIndex:(NSUInteger)index;

@end
