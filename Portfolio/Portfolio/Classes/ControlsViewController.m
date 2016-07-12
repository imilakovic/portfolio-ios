//
//  ControlsViewController.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "ControlsViewController.h"

#import "AlertViewController.h"
#import "BlurDropdownViewController.h"
#import "ColorPickerViewController.h"
#import "ControlsTableViewCell.h"
#import "DrawersTableViewController.h"
#import "RatingSliderViewController.h"

@interface ControlsViewController ()

@property (strong, nonatomic) NSArray *controls;

@property (strong, nonatomic) UITableView *tableView;

@end


@implementation ControlsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _controls = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"controls" ofType:@"plist"]];
    
    _tableView = [UITableView new];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 80.0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}


#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _tableView.frame = self.view.bounds;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _controls.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    ControlsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ControlsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.control = _controls[indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *viewControllerString = _controls[indexPath.row][@"viewController"];
    Class viewControllerClass = NSClassFromString(viewControllerString);
    if (viewControllerClass) {
        [self.navigationController pushViewController:[NSClassFromString(viewControllerString) new] animated:YES];
    } else {
        NSLog(@"Invalid class name.");
    }
}


@end
