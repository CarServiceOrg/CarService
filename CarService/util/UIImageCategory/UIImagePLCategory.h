//
//  UIImagePLCategory.h
//  PhotoSola
//
//  Created by motu on 11-4-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (PLAdditions)
- (UIImage*)imageScaledToSize:(CGSize)size;
- (UIImage *)getImageWithMask:(UIImage *)maskImage;
+ (UIImage*)imageFromMainBundleFile:(NSString*)aFileName;
+ (UIImage*)screenshot;


+(UIImage *)joinImageToSize:(CGSize)size topImage:(UIImage *)top tileImage:(UIImage *)tile bottomImage:(UIImage *)bottom;

+(UIImage *)rotateImage:(UIImage *)image size:(CGSize)size angle:(int)angle;

+(UIImage *)flipUDImage:(UIImage *)image;
+(UIImage *)flipLRImage:(UIImage *)image;
-(UIImage*)imageScaledToConstrainSize:(CGSize)targetSize;
-(UIImage*)imageScaledToConstrainSizeForStarFace:(CGSize)targetSize;

+(UIImage *)makeNineImageForSize:(CGSize)size Corner:(UIImage *)corner top:(UIImage *)top left:(UIImage *)left background:(UIImage *)background backgroundColor:(UIColor *)backgroundColor borderSize:(CGSize)borderSize;
+(UIImage *)makeNineImageForSize:(CGSize)size Corner:(UIImage *)corner top:(UIImage *)top left:(UIImage *)left background:(UIImage *)background backgroundColor:(UIColor *)backgroundColor;
+(UIImage *)makeNineImageForSize:(CGSize)size LeftTop:(UIImage *)lt RightTop:(UIImage *)rt LeftBottom:(UIImage *)lb RightBottom:(UIImage *)rb Top:(UIImage *)top Bottom:(UIImage *)bottom Left:(UIImage *)left Right:(UIImage *)right Background:(UIImage *)background BackgroundColor:(UIColor *)backgroundColor BorderSize:(CGSize)borderSize;
+(UIImage *)makeNineImageForSize:(CGSize)size LeftTop:(UIImage *)lt Top:(UIImage *)top RightTop:(UIImage *)rt Right:(UIImage *)right RightBottom:(UIImage *)rb Bottom:(UIImage *)bottom LeftBottom:(UIImage *)lb Left:(UIImage *)left Background:(UIImage *)background BackgroundColor:(UIColor *)backgroundColor BorderSize:(CGSize)borderSize;
+(UIImage *) imageShrunkedNamed:(NSString*) imagename;
+(NSData *) dataShrunked:(NSData*) rawdata;
+(UIImage *) imageShrunkedWithPath:(NSString*) path;
+(UIImage*)imageScaledToConstrainSize:(CGSize)targetSize imageRef:(CGImageRef) imageRef orientation:(UIImageOrientation) imageOrientation;
+(UIImage *)rotateImage:(UIImage *)aImage;
-(NSData *)imageScaleToSize:(CGSize)size metaData:(NSDictionary *)dic;
@end
