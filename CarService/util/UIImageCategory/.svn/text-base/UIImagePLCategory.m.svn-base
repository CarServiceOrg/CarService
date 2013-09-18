//
//  UIImagePLCategory.m
//  PhotoSola
//
//  Created by motu on 11-4-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIImagePLCategory.h"
#import "UIImage+Resize.h"
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>

@implementation UIImage (PLAdditions)

- (UIImage*)imageScaledToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*)imageFromMainBundleFile:(NSString*)aFileName {
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", bundlePath,aFileName]];
}

//截屏
+ (UIImage*)screenshot 
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) 
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

//图片拼接用
+(UIImage *)joinImageToSize:(CGSize)size topImage:(UIImage *)top tileImage:(UIImage *)tile bottomImage:(UIImage *)bottom{
    //等比例压缩
    int topHeight = (int)top.size.height * size.width/top.size.width;
    int tileHeight = (int)tile.size.height * size.width/tile.size.width;
    int bottomHeight = (int)bottom.size.height * size.width/bottom.size.width;
    
    
    int  cnt = (size.height - topHeight - bottomHeight + (tileHeight - 1)) / tileHeight;
    float height = topHeight + tileHeight * cnt + bottomHeight; 
    
    UIGraphicsBeginImageContext(CGSizeMake(size.width, height));
    int current = 0;
    
    [top drawInRect:CGRectMake(0, current, size.width, topHeight)];
    current += topHeight;
    
    for (int i = 0; i < cnt; i++) {
        [tile drawInRect:CGRectMake(0, current, size.width, tileHeight)];
        current += tileHeight;
    }
    
    [bottom drawInRect:CGRectMake(0, current, size.width, bottomHeight)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image imageScaledToSize:size];
}

