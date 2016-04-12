//
//  UIImageView+LBBlurredImage.m
//  LBBlurredImage
//
//  Created by Luca Bernardi on 11/11/12.
//  Copyright (c) 2012 Luca Bernardi. All rights reserved.
//

#import "UIImageView+LBBlurredImage.h"
#import "UIImage+ImageEffects.h"

CGFloat const kLBBlurredImageDefaultBlurRadius            = 20.0;
CGFloat const kLBBlurredImageDefaultSaturationDeltaFactor = 1.8;

@implementation UIImageView (LBBlurredImage)

#pragma mark - LBBlurredImage Additions

- (void)setImageToBlur:(UIImage *)image
       completionBlock:(LBBlurredImageCompletionBlock)completion
{
    [self setImageToBlur:image
              blurRadius:kLBBlurredImageDefaultBlurRadius
         completionBlock:completion];
}

- (void)setImageToBlur:(UIImage *)image
            blurRadius:(CGFloat)blurRadius
       completionBlock:(LBBlurredImageCompletionBlock) completion
{
    NSParameterAssert(image);
    NSParameterAssert(blurRadius >= 0);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *blurredImage = [image applyBlurWithRadius:blurRadius
                                                 tintColor:nil
                                     saturationDeltaFactor:kLBBlurredImageDefaultSaturationDeltaFactor
                                                 maskImage:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = blurredImage;

            if (completion) {
                completion();
            }
        });
    });
}

-(void)changeImageBright:(UIImage *)image Bright:(float)bright{
    CIImage *beginImage = [CIImage imageWithCGImage:(__bridge CGImageRef _Nonnull)(image.CIImage)];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:beginImage forKey:kCIInputImageKey];
    //  饱和度      0---2
    //[filter setValue:[NSNumber numberWithFloat:0.5] forKey:@"inputSaturation"];
    //  亮度  10   -1---1
    [filter setValue:[NSNumber numberWithFloat:bright] forKey:@"inputBrightness"];
    //  对比度 -11  0---4
    //[filter setValue:[NSNumber numberWithFloat:2] forKey:@"inputContrast"];
    // 得到过滤后的图片
    CIImage *outputImage = [filter outputImage];
    // 转换图片, 创建基于GPU的CIContext对象
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    // 释放C对象
    CGImageRelease(cgimg);
    self.image = newImage;
}

@end
