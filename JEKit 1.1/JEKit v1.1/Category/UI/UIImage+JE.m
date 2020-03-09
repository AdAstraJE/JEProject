
#import "UIImage+JE.h"
#import <objc/runtime.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import <Photos/Photos.h>

@implementation UIImage (JE)

+ (UIImage *)je_capture:(UIView *)view size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, view.opaque, 3);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

+ (UIImage *)je_clr:(UIColor *)color size:(CGSize)size{
    if (color == nil) {color = [UIColor clearColor];}
    CGRect rect=(CGRect){{0.0f,0.0f},size};
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage * (^)(UIColor *c))clr{return ^id (UIColor *c){return [UIImage je_clr:c size:CGSizeMake(1, 1)];};}

- (UIImage * (^)(UIColor *c))clr{
    return ^id (UIColor *c){
        return [self je_clr:c];
    };
}

- (UIImage * (^)(CGFloat a))alpha{
    return ^id (CGFloat a){
        return [self je_alpha:a];
    };
}

- (UIImage *)je_clr:(UIColor *)color{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)je_alpha:(CGFloat)alpha{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage * (^)(CGRect rect))clip{
    return ^id (CGRect rect){
        CGImageRef sourceImageRef = [self CGImage];
        CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake(CGRectGetMinX(rect)*self.scale, CGRectGetMinY(rect)*self.scale, CGRectGetWidth(rect)*self.scale, CGRectGetHeight(rect)*self.scale));
        UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:self.scale orientation:(UIImageOrientationUp)];
        CGImageRelease(newImageRef);
        return newImage;
    };
}

- (void)exportIcon{
    NSString *direct = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"AppIcon %@",direct);
    
    NSArray <NSNumber *> *px = @[@(20),@(29),@(40),@(60)];
    [UIImagePNGRepresentation([self je_sizeTo:CGSizeMake(1024, 1024)]) writeToFile:[direct stringByAppendingPathComponent:@"AppIcon-1024.png"] atomically:YES];
    
    for (NSNumber *obj in px) {
        [UIImagePNGRepresentation([self je_sizeTo:CGSizeMake(obj.integerValue*2, obj.integerValue*2)]) writeToFile:[direct stringByAppendingPathComponent:[NSString stringWithFormat:@"AppIcon-%@@2x.png",obj]] atomically:YES];
        [UIImagePNGRepresentation([self je_sizeTo:CGSizeMake(obj.integerValue*3, obj.integerValue*3)]) writeToFile:[direct stringByAppendingPathComponent:[NSString stringWithFormat:@"AppIcon-%@@3x.png",obj]] atomically:YES];
    }
}
 
- (UIImage *)je_resetQuality:(CGInterpolationQuality)quality rate:(CGFloat)rate{
    CGFloat width = self.size.width * rate;
    CGFloat height = self.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}

- (UIImage *)je_limitToWH:(CGFloat)maxWH{
    if (self == nil) { return nil;}
    if (MAX(self.size.height,self.size.width) <= maxWH) {
        return self;
    }
    //超过了限制 按比例压缩长宽
    CGSize size;
    CGFloat max = MAX(self.size.height, self.size.width);
    size.height = self.size.height*(maxWH/max);
    size.width = self.size.width*(maxWH/max);

    return [self je_sizeTo:size];
}

- (UIImage *)je_sizeTo:(CGSize)size{
    UIImage *newimage;
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0,size.width,size.height)];
    newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage ;
}

#pragma mark -

/** 保存到指定相册名字 */
- (void)je_savedToAlbum:(NSString*)AlbumName success:(void(^)(void))completeBlock fail:(void(^)(void))failBlock{
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    __block BOOL isExisted = NO;
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        if ([assetCollection.localizedTitle isEqualToString:AlbumName])  {
            isExisted = YES;
        }
    }];
    if (!isExisted) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:AlbumName];
        } completionHandler:nil];
    }
    
    __block NSString *localIdentifier;
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        //Camera Roll是我们写入照片的相册
        if ([assetCollection.localizedTitle isEqualToString:AlbumName])  {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:self];
                PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset];
                [collectonRequest addAssets:@[placeHolder]];
                localIdentifier = placeHolder.localIdentifier;
            } completionHandler:^(BOOL suc, NSError *error) {
                suc ? (!completeBlock ? : completeBlock()) : (!failBlock ? : failBlock());
            }];
        }
    }];
}

