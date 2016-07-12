//
//  UIImage+PIconFont.h
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PIconFont.h"

@interface UIImage (PIconFont)

// Generic
+ (UIImage *)p_imageFromIconType:(PIconType)iconType
                        fontSize:(CGFloat)fontSize
                      canvasSize:(CGSize)canvasSize
                           color:(UIColor *)color
                     shadowColor:(UIColor *)shadowColor
              ellipseStrokeWidth:(CGFloat)ellipseStrokeWidth;

// Specific - Contact
+ (UIImage *)p_contact_email;
+ (UIImage *)p_contact_phone;

// Specific - Education
+ (UIImage *)p_education_highSchool;
+ (UIImage *)p_education_man;
+ (UIImage *)p_education_university;

// Specific - Icons
+ (UIImage *)p_icon_back;
+ (UIImage *)p_icon_menu;

// Specific - Menu
+ (UIImage *)p_menu_apps_default;
+ (UIImage *)p_menu_apps_selected;
+ (UIImage *)p_menu_contact_default;
+ (UIImage *)p_menu_contact_selected;
+ (UIImage *)p_menu_controls_default;
+ (UIImage *)p_menu_controls_selected;
+ (UIImage *)p_menu_education_default;
+ (UIImage *)p_menu_education_selected;
+ (UIImage *)p_menu_experience_default;
+ (UIImage *)p_menu_experience_selected;
+ (UIImage *)p_menu_language_default;
+ (UIImage *)p_menu_language_selected;

@end
