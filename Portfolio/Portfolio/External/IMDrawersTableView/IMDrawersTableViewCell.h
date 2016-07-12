//
//  IMDrawersTableViewCell.h
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IMDrawersTableViewCellDelegate;

@interface IMDrawersTableViewCell : UIView

@property (weak, nonatomic) id<IMDrawersTableViewCellDelegate> delegate;
@property (assign, nonatomic) CGFloat headerHeight;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *headerView;

@end


@protocol IMDrawersTableViewCellDelegate <NSObject>

- (void)cellHeaderTapped:(IMDrawersTableViewCell *)cell;

@end