/// 保存到相册
- (void)je_savedToAlbum:(void(^)(void))completeBlock fail:(void(^)(void))failBlock{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//        ID = [PHAssetChangeRequest creationRequestForAssetFromImage:self].placeholderForCreatedAsset.localIdentifier;
        [PHAssetChangeRequest creationRequestForAssetFromImage:self];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) { !failBlock ? : failBlock();}else{!completeBlock ? : completeBlock();}
        });
    }];
}

- (UIImage *)fixOrientation {
    if (self.imageOrientation == UIImageOrientationUp) return self;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/** 旋转角度后的图片 */
- (UIImage*)je_rotate:(CGFloat)degrees{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    CGSize rotatedSize;
    
    rotatedSize.width = width/self.scale;
    rotatedSize.height = height/self.scale;
    
//    UIGraphicsBeginImageContext(rotatedSize);
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, 3);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/** 加水印 */
- (UIImage *)je_waterMark:(NSString *)text color:(UIColor *)color font:(UIFont *)font type:(ImageJEWaterMarkType)type offset:(CGPoint)offset{
    CGSize size = self.size;
    CGRect rect = (CGRect){CGPointZero,size};
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    [self drawInRect:rect];
    
    NSDictionary *attr = @{NSFontAttributeName : font,NSForegroundColorAttributeName:color};
    CGRect strRect = [self calWidth:text attr:attr type:type rect:rect offset:offset];
    [text drawInRect:strRect withAttributes:attr];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (CGRect)calWidth:(NSString *)str attr:(NSDictionary *)attr type:(ImageJEWaterMarkType)type rect:(CGRect)rect offset:(CGPoint)offset{
    CGSize size =  [str sizeWithAttributes:attr];
    CGRect calRect = [self rectWithRect:rect size:size type:type offset:offset];
    return calRect;
}

- (CGRect)rectWithRect:(CGRect)rect size:(CGSize)size type:(ImageJEWaterMarkType)type offset:(CGPoint)offset{
    CGPoint point = CGPointZero;
    if(ImageJEWaterMarkDTypeTopRight == type) point = CGPointMake(rect.size.width - size.width, 0);
    if(ImageJEWaterMarkTypeBottomLeft == type) point = CGPointMake(0, rect.size.height - size.height);
    if(ImageJEWaterMarkTypeBottomRight == type) point = CGPointMake(rect.size.width - size.width, rect.size.height - size.height);
    if(ImageJEWaterMarkTypeCenter == type) point = CGPointMake((rect.size.width - size.width)*.5f, (rect.size.height - size.height)*.5f);
    point.x+=offset.x;
    point.y+=offset.y;
    CGRect calRect = (CGRect){point,size};
    return calRect;
}

/** 加水印 */
- (UIImage *)je_waterMark:(UIImage *)waterImage size:(CGSize)imgSize type:(ImageJEWaterMarkType)type offset:(CGPoint)offset{
    CGSize size = self.size;
    CGRect rect = (CGRect){CGPointZero,size};
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:rect];

    CGSize waterImageSize = CGSizeMake(imgSize.width*waterImage.scale, imgSize.height *waterImage.scale);
    CGRect calRect = [self rectWithRect:rect size:waterImageSize type:type offset:offset];
    [waterImage drawInRect:calRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage*)je_gradualColors:(NSArray <UIColor *>*)colors size:(CGSize)size type:(ImageJEGradualType)type{
    NSMutableArray *ar = [NSMutableArray array];
   
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    
    if (colors.count == 0) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 3);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (type) {
        case ImageJEGradualType1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
        case ImageJEGradualType2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, 0.0);
            break;
        case ImageJEGradualType3:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, size.height);
            break;
        case ImageJEGradualType4:
            start = CGPointMake(size.width, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}


/** 模糊效果图片 */
- (UIImage*)je_boxblurImageWithBlur:(CGFloat)blur withTintColor:(UIColor *)tintColor{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }

    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
//    if(pixelBuffer == NULL) NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    /*void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
     vImage_Buffer outBuffer2;
     outBuffer2.data = pixelBuffer2;
     outBuffer2.width = CGImageGetWidth(img);
     outBuffer2.height = CGImageGetHeight(img);
     outBuffer2.rowBytes = CGImageGetBytesPerRow(img);*/

    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    
    CGRect imageRect = {CGPointZero, self.size};
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(ctx);
        CGContextSetFillColorWithColor(ctx, tintColor.CGColor);
        CGContextFillRect(ctx, imageRect);
        CGContextRestoreGState(ctx);
    }
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    //free(pixelBuffer2);
    
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}

@end
