//
//  IMColorPicker.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "IMColorPicker.h"

#pragma mark NSString (IMColor)

@implementation NSString (IMColor)

- (UIColor *)im_color {
    NSArray *components = [self componentsSeparatedByString:@","];
    if (components.count != 3) {
        return [UIColor blackColor];
    }
    
    return [UIColor colorWithRed:[components[0] floatValue] / 255.0
                           green:[components[1] floatValue] / 255.0
                            blue:[components[2] floatValue] / 255.0
                           alpha:1.0];
}


- (BOOL)im_rgbColorIsEqualToRGBColor:(NSString *)rgbColor {
    NSArray *components1 = [self componentsSeparatedByString:@","];
    NSArray *components2 = [rgbColor componentsSeparatedByString:@","];
    if (components1.count != 3 || components2.count != 3) {
        return NO;
    }
    
    BOOL isRedComponentMatching =   [components1[0] integerValue] == [components2[0] integerValue];
    BOOL isGreenComponentMatching = [components1[1] integerValue] == [components2[1] integerValue];
    BOOL isBlueComponentMatching =  [components1[2] integerValue] == [components2[2] integerValue];
    
    return isRedComponentMatching && isGreenComponentMatching && isBlueComponentMatching;
}


@end


#pragma mark - IMPagingView

@interface IMPagingView : UIView

@property (strong, nonatomic) UIScrollView *scrollView;

@end


@implementation IMPagingView

#pragma mark Init

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        
        _scrollView = [UIScrollView new];
        _scrollView.clipsToBounds = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    return self;
}


#pragma mark UIView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint convertedPoint = [self convertPoint:point toView:_scrollView];
    for (UIView *view in _scrollView.subviews) {
        if (CGRectContainsPoint(view.frame, convertedPoint)) {
            return view;
        }
    }
    
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return _scrollView;
    }
    return view;
}


@end


#pragma mark - IMColorPickerItem

@protocol IMColorPickerItemDelegate;

@interface IMColorPickerItem : UIView

@property (weak, nonatomic) id<IMColorPickerItemDelegate> delegate;
@property (assign, nonatomic) CGFloat diameter;
@property (strong, nonatomic) NSString *rgbColor;

@property (strong, nonatomic) UIView *colorView;

- (instancetype)initWithRGBColor:(NSString *)rgbColor;

@end


@protocol IMColorPickerItemDelegate <NSObject>

- (void)itemTapped:(IMColorPickerItem *)item;

@end


@implementation IMColorPickerItem

#pragma mark Init

- (instancetype)initWithRGBColor:(NSString *)rgbColor {
    self = [super init];
    if (self) {
        _rgbColor = rgbColor;
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
        
        _colorView = [UIView new];
        _colorView.backgroundColor = [_rgbColor im_color];
        [self addSubview:_colorView];
    }
    return self;
}


#pragma mark Public

- (void)setDiameter:(CGFloat)diameter {
    _diameter = diameter;
    [self setNeedsLayout];
}


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
    _colorView.frame = CGRectMake(roundf((size.width - _diameter) / 2.0), roundf((size.height - _diameter) / 2.0), _diameter, _diameter);
    _colorView.layer.cornerRadius = _diameter / 2.0;
}


#pragma mark Gestures

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    [_delegate itemTapped:self];
}


@end


#pragma mark - IMColorPicker

@interface IMColorPicker () <IMColorPickerItemDelegate>

@property (strong, nonatomic, readonly) NSArray *colors;
@property (strong, nonatomic) NSArray *items; // of IMColorPickerItem
@property (readonly, nonatomic) BOOL animated; // Helper property to perform selection of IMColorPickerItem with animation if needed

@property (strong, nonatomic) IMPagingView *pagingView;

@end


@implementation IMColorPicker

#pragma mark Init

