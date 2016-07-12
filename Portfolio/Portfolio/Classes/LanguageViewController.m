//
//  LanguageViewController.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "LanguageViewController.h"

#import "PKeyValueLabel.h"

@interface LanguageViewController ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) NSArray *keyValueLabels;

@property (assign, nonatomic) BOOL needsAnimation;

@end


@implementation LanguageViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleLabel = [UILabel new];
    _titleLabel.alpha = 0.0;
    _titleLabel.font = [UIFont p_boldFontOfSize:14.0];
    _titleLabel.text = @"IELTS - General Training";
    _titleLabel.textColor = [UIColor p_textColor_default];
    [self.view addSubview:_titleLabel];
    
    NSArray *parameters = @[@{@"Date": @"21/MAY/2016"},
                            @{@"Listening": @"7.0"},
                            @{@"Reading": @"8.0"},
                            @{@"Writing": @"7.0"},
                            @{@"Speaking": @"6.5"},
                            @{@"Overall Band Score": @"7.0"},
                            @{@"CEFR Level": @"C1"},
                            @{@"TRF Number": @"16HR000220MILI002G"}];
    
    NSMutableArray *keyValueLabels = [NSMutableArray new];
    for (NSDictionary *parameter in parameters) {
        PKeyValueLabel *keyValueLabel = [PKeyValueLabel new];
        keyValueLabel.alpha = 0.0;
        keyValueLabel.key = parameter.allKeys[0];
        keyValueLabel.value = parameter.allValues[0];
        [self.view addSubview:keyValueLabel];
        [keyValueLabels addObject:keyValueLabel];
    }
    self.keyValueLabels = keyValueLabels;
    
    _needsAnimation = YES;
}


#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    
    CGFloat margin = 20.0;
    CGFloat contentWidth = size.width - margin * 2.0;
    CGFloat labelHeight = 20.0;
    
    CGFloat y = margin;
    
    _titleLabel.frame = CGRectMake(margin, y, contentWidth, labelHeight);
    y += _titleLabel.height + 16.0;
    
    for (PKeyValueLabel *keyValueLabel in _keyValueLabels) {
        keyValueLabel.frame = CGRectMake(margin, y, contentWidth, labelHeight);
        y += keyValueLabel.height + 8.0;
    }
}


#pragma mark - Private

- (void)animateIfNeeded {
    if (!_needsAnimation) {
        return;
    }
    _needsAnimation = NO;
    
    CGFloat offsetX = 20.0;
    [self.view.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.alpha = 0.0;
        [view setX:view.x - offsetX];
        [UIView animateWithDuration:0.3 delay:0.1 * idx options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.alpha = 1.0;
            [view setX:view.x + offsetX];
        } completion:^(BOOL finished) {
            
        }];
    }];
}


- (void)menuControllerDidDismissMenuView:(IMDrawersMenuController *)menuController {
    [self animateIfNeeded];
}


@end
