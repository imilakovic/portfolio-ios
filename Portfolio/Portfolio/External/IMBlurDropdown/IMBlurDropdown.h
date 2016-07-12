//
//  IMBlurDropdown.h
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMBlurDropdown : UIControl <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSString *selectedItem;

@property (assign, nonatomic) CGFloat closedHeight;
@property (assign, nonatomic) CGFloat openedHeight;

@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIFont *itemFont;

@property (strong, nonatomic) UIColor *itemBackgroundColor;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *titleSeparatorColor;

- (instancetype)initWithItems:(NSArray *)items;

- (void)performLayout;

@end
