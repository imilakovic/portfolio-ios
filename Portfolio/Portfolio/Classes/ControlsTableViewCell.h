//
//  ControlsTableViewCell.h
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControlsTableViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *control;

@property (strong, nonatomic) UIImageView *appImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *projectLabel;

@end
