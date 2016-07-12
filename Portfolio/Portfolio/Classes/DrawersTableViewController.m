//
//  DrawersTableViewController.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "DrawersTableViewController.h"

#import "IMDrawersTableView.h"
#import "PMath.h"

@interface DrawersTableViewController () <IMDrawersTableViewDataSource, IMDrawersTableViewDelegate>

@property (strong, nonatomic) IMDrawersTableView *tableView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;

@property (assign, nonatomic) CGFloat titleLabelOriginY;

@end


@implementation DrawersTableViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Drawers Table View";
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont p_boldFontOfSize:14.0];
    _titleLabel.text = @"Custom main header";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor p_textColor_default];
    
    _descriptionLabel = [UILabel new];
    _descriptionLabel.font = [UIFont p_fontOfSize:12.0];
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.text = @"Please feel free to explore:\n- tap the headers\n- scroll up or down";
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    _descriptionLabel.textColor = [UIColor p_textColor_default];
    
    _tableView = [IMDrawersTableView new];
    _tableView.cellHeaderHeight = 60.0;
    _tableView.contentInsetTop = 50.0;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _titleLabelOriginY = 80.0;
}


#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _tableView.frame = self.view.bounds;
    
    _titleLabel.frame = CGRectMake(0.0, _titleLabelOriginY, _tableView.headerView.width, _tableView.contentInsetTop);
    _descriptionLabel.frame = CGRectMake(20.0, _titleLabel.bottom, _tableView.headerView.width - 40.0, 80.0);
}


#pragma mark - IMDrawersTableViewDataSource

- (UIView *)headerViewForTableView:(IMDrawersTableView *)tableView {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor p_backgroundColor_shade2];
    
    [headerView addSubview:_titleLabel];
    [headerView addSubview:_descriptionLabel];
    
    return headerView;
}


- (NSInteger)numberOfCellsInTableView:(IMDrawersTableView *)tableView {
    return 3;
}


- (IMDrawersTableViewCell *)tableView:(IMDrawersTableView *)tableView cellAtIndex:(NSInteger)index {
    UILabel *headerLabel = [UILabel new];
    headerLabel.backgroundColor = self.view.backgroundColor;
    headerLabel.font = [UIFont p_boldFontOfSize:14.0];
    headerLabel.layer.borderColor = [UIColor p_backgroundColor_shade2].CGColor;
    headerLabel.layer.borderWidth = 0.5;
    headerLabel.text = [NSString stringWithFormat:@"Custom header %li", (long)index + 1];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = [UIColor p_textColor_default];
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.backgroundColor = [UIColor p_backgroundColor_shade2];
    contentLabel.font = [UIFont p_fontOfSize:12.0];
    contentLabel.text = [NSString stringWithFormat:@"Custom content %li", (long)index + 1];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.textColor = [UIColor p_textColor_default];
    
    IMDrawersTableViewCell *cell = [IMDrawersTableViewCell new];
    cell.headerView = headerLabel;
    cell.contentView = contentLabel;
    
    return cell;
}


#pragma mark - IMDrawersTableViewDelegate

- (void)tableView:(IMDrawersTableView *)tableView didScrollToOffsetY:(CGFloat)offsetY {
    CGFloat maxOffsetY = tableView.headerView.bounds.size.height - tableView.contentInsetTop;
    
    // Title label origin y
    CGFloat originY = offsetY <= maxOffsetY ? NewValueUsingRangeConversion(offsetY, 0.0, maxOffsetY, 0.0, _titleLabelOriginY) : _titleLabelOriginY;
    [_titleLabel setY:_titleLabelOriginY - originY];
    
    // Description label alpha
    CGFloat alpha = MAX(0.0, (maxOffsetY - offsetY) / maxOffsetY);
    _descriptionLabel.alpha = alpha;
}


@end