+(BOOL)isWholeNumber:(float)num
{
    int inum = (int)num;
    if((num - (float)inum) > 0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

+(UIImage *)makeNineImageForSize:(CGSize)size LeftTop:(UIImage *)lt Top:(UIImage *)top RightTop:(UIImage *)rt Right:(UIImage *)right RightBottom:(UIImage *)rb Bottom:(UIImage *)bottom LeftBottom:(UIImage *)lb Left:(UIImage *)left Background:(UIImage *)background BackgroundColor:(UIColor *)backgroundColor BorderSize:(CGSize)borderSize
{
    return [UIImage makeNineImageForSize:size LeftTop:lt RightTop:rt LeftBottom:lb RightBottom:rb Top:top Bottom:bottom Left:left Right:right Background:background BackgroundColor:backgroundColor BorderSize:borderSize];
}

+(UIImage *)makeNineImageForSize:(CGSize)size LeftTop:(UIImage *)lt RightTop:(UIImage *)rt LeftBottom:(UIImage *)lb RightBottom:(UIImage *)rb Top:(UIImage *)top Bottom:(UIImage *)bottom Left:(UIImage *)left Right:(UIImage *)right Background:(UIImage *)background BackgroundColor:(UIColor *)backgroundColor BorderSize:(CGSize)borderSize
{
    if(lt == nil || rt == nil || lb == nil || rb == nil || top == nil || bottom == nil || left == nil || right == nil)
    {
        return nil;
    }
    if(background == nil && backgroundColor == nil)
    {
        return nil;
    }
    
    BOOL hasChange = NO;
    int numOfTop = 1;
    int numOfBottom = 1;
    int numOfLeft = 1;
    int numOfRight = 1;
    
    //resize corners    -----------------------------------------------------------
    if(lt.size.height != borderSize.height || lt.size.width != borderSize.width)
    {        
        lt = [lt imageScaledToSize:borderSize];           
    }
    if(rt.size.height != borderSize.height || rt.size.width != borderSize.width)
    {        
        rt = [rt imageScaledToSize:borderSize];             
    }
    if(lb.size.height != borderSize.height || lb.size.width != borderSize.width)
    {        
        lb = [lb imageScaledToSize:borderSize];          
    }
    if(rb.size.height != borderSize.height || rb.size.width != borderSize.width)
    {        
        rb = [rb imageScaledToSize:borderSize];             
    }
    //resize top        -----------------------------------------------------------
    if(top.size.height != borderSize.height)
    {
        float scaledValue = borderSize.height/top.size.height;
        int newWidth = top.size.width * scaledValue;
        //--计算全宽拉长比
        numOfTop = (size.width - borderSize.width*2) / newWidth;
        if(numOfTop == 0)numOfTop = 1;
        int excessiveWidth = size.width - borderSize.width*2 - (float)numOfTop * newWidth;
        float scaledValue2 = 1.0f + (float)excessiveWidth/newWidth/numOfTop;
        //--end
        float tmpWidth = newWidth*scaledValue2;
        int realWidth = (int)tmpWidth;
        if(![self isWholeNumber:tmpWidth])
        {
            realWidth = realWidth + 1;
        }
        top = [top imageScaledToSize:CGSizeMake(realWidth, borderSize.height)];
        hasChange = YES;
    }
    else
    {
        numOfTop = (size.width - borderSize.width*2) / top.size.width;
    }
    //resize bottom     -----------------------------------------------------------
    if(bottom.size.height != borderSize.height)
    {
        float scaledValue = borderSize.height/bottom.size.height;
        int newWidth = bottom.size.width * scaledValue;
        
        numOfBottom = (size.width - borderSize.width*2) / newWidth;
        if(numOfBottom == 0)numOfBottom = 1;
        int excessiveWidth = size.width - borderSize.width*2 - (float)numOfBottom * newWidth;
        float scaledValue2 = 1.0f + (float)excessiveWidth/newWidth/numOfBottom;
        float tmpWidth = newWidth*scaledValue2;
        int realWidth = (int)tmpWidth;
        if(![self isWholeNumber:tmpWidth])
        {
            realWidth = realWidth + 1;
        }
        bottom = [bottom imageScaledToSize:CGSizeMake(realWidth, borderSize.height)];
        hasChange = YES;
    }
    else
    {
        numOfBottom = (size.width - borderSize.width*2) / bottom.size.width;
    }
    //resize left       -----------------------------------------------------------
    if(left.size.width != borderSize.width)
    {
        float scaledValue = borderSize.width/left.size.width;
        int newHeight = left.size.height * scaledValue;
        
        numOfLeft = (size.height - borderSize.height*2) / newHeight;
        if(numOfLeft == 0)numOfLeft = 1;
        int excessiveHeight = size.height - borderSize.height*2 - (float)numOfLeft * newHeight;
        float scaledValue2 = 1.0f + (float)excessiveHeight/newHeight/numOfLeft;
        float tmpHeight = newHeight*scaledValue2;
        int realHeight = (int)tmpHeight;
        if(![self isWholeNumber:tmpHeight])
        {
            realHeight = realHeight + 1;
        }
        //left = [left imageScaledToSize:CGSizeMake(borderSize.width, newHeight*scaledValue2)];
        left = [left imageScaledToSize:CGSizeMake(borderSize.width, realHeight)];
        hasChange = YES;
    }
    else
    {
        numOfLeft = (size.height - borderSize.height*2) / left.size.height;
    }
    //resize right       -----------------------------------------------------------
    if(right.size.width != borderSize.width)
    {
        float scaledValue = borderSize.width/right.size.width;
        int newHeight = right.size.height * scaledValue;
        
        numOfRight = (size.height - borderSize.height*2) / newHeight;
        if(numOfRight == 0)numOfRight = 1;
        int excessiveHeight = size.height - borderSize.height*2 - (float)numOfRight * newHeight;
        float scaledValue2 = 1.0f + (float)excessiveHeight/newHeight/numOfLeft;
        float tmpHeight = newHeight*scaledValue2;
        int realHeight = (int)tmpHeight;
        if(![self isWholeNumber:tmpHeight])
        {
            realHeight = realHeight + 1;
        }
        right = [right imageScaledToSize:CGSizeMake(borderSize.width, realHeight)];
        hasChange = YES;
    }
    else
    {
        numOfRight = (size.height - borderSize.height*2) / right.size.height;
    }
    //end of resize       -----------------------
    
    if(hasChange && background != nil)
    {
        CGSize scaledSize = CGSizeMake(top.size.width, left.size.height);
        background = [background imageScaledToSize:scaledSize];
    }
    
    
    //draw top image
    UIGraphicsBeginImageContext(CGSizeMake(numOfTop*top.size.width, top.size.height));
    for(int i = 0;i < numOfTop;i++)
    {
        [top drawInRect:CGRectMake(i*top.size.width, 0, top.size.width, top.size.height)];
    }
    UIImage *topImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //draw bottom image
    UIGraphicsBeginImageContext(CGSizeMake(numOfBottom*bottom.size.width, bottom.size.height));
    for(int i = 0;i < numOfBottom;i++)
    {
        [bottom drawInRect:CGRectMake(i*bottom.size.width, 0, bottom.size.width, bottom.size.height)];
    }
    UIImage *bottomImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //draw left image
    UIGraphicsBeginImageContext(CGSizeMake(left.size.width, numOfLeft*left.size.height));
    for(int i = 0;i < numOfLeft;i++)
    {
        [left drawInRect:CGRectMake(0, i*left.size.height, left.size.width, left.size.height)];
    }
    UIImage *leftImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //draw right image
    UIGraphicsBeginImageContext(CGSizeMake(right.size.width, numOfRight*right.size.height));
    for(int i = 0;i < numOfRight;i++)
    {
        [right drawInRect:CGRectMake(0, i*right.size.height, right.size.width, right.size.height)];
    }
    UIImage *rightImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //draw background 
    UIImage *bgImage;
    if(background != nil)
    {
        UIGraphicsBeginImageContext(CGSizeMake(top.size.width*numOfTop, numOfLeft*left.size.height));
        for(int x = 0;x < numOfTop;x++)
        {
            for(int y = 0;y < numOfLeft;y++)
            {
                [background drawInRect:CGRectMake(x*background.size.width, y*background.size.height, background.size.width, background.size.height)];
            }
        }
        bgImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    //end of create image-------------------
    
    // after check,let's begin draw image~
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //draw background
    if(background != nil)
    {
        [bgImage drawInRect:CGRectMake(borderSize.width, borderSize.height, size.width - 2*borderSize.width, size.height - 2*borderSize.height)];
    }
    else
    {
        //draw background argb
        if(backgroundColor != nil)
        {
            CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
            CGContextAddRect(context, CGRectMake(borderSize.width, borderSize.height, size.width - 2*borderSize.width, size.height - 2*borderSize.height));
            CGContextFillPath(context);
        }
    }
    //draw left-top
    [lt drawInRect:CGRectMake(0, 0, lt.size.width, lt.size.height)];
    //draw right-top
    [rt drawInRect:CGRectMake(size.width - rt.size.width, 0, rt.size.width, rt.size.height)];
    //draw right-bottom
    [rb drawInRect:CGRectMake(size.width - rb.size.width, size.height - rb.size.height, rb.size.width, rb.size.height)];
    //draw left-bottom
    [lb drawInRect:CGRectMake(0, size.height - lb.size.height, lb.size.width, lb.size.height)];
    //draw top
    [topImage drawInRect:CGRectMake(borderSize.width, 0, size.width - 2*borderSize.width, borderSize.height)];
    //draw bottom
    [bottomImage drawInRect:CGRectMake(borderSize.width, size.height-borderSize.height, size.width - 2*borderSize.width, borderSize.height)];
    //draw left
    [leftImage drawInRect:CGRectMake(0, borderSize.height, borderSize.width, size.height-2*borderSize.height)];
    //draw right
    [rightImage drawInRect:CGRectMake(size.width-borderSize.width, borderSize.height, borderSize.width, size.height-2*borderSize.height)];
    //--------end draw
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage *)makeNineImageForSize:(CGSize)size Corner:(UIImage *)corner top:(UIImage *)top left:(UIImage *)left background:(UIImage *)background backgroundColor:(UIColor *)backgroundColor borderSize:(CGSize)borderSize
{
    //image elements mustn't nil 
    if(corner == nil || top == nil || left == nil)
    {
        return nil;
    }    
    //make sure that the (corner's width equels left's width && corner's height equels top's height)
    if(corner.size.width != left.size.width || corner.size.height != top.size.height)
    {
        return nil;
    }
    
    UIImage * tmp;
    BOOL hasChange = NO;
    int numOfLeft = 0;
    int numOfTop = 0;
    
    //resize corner
    if(corner.size.height != borderSize.height || corner.size.width != borderSize.width)
    {        
        tmp = [corner imageScaledToSize:borderSize];
        corner = tmp;
        tmp = nil;
        if(top.size.height != borderSize.height)
        {
            float scaledValue = borderSize.height/top.size.height;
            int newWidth = top.size.width * scaledValue;
            top = [top imageScaledToSize:CGSizeMake(newWidth, borderSize.height)];
            hasChange = YES;
        }
        
        if(left.size.width != borderSize.width)
        {
            float scaledValue = borderSize.width/left.size.width;
            int newHeight = left.size.height * scaledValue;
            left = [left imageScaledToSize:CGSizeMake(borderSize.width, newHeight)];
            hasChange = YES;
        }
    }
    //这一步可以优化 待处理
    //resize the left
    //if(size.width != borderSize.width)
    if(YES)
    {
        float scaledValue = borderSize.width / left.size.width;
        //int newHeight = left.size.height;// * scaledValue;
        
        numOfLeft = (size.height - borderSize.height*2) / left.size.height;
        if(numOfLeft == 0)numOfLeft = 1;
        int excessiveHeight = size.height - borderSize.height*2 - (float)numOfLeft * left.size.height;
        float scaledValue2 = 1.0f + (float)excessiveHeight/left.size.height/numOfLeft;
        
        if(scaledValue == scaledValue2 == 1.0f)
        {
            
        }
        else
        {
            int newHeight = left.size.height*scaledValue2;
            CGSize scaledSize = CGSizeMake(borderSize.width, newHeight);
            left = [left imageScaledToSize:scaledSize];
            hasChange = YES;
        }
    }
    //resize the top
    //if(size.height != borderSize.height)
    if(YES)
    {
        float scaledValue = borderSize.height / top.size.height;
        //float newWidth = top.size.width;// * scaledValue;
        
        numOfTop = (size.width - borderSize.width*2) / top.size.width;
        if(numOfTop == 0)numOfTop = 1;
        int excessiveWidth = size.width - borderSize.width*2 - (float)numOfTop * top.size.width;
        float scaledValue2 = 1.0f + (float)excessiveWidth/top.size.width/numOfTop;
        
        if(scaledValue == scaledValue2 == 1.0f)
        {
            
        }
        else
        {
            int newWidth = top.size.width * scaledValue2;
            CGSize scaledSize = CGSizeMake(newWidth, borderSize.height);
            top = [top imageScaledToSize:scaledSize];
            hasChange = YES;
        }
    }
    
    if(hasChange && background != nil)
    {
        CGSize scaledSize = CGSizeMake(top.size.width, left.size.height);
        background = [background imageScaledToSize:scaledSize];
    }
    
    //draw top image
    UIGraphicsBeginImageContext(CGSizeMake(numOfTop*top.size.width, top.size.height));
    for(int i = 0;i < numOfTop;i++)
    {
        //top
        [top drawInRect:CGRectMake(i*top.size.width, 0, top.size.width, top.size.height)];
    }
    UIImage *topImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //draw left image
    UIGraphicsBeginImageContext(CGSizeMake(left.size.width, numOfLeft*left.size.height));
    for(int i = 0;i < numOfLeft;i++)
    {
        [left drawInRect:CGRectMake(0, i*left.size.height, left.size.width, left.size.height)];
    }
    UIImage *leftImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //draw background 
    UIImage *bgImage;
    if(background != nil)
    {
        UIGraphicsBeginImageContext(CGSizeMake(top.size.width*numOfTop, numOfLeft*left.size.height));
        for(int x = 0;x < numOfTop;x++)
        {
            for(int y = 0;y < numOfLeft;y++)
            {
                [background drawInRect:CGRectMake(x*background.size.width, y*background.size.height, background.size.width, background.size.height)];
            }
        }
        bgImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // after check,let's begin draw image~
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //draw background
    if(background != nil)
    {
        [bgImage drawInRect:CGRectMake(borderSize.width, borderSize.height, size.width - 2*borderSize.width, size.height - 2*borderSize.height)];
    }
    else
    {
        //draw background argb
        if(backgroundColor != nil)
        {
            CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
            CGContextAddRect(context, CGRectMake(borderSize.width, borderSize.height, size.width - 2*borderSize.width, size.height - 2*borderSize.height));
            CGContextFillPath(context);
        }
    }
    //--------add draw image code there 
    //draw left-top
    [corner drawInRect:CGRectMake(0, 0, corner.size.width, corner.size.height)];
    //draw right-top
    tmp = [self flipLRImage:corner];
    [tmp drawInRect:CGRectMake(size.width - tmp.size.width, 0, tmp.size.width, tmp.size.height)];
    //draw right-bottom
    tmp = [self flipUDImage:tmp];
    [tmp drawInRect:CGRectMake(size.width - tmp.size.width, size.height - tmp.size.height, tmp.size.width, tmp.size.height)];
    //draw left-bottom
    tmp = [self flipUDImage:corner];
    [tmp drawInRect:CGRectMake(0, size.height - tmp.size.height, tmp.size.width, tmp.size.height)];
    
    //draw top and bottom
    tmp = [self flipUDImage:topImage];
    [topImage drawInRect:CGRectMake(borderSize.width, 0, size.width - 2*borderSize.width, borderSize.height)];
    [tmp drawInRect:CGRectMake(borderSize.width, size.height-borderSize.height, size.width - 2*borderSize.width, borderSize.height)];
    //draw left and right
    tmp = [self flipLRImage:leftImage];
    [leftImage drawInRect:CGRectMake(0, borderSize.height, borderSize.width, size.height-2*borderSize.height)];
    [tmp drawInRect:CGRectMake(size.width-borderSize.width, borderSize.height, borderSize.width, size.height-2*borderSize.height)];
    //--------end draw
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}

//default width & height
+(UIImage *)makeNineImageForSize:(CGSize)size Corner:(UIImage *)corner top:(UIImage *)top left:(UIImage *)left background:(UIImage *)background backgroundColor:(UIColor *)backgroundColor
{
    return [self makeNineImageForSize:size Corner:corner top:top left:left background:background backgroundColor:backgroundColor borderSize:corner.size];
}

+(UIImage *)rotateImage:(UIImage *)aImage
{
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = aImage.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI /2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI /2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            return aImage;
            break;
            //[NSException raise:NSInternalInconsistencyExceptionformat:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

-(NSData *)imageScaleToSize:(CGSize)size metaData:(NSDictionary *)dic{
    if (size.width == 0 || size.height == 0)
        return nil;
    NSData *jpeg;
    //    if (CGSizeEqualToSize(size, self.size)) {
    //        jpeg = [NSData dataWithData:UIImageJPEGRepresentation(self, 1.0)];
    //    }
    //    else
        UIImage *compress = [self imageScaledToConstrainSizeForStarFace:size];
        //jpeg = [NSData dataWithData:UIImageJPEGRepresentation(compress, 0.95)];
        jpeg = [NSData dataWithData:UIImageJPEGRepresentation(compress, 0.85)];
        if ([jpeg length] == 0)
        {
            jpeg = [NSData dataWithData:UIImagePNGRepresentation(compress)];
        }
        CustomLog(@"size:%d,%d,%d byte",CGImageGetWidth(compress.CGImage),CGImageGetHeight(compress.CGImage),[jpeg length]);
    
    //if no exif info contained,just return origin data
    if (dic == nil) {
        return jpeg;
    }
    
    NSMutableDictionary *metadata = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)jpeg, NULL);
    //CGImageSourceCopyPropertiesAtIndex(source, 0, NULL)
    //after imageScaledToConstrainSize be called,image orientation all set to 1
    [metadata setObject:[NSNumber numberWithInt:1] forKey:(NSString*)kCGImagePropertyOrientation];
    
    //change image width and height
    [metadata setObject:[NSNumber numberWithFloat:size.width] forKey:(NSString *)kCGImagePropertyPixelWidth];
    [metadata setObject:[NSNumber numberWithFloat:size.height] forKey:(NSString *)kCGImagePropertyPixelHeight];
    
    NSMutableDictionary *EXIFDictionary = [NSMutableDictionary dictionaryWithDictionary:[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary]];
    NSMutableDictionary *GPSDictionary = [NSMutableDictionary dictionaryWithDictionary:[metadata objectForKey:(NSString *)kCGImagePropertyGPSDictionary]];
    NSMutableDictionary *TIFFDictionary = [NSMutableDictionary dictionaryWithDictionary:[metadata objectForKey:(NSString *)kCGImagePropertyTIFFDictionary]];
    NSMutableDictionary *RAWDictionary = [NSMutableDictionary dictionaryWithDictionary:[metadata objectForKey:(NSString *)kCGImagePropertyRawDictionary]];
    NSMutableDictionary *JPEGDictionary = [NSMutableDictionary dictionaryWithDictionary:[metadata objectForKey:(NSString *)kCGImagePropertyJFIFDictionary]];
    NSMutableDictionary *GIFDictionary = [NSMutableDictionary dictionaryWithDictionary:[metadata objectForKey:(NSString *)kCGImagePropertyGIFDictionary]];
    
    if(!EXIFDictionary) {
        EXIFDictionary = [NSMutableDictionary dictionary];
    }
    
    [EXIFDictionary setObject:[NSNumber numberWithFloat:size.width] forKey:(NSString *)kCGImagePropertyExifPixelXDimension];
    [EXIFDictionary setObject:[NSNumber numberWithFloat:size.height] forKey:(NSString *)kCGImagePropertyExifPixelYDimension];
    
    
    if(!GPSDictionary) {
        GPSDictionary = [NSMutableDictionary dictionary];
    }
    
    if (!TIFFDictionary) {
        TIFFDictionary = [NSMutableDictionary dictionary];
    }
    
    if (!RAWDictionary) {
        RAWDictionary = [NSMutableDictionary dictionary];
    }
    
    if (!JPEGDictionary) {
        JPEGDictionary = [NSMutableDictionary dictionary];
    }
    
    if (!GIFDictionary) {
        GIFDictionary = [NSMutableDictionary dictionary];
    }
    
    [metadata setObject:EXIFDictionary forKey:(NSString *)kCGImagePropertyExifDictionary];
    [metadata setObject:GPSDictionary forKey:(NSString *)kCGImagePropertyGPSDictionary];
    [metadata setObject:TIFFDictionary forKey:(NSString *)kCGImagePropertyTIFFDictionary];
    [metadata setObject:RAWDictionary forKey:(NSString *)kCGImagePropertyRawDictionary];
    [metadata setObject:JPEGDictionary forKey:(NSString *)kCGImagePropertyJFIFDictionary];
    [metadata setObject:GIFDictionary forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    CFStringRef UTI = CGImageSourceGetType(source);
    
    NSMutableData *dest_data = [[NSMutableData alloc] init];
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((CFMutableDataRef)dest_data,UTI,1,NULL);
    
    //CGImageDestinationRef hello;
    
    CGImageDestinationAddImageFromSource(destination,source,0, (CFDictionaryRef) metadata);
    
    
    BOOL success = NO;
    success = CGImageDestinationFinalize(destination);
    
    if(!success) {
        [dest_data release];
        CFRelease(destination);
        CFRelease(source);
        return nil;
    }
    
    CFRelease(destination);
    CFRelease(source);
    
    return [dest_data autorelease];
}

//角度为90的整数倍
+(UIImage *)rotateImage:(UIImage *)image size:(CGSize)size angle:(int)angle{
    
    UIGraphicsBeginImageContext(size);
    CustomLog(@"%f %f -- %f %f ---- %f",image.size.width,image.size.height,image.size.width/image.size.height,image.size.height/image.size.width,size.width/size.height);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, size.width/2, size.height/2);
    CGContextRotateCTM(context, angle*M_PI/180.0);
    
    if (angle%180 == 0) {
        //偶数
        CGContextTranslateCTM(context, -size.width/2, -size.height/2);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    }else{
        //奇数
        CGContextTranslateCTM(context, -size.height/2, -size.width/2);
        [image drawInRect:CGRectMake(0, 0, size.height, size.width)];
    }
    
    CGContextRestoreGState(context);
    UIImage *rotateImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CustomLog(@"%f %f",rotateImage.size.width,rotateImage.size.height);
    return rotateImage;
}

//上下翻转
+(UIImage *)flipUDImage:(UIImage *)image{
    CGSize size = image.size;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -size.height);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    CGContextRestoreGState(context);
    
    UIImage *flipImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return flipImage;
}

+(UIImage *)flipLRImage:(UIImage *)image{
    CGSize size = image.size;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -size.width, 0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    CGContextRestoreGState(context);
    
    UIImage *flipImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return flipImage;  

}


-(UIImage*)imageScaledToConstrainSize:(CGSize)targetSize 
{
#define radians( degrees ) ( degrees * M_PI / 180 )
    int rawWidth = floorf(targetSize.width);
    CGImageRef imageRef = [self CGImage];
    int targetWidth  = CGImageGetWidth(imageRef);;
    int targetHeight = CGImageGetHeight(imageRef);;
    
    if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationDown ||
        self.imageOrientation == UIImageOrientationUpMirrored || self.imageOrientation == UIImageOrientationDownMirrored)
    {
        if (CGSizeEqualToSize(targetSize, CGSizeZero)) {
            targetWidth = CGImageGetWidth(imageRef);
            targetHeight = CGImageGetHeight(imageRef);
        }
        else if (rawWidth>=CGImageGetWidth(imageRef))
        {
            targetWidth = CGImageGetWidth(imageRef);
            targetHeight = CGImageGetHeight(imageRef);
        }
        else
        {
            targetWidth = rawWidth;
            targetHeight = CGImageGetHeight(imageRef)*rawWidth/CGImageGetWidth(imageRef);
        }
	}
    else
    {
        if (CGSizeEqualToSize(targetSize, CGSizeZero)) {
            targetWidth = CGImageGetHeight(imageRef);
            targetHeight = CGImageGetWidth(imageRef);
        }
        else if (rawWidth>=CGImageGetHeight(imageRef))
        {
            targetWidth = CGImageGetHeight(imageRef);
            targetHeight = CGImageGetWidth(imageRef);
        }
        else
        {
            targetWidth = rawWidth;
            targetHeight = CGImageGetWidth(imageRef)*rawWidth/CGImageGetHeight(imageRef);
        }
    }
	///
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedFirst|kCGBitmapByteOrder32Little;
    CGColorSpaceRef colorSpaceInfo =CGColorSpaceCreateDeviceRGB();;//CGImageGetColorSpace(imageRef);
	
    CGContextRef bitmap;
	
    if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationDown ||
        self.imageOrientation == UIImageOrientationUpMirrored || self.imageOrientation == UIImageOrientationDownMirrored) {
		
		//bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, 8/*CGImageGetBitsPerComponent(imageRef)*/, (4 * targetWidth), colorSpaceInfo, bitmapInfo);
        
	} else {
		// bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, 8/*CGImageGetBitsPerComponent(imageRef)*/, (4 * targetWidth), colorSpaceInfo, bitmapInfo);
        
    }   
    CGAffineTransform transform = [self transformForOrientation:CGSizeMake(targetWidth, targetHeight)];
	CGContextConcatCTM(bitmap, transform);
    /*
     if (sourceImage.imageOrientation == UIImageOrientationLeft) {
     CGContextRotateCTM (bitmap, radians(90));
     CGContextTranslateCTM (bitmap, 0, -targetWidth);
     
     } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
     CGContextRotateCTM (bitmap, radians(-90));
     CGContextTranslateCTM (bitmap, -targetHeight, 0);
     
     } else if (sourceImage.imageOrientation == UIImageOrientationUp )
     {}
     else if (sourceImage.imageOrientation == UIImageOrientationUpMirrored) 
     {
     CGContextScaleCTM(bitmap, -1, 1);
     CGContextTranslateCTM (bitmap, -targetWidth, 0);
     } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
     CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
     CGContextRotateCTM (bitmap, radians(-180.));
     }
     */
    if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationDown
        || self.imageOrientation == UIImageOrientationUpMirrored || self.imageOrientation == UIImageOrientationDownMirrored) {
		
        CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
	} else {
        CGContextDrawImage(bitmap, CGRectMake(0, 0, targetHeight, targetWidth), imageRef);
    } 
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    CGColorSpaceRelease(colorSpaceInfo);
	
    CGContextRelease(bitmap);
    CGImageRelease(ref);
	
    return [[newImage retain] autorelease]; 
}

