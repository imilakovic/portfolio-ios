//
//  UIImage+PIconFont.m
//  Portfolio
//
//  Created by Igor Milakovic on 12/07/16.
//  Copyright © 2016 Foosh. All rights reserved.
//

#import "UIImage+PIconFont.h"

#import "UIColor+P.h"
#import "UIFont+P.h"

@implementation UIImage (PIconFont)

#pragma mark - Generic

+ (UIImage *)p_imageFromIconType:(PIconType)iconType
                        fontSize:(CGFloat)fontSize
                      canvasSize:(CGSize)canvasSize
                           color:(UIColor *)color
                     shadowColor:(UIColor *)shadowColor
              ellipseStrokeWidth:(CGFloat)ellipseStrokeWidth {
    // Main settings
    NSString *icon = [PIconFont codeForIconType:iconType];
    UIFont *font = [UIFont p_iconFontOfSize:fontSize];
    NSDictionary *attributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName: color};
    
    // Positioning
    CGSize iconSize = [icon sizeWithAttributes:attributes];
    CGSize imageSize = CGSizeEqualToSize(canvasSize, CGSizeZero) ? iconSize : canvasSize;
    CGPoint iconOrigin = CGPointMake(roundf((imageSize.width - iconSize.width) / 2.0), roundf((imageSize.height - iconSize.height) / 2.0));
    
    // Drawing
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw ellipse (optional)
    if (ellipseStrokeWidth > 0.0) {
        CGRect rect = CGRectMake(ellipseStrokeWidth / 2.0, ellipseStrokeWidth / 2.0, imageSize.width - ellipseStrokeWidth, imageSize.height - ellipseStrokeWidth);
        CGContextSetLineWidth(context, ellipseStrokeWidth);
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextStrokeEllipseInRect(context, rect);
    }
    
    // Draw shadow (optional)
    if (shadowColor) {
        CGContextSetShadowWithColor(context, CGSizeMake(1.0, 1.0), 5.0, shadowColor.CGColor);
    }
    
    // Draw icon
    [icon drawAtPoint:iconOrigin withAttributes:attributes];
    
    // Finalize image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Return final image in original rendering
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


#pragma mark - Specific - Contact

+ (UIImage *)p_contact_email {
    return [self p_imageFromIconType:PIconTypeMail fontSize:16.0 canvasSize:CGSizeZero color:[UIColor p_textColor_default] shadowColor:nil ellipseStrokeWidth:0.0];
}


+ (UIImage *)p_contact_phone {
    return [self p_imageFromIconType:PIconTypePhone2 fontSize:16.0 canvasSize:CGSizeZero color:[UIColor p_textColor_default] shadowColor:nil ellipseStrokeWidth:0.0];
}


#pragma mark - Specific - Education

+ (UIImage *)p_education_highSchool {
    return [self p_imageFromIconType:PIconTypeOffice fontSize:50.0 canvasSize:CGSizeZero color:[UIColor p_textColor_default] shadowColor:nil ellipseStrokeWidth:0.0];
}


+ (UIImage *)p_education_man {
    return [self p_imageFromIconType:PIconTypeMan fontSize:100.0 canvasSize:CGSizeZero color:[UIColor p_textColor_default] shadowColor:nil ellipseStrokeWidth:0.0];
}


+ (UIImage *)p_education_university {
    return [self p_imageFromIconType:PIconTypeLibrary3 fontSize:50.0 canvasSize:CGSizeZero color:[UIColor p_textColor_default] shadowColor:nil ellipseStrokeWidth:0.0];
}


#pragma mark - Specific - Icons

+ (UIImage *)p_icon_back {
    return [self p_imageFromIconType:PIconTypeArrowLeft3 fontSize:24.0 canvasSize:CGSizeZero color:[UIColor p_textColor_default] shadowColor:nil ellipseStrokeWidth:0.0];
}


+ (UIImage *)p_icon_menu {
    return [self p_imageFromIconType:PIconTypeMenu7 fontSize:24.0 canvasSize:CGSizeZero color:[UIColor p_textColor_default] shadowColor:nil ellipseStrokeWidth:0.0];
}


#pragma mark - Specific - Menu

+ (UIImage *)p_menu_apps_default {
    return [self p_imageFromIconType:PIconTypeMobile fontSize:24.0 canvasSize:CGSizeZero color:[UIColor p_textColor_faded] shadowColor:nil ellipseStrokeWidth:0.0];
}


+ (UIImage *)p_menu_apps_selected {
    return [self p_imageFromIconType:PIconTypeMobile fontSize:24.0 canvasSize:CGSizeZero color:[UIColor p_textColor_default] shadowColor:nil ellipseStrokeWidth:0.0];
}


+ (UIImage *)p_menu_contact_default {
    return [self p_imageFromIconType:PIconTypePhone2 fontSize:24.0 canvasSize:CGSizeZero color:[UIColor p_textColor_faded] shadowColor:nil ellipseStrokeWidth:0.0];
}


+ (UIImage *)p_menu_contact_selected {
    return [self p_imageFromIconType:PIconTypePhone2 fontSize:24.0 canvasSize:CGSizeZero color:[UIColor p_textColor_default] shadowColor:nil ellipseStrokeWidth:0.0];
}


+ (UIImage *)p_menu_controls_default {
    return [self p_imageFromIconType:PIconTypeEqualizer fontSize:24.0 canvasSize:CGSizeZero color:[UIColor p_textColor_faded] shadowColor:nil ellipseStrokeWidth:0.0];
}


+ (UIImage *)p_menu_controls_selected {
    return [self p_imageFromIconType:PIconTypeEqualizer fontSize:24.0 canvasSize:CGSizeZero color:[UIColor p_textColor_default] shadowColor:nil ellipseStrokeWidth:0.0];
}


+ (UIImage *)p_menu_education_default {
    return [self p_imageFromIconType:PIconTypeBook4 fontSize:24.0 canvasSize:CGSizeZero color:[UIColor p_textColor_faded] shadowColor:nil ellipseStrokeWidth:0.0];
}


+ (UIImage *)p_menu_education_selected {
    return [self p_imageFromIconType:PIconTypeBook4 fontSize:24.0 canvasSize:CGSizeZero color:[UIColor p_textColor_default] shadowColor:nil ellipseStrokeWidth:0.0];
}


+ (UIImage *)p_menu_experience_default {
    return [self p_imageFromIconType:PIconTypeOffice fontSize:24.0 canvasSize:CGSizeZero color:[UIColor p_textColor_faded] shadowColor:nil ellipseStrokeWidth:0.0];
}


+ (UIImage *)p_menu_experience_selected {
    return [self p_imageFromIconType:PIconTypeOffice fontSize:24.0 canvasSize:CGSizeZero color:[UIColor p_textColor_default] shadowColor:nil ellipseStrokeWidth:0.0];
}


+ (UIImage *)p_menu_language_default {
    return [self p_imageFromIconType:PIconTypeCertificate fontSize:24.0 canvasSize:CGSizeZero color:[UIColor p_textColor_faded] shadowColor:nil ellipseStrokeWidth:0.0];
}


+ (UIImage *)p_menu_language_selected {
    return [self p_imageFromIconType:PIconTypeCertificate fontSize:24.0 canvasSize:CGSizeZero color:[UIColor p_textColor_default] shadowColor:nil ellipseStrokeWidth:0.0];
}


@end
