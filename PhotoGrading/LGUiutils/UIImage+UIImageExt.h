//
//  UIImage+UIImageExt.h
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-10.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageExt)

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;

#pragma mark - 照相 -
/**
 *  照相
 */
- (UIImage *)cropImageWithBounds:(CGRect)bounds;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

@end