-(UIImage*)imageScaledToConstrainSizeForStarFace:(CGSize)targetSize
{
#define radians( degrees ) ( degrees * M_PI / 180 )
    int rawWidth = floorf(targetSize.width);
    int rawHeight = floorf(targetSize.height);
    CGImageRef imageRef = [self CGImage];
    int targetWidth  = CGImageGetWidth(imageRef);;
    int targetHeight = CGImageGetHeight(imageRef);;
    if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationDown ||
        self.imageOrientation == UIImageOrientationUpMirrored || self.imageOrientation == UIImageOrientationDownMirrored)
    {
        if (CGSizeEqualToSize(targetSize, CGSizeZero)) {
            targetWidth = CGImageGetWidth(imageRef);
            targetHeight = CGImageGetHeight(imageRef);
        }
        else
        {
            int tempTargetWidth = targetWidth;
            int tempTargetHeight = targetHeight;
            if (rawWidth < CGImageGetWidth(imageRef))
            {
                tempTargetWidth = rawWidth;
                tempTargetHeight = CGImageGetHeight(imageRef)*rawWidth/CGImageGetWidth(imageRef);
            }
            
            if (rawHeight < tempTargetHeight)
            {
                int oldHeight = tempTargetHeight;
                tempTargetHeight = rawHeight;
                tempTargetWidth = tempTargetWidth * rawHeight /oldHeight;
            }
            targetWidth = tempTargetWidth;
            targetHeight = tempTargetHeight;
        }
        
	}
    else
    {
        if (CGSizeEqualToSize(targetSize, CGSizeZero)) {
            targetWidth = CGImageGetHeight(imageRef);
            targetHeight = CGImageGetWidth(imageRef);
        }
        else
        {
            int tempTargetWidth = CGImageGetHeight(imageRef);
            int tempTargetHeight = CGImageGetWidth(imageRef);
            
            if (rawWidth < tempTargetWidth)
            {
                tempTargetWidth = rawWidth;
                tempTargetHeight = CGImageGetWidth(imageRef)*rawWidth/CGImageGetHeight(imageRef);
            }
            
            if (rawHeight < tempTargetHeight)
            {
                int oldHeight = tempTargetHeight;
                tempTargetHeight = rawHeight;
                tempTargetWidth = (tempTargetWidth * rawHeight) / oldHeight;
            }
            targetWidth = tempTargetWidth;
            targetHeight = tempTargetHeight;
        }
        
    }
	///
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedFirst|kCGBitmapByteOrder32Little;
    CGColorSpaceRef colorSpaceInfo =CGColorSpaceCreateDeviceRGB();;//CGImageGetColorSpace(imageRef);
	
    CGContextRef bitmap;
	
    if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationDown ||
        self.imageOrientation == UIImageOrientationUpMirrored || self.imageOrientation == UIImageOrientationDownMirrored) {
		
		//bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, 8/*CGImageGetBitsPerComponent(imageRef)*/, (4 * targetWidth), colorSpaceInfo, bitmapInfo);
        
	} else {
		// bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, 8/*CGImageGetBitsPerComponent(imageRef)*/, (4 * targetWidth), colorSpaceInfo, bitmapInfo);
        
    }
    CGAffineTransform transform = [self transformForOrientation:CGSizeMake(targetWidth, targetHeight)];
	CGContextConcatCTM(bitmap, transform);
    /*
     if (sourceImage.imageOrientation == UIImageOrientationLeft) {
     CGContextRotateCTM (bitmap, radians(90));
     CGContextTranslateCTM (bitmap, 0, -targetWidth);
     
     } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
     CGContextRotateCTM (bitmap, radians(-90));
     CGContextTranslateCTM (bitmap, -targetHeight, 0);
     
     } else if (sourceImage.imageOrientation == UIImageOrientationUp )
     {}
     else if (sourceImage.imageOrientation == UIImageOrientationUpMirrored)
     {
     CGContextScaleCTM(bitmap, -1, 1);
     CGContextTranslateCTM (bitmap, -targetWidth, 0);
     } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
     CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
     CGContextRotateCTM (bitmap, radians(-180.));
     }
     */
    if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationDown
        || self.imageOrientation == UIImageOrientationUpMirrored || self.imageOrientation == UIImageOrientationDownMirrored) {
		
        CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
	} else {
        CGContextDrawImage(bitmap, CGRectMake(0, 0, targetHeight, targetWidth), imageRef);
    }
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    CGColorSpaceRelease(colorSpaceInfo);
	
    CGContextRelease(bitmap);
    CGImageRelease(ref);
	
    return [[newImage retain] autorelease];
}


