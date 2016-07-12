//
//  BlurDropdownViewController.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "BlurDropdownViewController.h"

#import "IMBlurDropdown.h"

@interface BlurDropdownViewController ()

@property (strong, nonatomic) IMBlurDropdown *dropdown;
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UIImageView *imageView;

@property (assign, nonatomic) BOOL needsLayout;

@end


@implementation BlurDropdownViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Blur Dropdown";
    
    _textLabel = [UILabel new];
    _textLabel.font = [UIFont p_fontOfSize:12.0];
    _textLabel.numberOfLines = 0;
    _textLabel.text = @"This part of the screen will be blurred after the dropdown expands!";
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.textColor = [UIColor p_textColor_default];
    [self.view addSubview:_textLabel];
    
    UIImage *image = [UIImage p_imageFromIconType:PIconTypeCheckmark fontSize:100.0 canvasSize:CGSizeZero color:[UIColor p_textColor_default] shadowColor:nil ellipseStrokeWidth:0.0];
    _imageView = [[UIImageView alloc] initWithImage:image];
    _imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:_imageView];
    
    _dropdown = [[IMBlurDropdown alloc] initWithItems:@[@"Value 1", @"Value 2", @"Value 3"]];
    _dropdown.backgroundColor = [UIColor p_backgroundColor_shade2];
    _dropdown.itemBackgroundColor = [UIColor p_backgroundColor_shade3];
    _dropdown.itemFont = [UIFont p_fontOfSize:12.0];
    _dropdown.textColor = [UIColor p_textColor_default];
    _dropdown.titleFont = [UIFont p_boldFontOfSize:12.0];
    _dropdown.titleSeparatorColor = [UIColor p_textColor_faded];
    [self.view addSubview:_dropdown];
    
    _needsLayout = YES;
}


#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (!_needsLayout) {
        return;
    }
    
    CGSize size = self.view.bounds.size;
    
    CGFloat dropdownHeight = 50.0;
    
    CGFloat y = 0.0;
    
    _dropdown.frame = CGRectMake(0.0, y, size.width, dropdownHeight);
    _dropdown.closedHeight = dropdownHeight;
    _dropdown.openedHeight = size.height;
    [_dropdown performLayout];
    y += _dropdown.height + 60.0;
    
    _textLabel.frame = CGRectMake(20.0, y, size.width - 40.0, 100.0);
    y += _textLabel.height + 60.0;
    
    _imageView.frame = CGRectMake(0.0, y, size.width, _imageView.image.size.height);
    
    _needsLayout = NO;
}


@end
