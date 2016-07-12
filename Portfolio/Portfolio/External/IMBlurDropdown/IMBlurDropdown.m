//
//  IMBlurDropdown.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "IMBlurDropdown.h"

#pragma mark IMTriangeView

typedef NS_ENUM(NSInteger, IMTriangleDirection) {
    IMTriangleDirectionTop,
    IMTriangleDirectionLeft,
    IMTriangleDirectionBottom,
    IMTriangleDirectionRight
};

@interface IMTriangleView : UIView

@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) IMTriangleDirection direction;

@end


@implementation IMTriangleView

#pragma mark Init

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
    }
    return self;
}


#pragma mark Drawing

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    
    switch (_direction) {
        case IMTriangleDirectionTop: {
            CGContextMoveToPoint   (context, CGRectGetMinX(rect), CGRectGetMaxY(rect)); // Bottom left
            CGContextAddLineToPoint(context, CGRectGetMidX(rect), CGRectGetMinY(rect)); // Top mid
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect)); // Bottom right
        }
            break;
        case IMTriangleDirectionLeft: {
            CGContextMoveToPoint   (context, CGRectGetMaxX(rect), CGRectGetMinY(rect)); // Top right
            CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)); // Mid left
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect)); // Bottom right
        }
            break;
        case IMTriangleDirectionBottom: {
            CGContextMoveToPoint   (context, CGRectGetMinX(rect), CGRectGetMinY(rect)); // Top left
            CGContextAddLineToPoint(context, CGRectGetMidX(rect), CGRectGetMaxY(rect)); // Bottom mid
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect)); // Top right
        }
            break;
        case IMTriangleDirectionRight: {
            CGContextMoveToPoint   (context, CGRectGetMinX(rect), CGRectGetMinY(rect)); // Top left
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMidY(rect)); // Mid right
            CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect)); // Bottom left
        }
            break;
        default:
            break;
    }
    
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, _color.CGColor);
    CGContextFillPath(context);
}


@end


#pragma mark - IMBlurDropdown

@interface IMBlurDropdown ()

@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) IMTriangleView *triangleView;
@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) UIButton *toggleButton;

@property (strong, nonatomic) UIVisualEffectView *blurEffectView;
@property (strong, nonatomic) UITableView *tableView;

@end


@implementation IMBlurDropdown

#pragma mark Init

