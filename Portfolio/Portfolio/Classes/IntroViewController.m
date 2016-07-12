//
//  IntroViewController.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "IntroViewController.h"

#import "PMenuController.h"
#import "UIColor+P.h"
#import "UIFont+P.h"
#import "UIView+IMFrame.h"

#define INTRO_FIRST_APPEARANCE_DONE_KEY @"kIntroFirstAppearanceDoneKey1.0"
#define MARGIN 40.0

@interface IntroViewController ()

@property (strong, nonatomic) NSArray *logoLabels;
@property (strong, nonatomic) UILabel *introLabel;
@property (strong, nonatomic) UIButton *startButton;

@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;
@property (copy, nonatomic) void (^introAnimationCompletionBlock)(void);

@end


@implementation IntroViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor p_backgroundColor_default];
    
    NSArray *logoSymbols = @[@"(", @"i", @"m", @")"];
    NSMutableArray *logoLabels = [NSMutableArray new];
    for (NSString *logoSymbol in logoSymbols) {
        UILabel *logoLabel = [UILabel new];
        logoLabel.font = [UIFont p_boldFontOfSize:100.0];
        logoLabel.text = logoSymbol;
        logoLabel.textColor = [UIColor p_textColor_default];
        [self.view addSubview:logoLabel];
        [logoLabels addObject:logoLabel];
    }
    self.logoLabels = logoLabels;
    
    _introLabel = [UILabel new];
    _introLabel.alpha = 0.0;
    _introLabel.font = [UIFont p_fontOfSize:14.0];
    _introLabel.numberOfLines = 0;
    _introLabel.text = [self introText];
    _introLabel.textAlignment = NSTextAlignmentCenter;
    _introLabel.textColor = [UIColor p_textColor_default];
    [self.view addSubview:_introLabel];
    
    _startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _startButton.backgroundColor = [UIColor p_backgroundColor_shade1];
    _startButton.titleLabel.font = [UIFont p_boldFontOfSize:14.0];
    [_startButton addTarget:self action:@selector(startButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_startButton setTitle:@"Get started!" forState:UIControlStateNormal];
    [_startButton setTitleColor:[UIColor p_textColor_default] forState:UIControlStateNormal];
    [self.view addSubview:_startButton];
    
    _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _dynamicAnimator.delegate = self;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(startAnimationSequence) withObject:nil afterDelay:0.5];
}


#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    
    CGSize logoSize = CGSizeMake(240.0, 117.0);
    CGFloat logoOriginX = roundf((size.width - logoSize.width) / 2.0);
    CGFloat logoOriginY = roundf((size.height - logoSize.height) / 2.0);
    CGFloat logoLabelWidth = roundf(logoSize.width / _logoLabels.count);
    
    [_logoLabels enumerateObjectsUsingBlock:^(UILabel *logoLabel, NSUInteger idx, BOOL *stop) {
        logoLabel.frame = CGRectMake(logoOriginX + logoLabelWidth * idx, logoOriginY, logoLabelWidth, logoSize.height);
    }];
    
    CGFloat contentWidth = size.width - MARGIN * 2.0;
    CGFloat startButtonHeight = 60.0;
    
    _introLabel.frame = CGRectMake(MARGIN, MARGIN, contentWidth, size.height - MARGIN * 3.0 - startButtonHeight);
    _startButton.frame = CGRectMake(MARGIN, -startButtonHeight, contentWidth, startButtonHeight);
}


#pragma mark - Button actions

- (void)startButtonTapped:(UIButton *)sender {
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.im_menuController toggleMenuView];
}


#pragma mark - Animation