+(UIImage *) imageShrunkedNamed:(NSString*) imagename
{
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString* path = [NSString stringWithFormat:@"%@/%@", bundlePath,imagename];
    NSData* file_data = [NSData dataWithContentsOfFile:path];
    Byte * buffer = (Byte*)[file_data bytes];
    for(int i=0;i<6;i++)
    {
        buffer[0+i*8]-=6;
        buffer[1+i*8]-=0;
        buffer[2+i*8]-=7;
        buffer[3+i*8]-=4;
        buffer[4+i*8]-=2;
    }
    
    return [UIImage imageWithData:file_data];
}

+(UIImage *) imageShrunkedWithPath:(NSString*) path
{
    NSData* file_data = [NSData dataWithContentsOfFile:path];
    if(nil == file_data)
        return nil;
    Byte * buffer = (Byte*)[file_data bytes];
    for(int i=0;i<6;i++)
    {
        buffer[0+i*8]-=6;
        buffer[1+i*8]-=0;
        buffer[2+i*8]-=7;
        buffer[3+i*8]-=4;
        buffer[4+i*8]-=2;
    }
    return [UIImage imageWithData:file_data];
}

+(NSData *) dataShrunked:(NSData*) rawdata
{
    Byte * buffer = (Byte*)[rawdata bytes];
    for(int i=0;i<6;i++)
    {
        buffer[0+i*8]+=6;
        buffer[1+i*8]+=0;
        buffer[2+i*8]+=7;
        buffer[3+i*8]+=4;
        buffer[4+i*8]+=2;
    }
    
    return rawdata;
}
+(UIImage*)imageScaledToConstrainSize:(CGSize)targetSize imageRef:(CGImageRef) imageRef orientation:(UIImageOrientation) imageOrientation;
{
#define radians( degrees ) ( degrees * M_PI / 180 )
    CGFloat rawWidth = floorf(targetSize.width);
    CGFloat targetWidth;
    CGFloat targetHeight;
	
    if (imageOrientation == UIImageOrientationUp || imageOrientation == UIImageOrientationDown ||
        imageOrientation == UIImageOrientationUpMirrored || imageOrientation == UIImageOrientationDownMirrored)
    {
        if (CGSizeEqualToSize(targetSize, CGSizeZero)) {
            targetWidth = CGImageGetWidth(imageRef);
            targetHeight = CGImageGetHeight(imageRef);
        }
        else if (rawWidth>=CGImageGetWidth(imageRef))
        {
            targetWidth = CGImageGetWidth(imageRef);
            targetHeight = CGImageGetHeight(imageRef);
        }
        else
        {
            targetWidth = rawWidth;
            targetHeight = CGImageGetHeight(imageRef)*rawWidth/CGImageGetWidth(imageRef);
        }
	}
    else
    {
        if (CGSizeEqualToSize(targetSize, CGSizeZero)) {
            targetWidth = CGImageGetHeight(imageRef);
            targetHeight = CGImageGetWidth(imageRef);
        }
        else if (rawWidth>=CGImageGetHeight(imageRef))
        {
            targetWidth = CGImageGetHeight(imageRef);
            targetHeight = CGImageGetWidth(imageRef);
        }
        else
        {
            targetWidth = rawWidth;
            targetHeight = CGImageGetWidth(imageRef)*rawWidth/CGImageGetHeight(imageRef);
        }
    }
	///
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedFirst|kCGBitmapByteOrder32Little;
    CGColorSpaceRef colorSpaceInfo =CGColorSpaceCreateDeviceRGB();;//CGImageGetColorSpace(imageRef);
	
    CGContextRef bitmap;
	
    if (imageOrientation == UIImageOrientationUp || imageOrientation == UIImageOrientationDown ||
        imageOrientation == UIImageOrientationUpMirrored || imageOrientation == UIImageOrientationDownMirrored) {
		
		//bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, 8/*CGImageGetBitsPerComponent(imageRef)*/, (4 * targetWidth), colorSpaceInfo, bitmapInfo);
        
	} else {
		// bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, 8/*CGImageGetBitsPerComponent(imageRef)*/, (4 * targetWidth), colorSpaceInfo, bitmapInfo);
        
    }
    CGAffineTransform transform= CGAffineTransformIdentity;
    switch (imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, targetWidth, targetHeight);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, targetWidth, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, targetHeight);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, targetWidth, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, targetHeight, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
            
    }
    
	CGContextConcatCTM(bitmap, transform);
    
    if (imageOrientation == UIImageOrientationUp || imageOrientation == UIImageOrientationDown
        || imageOrientation == UIImageOrientationUpMirrored || imageOrientation == UIImageOrientationDownMirrored) {
		
        CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
	} else {
        CGContextDrawImage(bitmap, CGRectMake(0, 0, targetHeight, targetWidth), imageRef);
    }
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    CGColorSpaceRelease(colorSpaceInfo);
	
    CGContextRelease(bitmap);
    CGImageRelease(ref);
	
    return [[newImage retain] autorelease];
}