- (instancetype)initWithItems:(NSArray *)items {
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        _items = items;
        
        // Defaults
        _titleFont = [UIFont boldSystemFontOfSize:17.0];
        _itemFont = [UIFont systemFontOfSize:17.0];
        
        _itemBackgroundColor = [UIColor whiteColor];
        _textColor = [UIColor blackColor];
        _titleSeparatorColor = [UIColor grayColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _blurEffectView.alpha = 0.0;
        [self addSubview:_blurEffectView];
        
        _tableView = [UITableView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        _titleView = [UIView new];
        [self addSubview:_titleView];
        
        _titleLabel = [UILabel new];
        _titleLabel.font = _titleFont;
        _titleLabel.textColor = _textColor;
        [_titleView addSubview:_titleLabel];
        
        _triangleView = [IMTriangleView new];
        _triangleView.color = _textColor;
        _triangleView.direction = IMTriangleDirectionBottom;
        [_titleView addSubview:_triangleView];
        
        _separatorView = [UIView new];
        _separatorView.backgroundColor = _titleSeparatorColor;
        [_titleView addSubview:_separatorView];
        
        _toggleButton = [UIButton new];
        [_toggleButton addTarget:self action:@selector(handleTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_toggleButton addTarget:self action:@selector(handleTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [_toggleButton addTarget:self action:@selector(toggleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:_toggleButton];
        
        if (_items.count > 0) {
            self.selectedItem = _items.firstObject;
        }
    }
    return self;
}


#pragma mark Public

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _titleView.backgroundColor = backgroundColor;
}


- (void)setSelectedItem:(NSString *)selectedItem {
    _selectedItem = nil;
    _selectedItem = selectedItem;
    
    _titleLabel.text = _selectedItem;
}


- (void)setTextColor:(UIColor *)textColor {
    _textColor = nil;
    _textColor = textColor;
    
    _titleLabel.textColor = _textColor;
    _triangleView.color = _textColor;
}


- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = nil;
    _titleFont = titleFont;
    
    _titleLabel.font = _titleFont;
}


- (void)setTitleSeparatorColor:(UIColor *)titleSeparatorColor {
    _titleSeparatorColor = nil;
    _titleSeparatorColor = titleSeparatorColor;
    
    _separatorView.backgroundColor = _titleSeparatorColor;
}


#pragma mark Layout

- (void)performLayout {
    CGSize size = self.bounds.size;
    
    // Title
    _titleView.frame = CGRectMake(0.0, 0.0, size.width, _closedHeight);
    
    CGFloat titleVerticalMargin = 15.0;
    CGSize titleSize = _titleView.bounds.size;
    CGSize triangleSize = CGSizeMake(20.0, 10.0);
    CGFloat x = titleVerticalMargin;
    
    _titleLabel.frame = CGRectMake(x, 0.0, titleSize.width - x - triangleSize.width - titleVerticalMargin * 2.0, titleSize.height);
    x += _titleLabel.frame.size.width + titleVerticalMargin;
    
    _triangleView.frame = CGRectMake(x, floorf((titleSize.height - triangleSize.height) / 2.0), triangleSize.width, triangleSize.height);
    
    CGFloat separatorHeight = 0.5;
    _separatorView.frame = CGRectMake(0.0, titleSize.height - separatorHeight, titleSize.width, separatorHeight);
    
    _toggleButton.frame = _titleView.bounds;
    
    // Content
    CGFloat tableHeight = _openedHeight - _closedHeight;
    _blurEffectView.frame = CGRectMake(0.0, _closedHeight, size.width, _openedHeight - _closedHeight);
    _tableView.frame = CGRectMake(0.0, _closedHeight - tableHeight, size.width, tableHeight);
}


#pragma mark Button actions

- (void)closeButtonTapped:(UIButton *)sender {
    [self toggle];
}


- (void)handleTouchDown:(UIButton *)sender {
    _titleLabel.alpha = 0.3;
    _triangleView.alpha = 0.3;
}


- (void)handleTouchUp:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _titleLabel.alpha = 1.0;
        _triangleView.alpha = 1.0;
    }];
}


- (void)toggleButtonTapped:(UIButton *)sender {
    [self toggle];
}


#pragma mark Private

- (void)toggle {
    _toggleButton.selected = !_toggleButton.selected;
    
    BOOL opened = _toggleButton.selected;
    
    if (opened) {
        CGRect frame = self.frame;
        frame.size.height = _openedHeight;
        self.frame = frame;
    }
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _blurEffectView.alpha = opened;
        _triangleView.transform = CGAffineTransformMakeRotation(opened ? M_PI : 0.0);
        
        CGRect frame = _tableView.frame;
        frame.origin.y = opened ? _closedHeight : _closedHeight - _tableView.frame.size.height;
        _tableView.frame = frame;
    } completion:^(BOOL finished) {
        if (!opened) {
            CGRect frame = self.frame;
            frame.size.height = _closedHeight;
            self.frame = frame;
        }
    }];
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = _itemBackgroundColor;
        cell.textLabel.font = _itemFont;
        cell.textLabel.textColor = _textColor;
    }
    
    cell.textLabel.text = _items[indexPath.row];
    
    return cell;
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedItem = _items[indexPath.row];
    [self toggle];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return MAX(0.0, tableView.frame.size.height - _items.count * _closedHeight);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _closedHeight;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIButton *closeButton = [UIButton new];
    [closeButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return closeButton;
}


@end
