//
//  ColorPickerViewController.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "ColorPickerViewController.h"

#import "IMColorPicker.h"

@interface ColorPickerViewController () <IMColorPickerDelegate>

@property (strong, nonatomic) NSArray *testColors;

@property (strong, nonatomic) IMColorPicker *colorPicker;
@property (strong, nonatomic) UILabel *currentColorLabel;
@property (strong, nonatomic) NSArray *colorButtons;

@end


@implementation ColorPickerViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Color Picker";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"color_picker_colors" ofType:@"plist"];
    
    // Pick random test colors
    NSMutableArray *colors = [NSMutableArray arrayWithContentsOfFile:path];
    NSMutableArray *testColors = [NSMutableArray new];
    for (NSInteger i = 0; i < 3; i++) {
        NSInteger index = arc4random() % colors.count;
        [testColors addObject:colors[index]];
        [colors removeObjectAtIndex:index];
    }
    self.testColors = testColors;
    
    _colorPicker = [[IMColorPicker alloc] initWithFile:path];
    _colorPicker.backgroundColor = [UIColor p_backgroundColor_shade1];
    _colorPicker.delegate = self;
    [self.view addSubview:_colorPicker];
    
    _currentColorLabel = [UILabel new];
    _currentColorLabel.font = [UIFont p_fontOfSize:12.0];
    _currentColorLabel.textAlignment = NSTextAlignmentCenter;
    _currentColorLabel.textColor = [UIColor p_textColor_default];
    [self.view addSubview:_currentColorLabel];
    
    NSMutableArray *colorButtons = [NSMutableArray new];
    [_testColors enumerateObjectsUsingBlock:^(NSString *color, NSUInteger idx, BOOL *stop) {
        UIButton *colorButton = [UIButton buttonWithType:UIButtonTypeSystem];
        colorButton.backgroundColor = color.im_color;
        colorButton.tag = idx;
        colorButton.titleLabel.font = [UIFont p_fontOfSize:12.0];
        [colorButton addTarget:self action:@selector(colorButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [colorButton setTitle:[NSString stringWithFormat:@"Select: %@", color] forState:UIControlStateNormal];
        [colorButton setTitleColor:[UIColor p_textColor_default] forState:UIControlStateNormal];
        [self.view addSubview:colorButton];
        [colorButtons addObject:colorButton];
    }];
    self.colorButtons = colorButtons;
    
    [self updateCurrentColorLabel];
}


#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    
    CGFloat margin = 20.0;
    CGFloat contentWidth = size.width - margin * 2.0;
    
    CGFloat y = margin;
    
    _colorPicker.frame = CGRectMake(0.0, y, size.width, 60.0);
    y += _colorPicker.frame.size.height + 20.0;
    
    _currentColorLabel.frame = CGRectMake(margin, y, contentWidth, 40.0);
    y += _currentColorLabel.frame.size.height + 20.0;
    
    for (UIButton *colorButton in _colorButtons) {
        colorButton.frame = CGRectMake(margin, y, contentWidth, 60.0);
        y += colorButton.frame.size.height + 20.0;
    }
}


#pragma mark - Button actions

- (void)colorButtonTapped:(UIButton *)sender {
    [_colorPicker setSelectedRGBColor:_testColors[sender.tag] animated:YES];
}


#pragma mark - Private

- (void)updateCurrentColorLabel {
    _currentColorLabel.text = [NSString stringWithFormat:@"Current color: %@", _colorPicker.selectedRGBColor];
}


#pragma mark - IMColorPickerDelegate

- (void)colorPicker:(IMColorPicker *)colorPicker didSelectColor:(NSString *)color {
    [self updateCurrentColorLabel];
}


@end