- (instancetype)initWithFile:(NSString *)path {
    self = [super init];
    if (self) {
        _colors = [NSArray arrayWithContentsOfFile:path];
        _pageWidth = 39.0;
        _normalDiameter = 20.0;
        _selectedDiameter = 35.0;
        
        _pagingView = [IMPagingView new];
        _pagingView.scrollView.delegate = self;
        [self addSubview:_pagingView];
        
        NSMutableArray *items = [NSMutableArray new];
        [_colors enumerateObjectsUsingBlock:^(NSString *rgbColor, NSUInteger idx, BOOL *stop) {
            IMColorPickerItem *item = [[IMColorPickerItem alloc] initWithRGBColor:rgbColor];
            item.delegate = self;
            item.diameter = idx == 0 ? _selectedDiameter : _normalDiameter;
            [_pagingView.scrollView addSubview:item];
            [items addObject:item];
        }];
        _items = items;
        
        [self selectDefaultRGBColor];
    }
    return self;
}


#pragma mark Public

- (void)setSelectedRGBColor:(NSString *)selectedRGBColor {
    [self setSelectedRGBColor:selectedRGBColor animated:NO];
}


- (void)setSelectedRGBColor:(NSString *)selectedRGBColor animated:(BOOL)animated {
    _selectedRGBColor = nil;
    _selectedRGBColor = selectedRGBColor;
    
    _animated = animated;
    
    [self selectRGBColor:_selectedRGBColor animated:_animated];
}


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
    _pagingView.frame = self.bounds;
    _pagingView.scrollView.contentSize = CGSizeMake(_items.count * _pageWidth, size.height);
    _pagingView.scrollView.frame = CGRectMake(roundf((self.bounds.size.width - _pageWidth) / 2.0), 0.0, _pageWidth, size.height);
    
    CGFloat itemsOriginY = 1.0;
    [_items enumerateObjectsUsingBlock:^(IMColorPickerItem *item, NSUInteger idx, BOOL *stop) {
        item.frame = CGRectMake(idx * _pageWidth, itemsOriginY, _pageWidth, size.height - itemsOriginY);
    }];
    
    if (_selectedRGBColor) {
        [self selectRGBColor:_selectedRGBColor animated:_animated];
    }
}


#pragma mark Private

- (void)selectDefaultRGBColor {
    if (_colors && _colors.count > 0) {
        self.selectedRGBColor = _colors[0];
    }
}


- (void)selectRGBColor:(NSString *)rgbColor animated:(BOOL)animated {
    IMColorPickerItem *selectedItem = nil;
    for (IMColorPickerItem *item in _items) {
        if ([item.rgbColor im_rgbColorIsEqualToRGBColor:rgbColor]) {
            selectedItem = item;
            break;
        }
    }
    
    if (selectedItem) {
        [_pagingView.scrollView scrollRectToVisible:selectedItem.frame animated:animated];
    } else {
        [self selectDefaultRGBColor];
    }
}


- (void)updateSelectedRGBColor {
    for (IMColorPickerItem *item in _items) {
        if (_pagingView.scrollView.contentOffset.x == item.frame.origin.x) {
            self.selectedRGBColor = item.rgbColor;
            break;
        }
    }
    
    if ([_delegate respondsToSelector:@selector(colorPicker:didSelectColor:)]) {
        [_delegate colorPicker:self didSelectColor:self.selectedRGBColor];
    }
}


#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateSelectedRGBColor];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self updateSelectedRGBColor];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentPageIndex = floor((scrollView.contentOffset.x - _pageWidth / 2) / _pageWidth) + 1;
    
    IMColorPickerItem *currentItem = nil;
    if (currentPageIndex >= 0 && currentPageIndex < _items.count) {
        currentItem = _items[currentPageIndex];
    }
    
    for (IMColorPickerItem *item in _items) {
        item.diameter = currentItem == item ? _selectedDiameter : _normalDiameter;
    }
}


#pragma mark IMColorPickerItemDelegate

- (void)itemTapped:(IMColorPickerItem *)item {
    [_pagingView.scrollView scrollRectToVisible:item.frame animated:YES];
}


@end
