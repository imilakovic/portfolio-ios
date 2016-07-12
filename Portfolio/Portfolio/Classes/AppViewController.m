//
//  AppViewController.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "AppViewController.h"

#import "PListLabel.h"
#import "UIColor+P.h"
#import "UIFont+P.h"
#import "UIView+IMFrame.h"

@interface AppViewController ()

@property (strong, nonatomic) NSDictionary *appDictionary;

@property (strong, nonatomic) UIButton *iconButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UILabel *notesLabel;
@property (strong, nonatomic) NSArray *noteLabels;

@end


@implementation AppViewController

#pragma mark - Init

- (instancetype)initWithAppDictionary:(NSDictionary *)appDictionary {
    self = [super init];
    if (self) {
        _appDictionary = appDictionary;
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _iconButton = [UIButton new];
    _iconButton.clipsToBounds = YES;
    [_iconButton addTarget:self action:@selector(iconButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_iconButton setImage:[UIImage imageNamed:_appDictionary[@"image"]] forState:UIControlStateNormal];
    [self.view addSubview:_iconButton];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont p_boldFontOfSize:14.0];
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = _appDictionary[@"title"];
    _titleLabel.textColor = [UIColor p_textColor_default];
    [self.view addSubview:_titleLabel];
    
    _descriptionLabel = [UILabel new];
    _descriptionLabel.font = [UIFont p_fontOfSize:12.0];
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.text = _appDictionary[@"description"];
    _descriptionLabel.textColor = [UIColor p_textColor_default];
    [self.view addSubview:_descriptionLabel];
    
    NSArray *notes = _appDictionary[@"notes"];
    if (notes) {
        _notesLabel = [UILabel new];
        _notesLabel.font = [UIFont p_boldFontOfSize:12.0];
        _notesLabel.text = notes.count == 1 ? @"Note:" : @"Notes:";
        _notesLabel.textColor = [UIColor p_textColor_default];
        [self.view addSubview:_notesLabel];
        
        NSMutableArray *noteLabels = [NSMutableArray new];
        for (NSString *note in notes) {
            PListLabel *noteLabel = [PListLabel new];
            noteLabel.text = note;
            [self.view addSubview:noteLabel];
            [noteLabels addObject:noteLabel];
        }
        self.noteLabels = noteLabels;
    }
}


#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    
    CGFloat margin = 20.0;
    CGFloat iconSide = 100.0;
    CGFloat contentWidth = size.width - margin * 2.0;
    
    CGFloat y = margin;
    
    _iconButton.frame = CGRectMake(margin, y, iconSide, iconSide);
    _iconButton.layer.cornerRadius = iconSide * 0.2;
    
    _titleLabel.frame = CGRectMake(_iconButton.right + margin, y, contentWidth - _iconButton.right, _iconButton.height);
    y += _titleLabel.height + 16.0;
    
    CGFloat descriptionHeight = ceilf([_descriptionLabel.text boundingRectWithSize:CGSizeMake(contentWidth, size.height - y - margin)
                                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                                        attributes:@{NSFontAttributeName: _descriptionLabel.font}
                                                                           context:nil].size.height);
    _descriptionLabel.frame = CGRectMake(margin, y, contentWidth, descriptionHeight);
    y += _descriptionLabel.height + 16.0;
    
    _notesLabel.frame = CGRectMake(margin, y, contentWidth, 20.0);
    y += _notesLabel.height;
    
    for (PListLabel *noteLabel in _noteLabels) {
        noteLabel.frame = CGRectMake(margin, y, contentWidth, [noteLabel preferredHeightForWidth:contentWidth]);
        y += noteLabel.height + 2.0;
    }
}


#pragma mark - Button actions

- (void)iconButtonTapped:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:_appDictionary[@"url"]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}


@end