- (UIImage *)getImageWithMask:(UIImage *)maskImage
{
    // Create a pixel buffer in an easy to use format
    CGImageRef imageRef = [self CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    UInt8 * m_PixelBuf = malloc(sizeof(UInt8) * height * width * 4);
    UInt8 * m_MaskBuf = malloc(sizeof(UInt8) * height * width * 4);
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(m_PixelBuf, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextRef maskContext = CGBitmapContextCreate(m_MaskBuf, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    CGContextDrawImage(maskContext, CGRectMake(0, 0, width, height), maskImage.CGImage);
    CGContextRelease(maskContext);
    
    //alter the alpha
    int length = height * width * 4;
    for (int i=0; i<length; i+=4)
    {
        if (m_MaskBuf[i+2] == 255)
            m_PixelBuf[i+3] =  255;
        else
            m_PixelBuf[i+3] = 0;
    }
    free(m_MaskBuf);
    
    //create a new image
    CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf, width, height,
                                             bitsPerComponent, bytesPerRow, colorSpace,
                                             kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGImageRef newImgRef = CGBitmapContextCreateImage(ctx);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(ctx);
    free(m_PixelBuf);

    UIImage *finalImage = [UIImage imageWithCGImage:newImgRef];
    CGImageRelease(newImgRef);
    
    return finalImage;
}

@end
