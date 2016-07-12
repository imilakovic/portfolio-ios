//
//  PCrossfadingImageView.h
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCrossfadingImageView : UIView

@property (strong, nonatomic) NSArray *imageNames;

@property (assign, nonatomic) BOOL hasBlurEffect;
@property (assign, nonatomic) BOOL hasOverlay;

@property (assign, nonatomic) CGFloat offset;

@end