- (void)animateIntroWithCompletion:(void (^)())completion {
    self.introAnimationCompletionBlock = completion;
    
    // Intro label alpha animation
    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _introLabel.alpha = 1.0;
    } completion:nil];
    
    // Gravity
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[_startButton]];
    [_dynamicAnimator addBehavior:gravityBehavior];
    
    // Collision
    CGSize size = self.view.bounds.size;
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_startButton]];
    [collisionBehavior addBoundaryWithIdentifier:@"startButtonBottom" fromPoint:CGPointMake(0.0, size.height - MARGIN) toPoint:CGPointMake(size.width, size.height - MARGIN)];
    [_dynamicAnimator addBehavior:collisionBehavior];
    
    // Start button behavior
    UIDynamicItemBehavior *startButtonBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[_startButton]];
    startButtonBehavior.elasticity = 0.4;
    [_dynamicAnimator addBehavior:startButtonBehavior];
}


- (void)animateLogoWithCompletion:(void (^)())completion {
    UILabel *label1 = _logoLabels[0];
    UILabel *label2 = _logoLabels[1];
    UILabel *label3 = _logoLabels[2];
    UILabel *label4 = _logoLabels[3];
    
    NSTimeInterval firstStepDuration = 0.5;
    NSTimeInterval secondStepDuration = 0.5;
    UIViewAnimationOptions firstStepOptions = UIViewAnimationOptionCurveEaseInOut;
    UIViewAnimationOptions secondStepOptions = UIViewAnimationOptionCurveEaseInOut;
    CGFloat offsetX = 10.0;
    CGFloat offsetY = 20.0;
    
    [UIView animateWithDuration:firstStepDuration delay:0.0 options:firstStepOptions animations:^{
        [label1 setX:label1.x + offsetX];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:secondStepDuration delay:0.0 options:secondStepOptions animations:^{
            label1.alpha = 0.0;
            [label1 setX:-label1.width];
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    }];
    
    [UIView animateWithDuration:firstStepDuration delay:0.0 options:firstStepOptions animations:^{
        [label2 setY:label2.y + offsetY];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:secondStepDuration delay:0.0 options:secondStepOptions animations:^{
            label2.alpha = 0.0;
            [label2 setY:-label2.height];
        } completion:nil];
    }];
    
    [UIView animateWithDuration:firstStepDuration delay:0.0 options:firstStepOptions animations:^{
        [label3 setY:label3.y - offsetY];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:secondStepDuration delay:0.0 options:secondStepOptions animations:^{
            label3.alpha = 0.0;
            [label3 setY:self.view.bounds.size.height];
        } completion:nil];
    }];
    
    [UIView animateWithDuration:firstStepDuration delay:0.0 options:firstStepOptions animations:^{
        [label4 setX:label4.x - offsetX];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:secondStepDuration delay:0.0 options:secondStepOptions animations:^{
            label4.alpha = 0.0;
            [label4 setX:self.view.bounds.size.width];
        } completion:nil];
    }];
}


- (void)startAnimationSequence {
    [self animateLogoWithCompletion:^{
        [self animateIntroWithCompletion:nil];
    }];
}


#pragma mark - Private

- (NSString *)introText {
    NSInteger hour = [[NSCalendar currentCalendar] component:NSCalendarUnitHour fromDate:[NSDate date]];
    NSString *timeOfTheDay = nil;
    if (hour >= 0 && hour < 12) {
        timeOfTheDay = @"morning";
    } else if (hour >= 12 && hour < 18) {
        timeOfTheDay = @"afternoon";
    } else {
        timeOfTheDay = @"evening";
    }
    NSString *greeting = [NSString stringWithFormat:@"Good %@!", timeOfTheDay];
    
    BOOL firstAppearanceDone = [[NSUserDefaults standardUserDefaults] boolForKey:INTRO_FIRST_APPEARANCE_DONE_KEY];
    if (!firstAppearanceDone) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:INTRO_FIRST_APPEARANCE_DONE_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *intro = @"Thank you very much for downloading my interactive portfolio!\n\nPlease tap the button below to get started.";
        return [NSString stringWithFormat:@"%@\n\n%@", greeting, intro];
    }
    
    return greeting;
}


#pragma mark - UIDynamicAnimatorDelegate

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    [_dynamicAnimator removeAllBehaviors];
    
    if (self.introAnimationCompletionBlock) {
        self.introAnimationCompletionBlock();
        self.introAnimationCompletionBlock = nil;
    }
}


@end
