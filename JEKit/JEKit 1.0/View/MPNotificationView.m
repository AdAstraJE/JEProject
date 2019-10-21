//
//  MPNotificationView.m
//  Moped
//
//  Created by Engin Kurutepe on 1/2/13.
//  Copyright (c) 2013 Moped Inc. All rights reserved.
//

#import "MPNotificationView.h"
#import "UIImageView+WebCache.h"
#import "JEKit.h"


#define kMPNotificationHeight    ScreenNavBarH
#define kMPNotificationIPadWidth 480.0f
#define RADIANS(deg) ((deg) * M_PI / 180.0f)

static CGRect notificationRect()
{
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
    {
        return CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, kMPNotificationHeight);
    }

    return CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, kMPNotificationHeight);
}

NSString *kMPNotificationViewTapReceivedNotification = @"kMPNotificationViewTapReceivedNotification";

#pragma mark MPNotificationWindow

@interface MPNotificationWindow : UIWindow

@property (nonatomic, strong) NSMutableArray *notificationQueue;
@property (nonatomic, strong) UIView *currentNotification;

@end

@implementation MPNotificationWindow

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.backgroundColor = [UIColor clearColor];
        _notificationQueue = [[NSMutableArray alloc] initWithCapacity:4];

        UIView *topHalfBlackView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame),
                                                                            CGRectGetMinY(frame),
                                                                            CGRectGetWidth(frame),
                                                                            0.5 * CGRectGetHeight(frame))];

        topHalfBlackView.backgroundColor = [UIColor blackColor];
        topHalfBlackView.layer.zPosition = -100;
        topHalfBlackView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        [self addSubview:topHalfBlackView];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willRotateScreen:)
                                                     name:UIApplicationWillChangeStatusBarFrameNotification
                                                   object:nil];

        [self rotateStatusBarWithFrame:frame];
    }

    return self;
}

- (void) willRotateScreen:(NSNotification *)notification
{
    CGRect notificationBarFrame = notificationRect();

    if (self.hidden)
    {
        [self rotateStatusBarWithFrame:notificationBarFrame];
    }
    else
    {
        [self rotateStatusBarAnimatedWithFrame:notificationBarFrame];
    }
}

- (void) rotateStatusBarAnimatedWithFrame:(CGRect)frame
{
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView animateWithDuration:duration
                     animations:^{
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self rotateStatusBarWithFrame:frame];
                         [UIView animateWithDuration:duration
                                          animations:^{
                                              self.alpha = 1;
                                          }];
                     }];
}


- (void) rotateStatusBarWithFrame:(CGRect)frame
{
    BOOL isPortrait = (frame.size.width == [UIScreen mainScreen].bounds.size.width);

    if (isPortrait)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            frame.size.width = kMPNotificationIPadWidth;
        }

        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown)
        {
            frame.origin.y = [UIScreen mainScreen].bounds.size.height - kMPNotificationHeight;
            self.transform = CGAffineTransformMakeRotation(RADIANS(180.0f));
        }
        else
        {
            self.transform = CGAffineTransformIdentity;
        }
    }
    else
    {
        frame.size.height = frame.size.width;
        frame.size.width  = kMPNotificationHeight;

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            frame.size.height = kMPNotificationIPadWidth;
        }

        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft)
        {
            frame.origin.x = [UIScreen mainScreen].bounds.size.width - frame.size.width;
            self.transform = CGAffineTransformMakeRotation(RADIANS(90.0f));
        }
        else
        {
            self.transform = CGAffineTransformMakeRotation(RADIANS(-90.0f));
        }
    }

    self.frame = frame;
    CGPoint center = self.center;
    if (isPortrait)
    {
        center.x = CGRectGetMidX([UIScreen mainScreen].bounds);
    }
    else
    {
        center.y = CGRectGetMidY([UIScreen mainScreen].bounds);
    }
    self.center = center;
}

@end


static MPNotificationWindow * __notificationWindow = nil;
static CGFloat const __imagePadding = 15.0f;

#pragma mark -
#pragma mark MPNotificationView

@interface MPNotificationView ()


@property (nonatomic, strong) OBGradientView * contentView;
@property (nonatomic, copy) MPNotificationSimpleAction tapBlock;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

+ (void) showNextNotification;
+ (UIImage*) screenImageWithRect:(CGRect)rect;

@end

@implementation MPNotificationView

- (void) dealloc{
    _delegate = nil;
    [self removeGestureRecognizer:_tapGestureRecognizer];
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat notificationWidth = notificationRect().size.width;

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        _contentView = [[OBGradientView alloc] initWithFrame:self.bounds];
        _contentView.colors = @[(id)[[UIColor colorWithWhite:0 alpha:0.8] CGColor],(id)[[UIColor colorWithWhite:0  alpha:0.8] CGColor]];
//        _contentView.colors = @[(id)kColorBlue.CGColor,(id)kColorBlue.CGColor];

        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        _contentView.layer.cornerRadius = 8.0f;
//        _contentView.clipsToBounds = YES;
        [self addSubview:_contentView];

//        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 28, 28)];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, (self.height - 28)/2, 28, 28)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.cornerRadius = 4.0f;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];

        UIFont *textFont = [UIFont boldSystemFontOfSize:14.0f];
        CGRect textFrame = CGRectMake(__imagePadding + CGRectGetMaxX(_imageView.frame),8, notificationWidth - __imagePadding * 2 - CGRectGetMaxX(_imageView.frame), textFont.lineHeight);
        _textLabel = [[UILabel alloc] initWithFrame:textFrame];
        _textLabel.font = textFont;
        _textLabel.numberOfLines = 1;
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _textLabel.backgroundColor = [UIColor clearColor];
       
        [_contentView addSubview:_textLabel];

        UIFont *detailFont = [UIFont systemFontOfSize:12.0f];
        CGRect detailFrame = CGRectMake(CGRectGetMinX(textFrame),
                                        CGRectGetMaxY(textFrame) + 4,
                                        notificationWidth - __imagePadding * 2 - CGRectGetMaxX(_imageView.frame),
                                        detailFont.lineHeight*2);

        _detailTextLabel = [[UILabel alloc] initWithFrame:detailFrame];
        _detailTextLabel.font = detailFont;
        _detailTextLabel.numberOfLines = 0;

       
        _detailTextLabel.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:_detailTextLabel];

         _textLabel.textColor = _detailTextLabel.textColor = [UIColor whiteColor];
//        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame),
//                                                                      CGRectGetHeight(frame) - 1.0f,
//                                                                      CGRectGetWidth(frame),
//                                                                      1.0f)];
//        bottomLine.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
//
//        [_contentView addSubview:bottomLine];
    }

    return self;
}

+ (MPNotificationView *) notifyWithText:(NSString*)text
                              andDetail:(NSString*)detail
{
    return [self notifyWithText:text
                         detail:detail
                    andDuration:2.0f];
}

+ (MPNotificationView *) notifyWithText:(NSString*)text
                                 detail:(NSString*)detail
                            andDuration:(NSTimeInterval)duration
{
    return [self notifyWithText:text
                         detail:detail
                          image:nil
                    andDuration:duration];
}

+ (MPNotificationView *) notifyWithText:(NSString*)text
                                 detail:(NSString*)detail
                                  image:(UIImage*)image
                            andDuration:(NSTimeInterval)duration
{
    return [self notifyWithText:text
                         detail:detail
                          image:image
                       duration:duration
                  andTouchBlock:nil];
}

+ (MPNotificationView *) notifyWithText:(NSString*)text
                                 detail:(NSString*)detail
                               duration:(NSTimeInterval)duration
                          andTouchBlock:(MPNotificationSimpleAction)block
{
    return [self notifyWithText:text
                         detail:detail
                          image:nil
                       duration:duration
                  andTouchBlock:block];
}

+ (MPNotificationView *) notifyWithText:(NSString*)text
                                 detail:(NSString*)detail
                          andTouchBlock:(MPNotificationSimpleAction)block
{
    return [self notifyWithText:text
                         detail:detail
                          image:nil
                       duration:2.0
                  andTouchBlock:block];
}

+ (MPNotificationView *) notifyWithText:(NSString*)text
                                 detail:(NSString*)detail
                                  image:(UIImage*)image
                               duration:(NSTimeInterval)duration
                          andTouchBlock:(MPNotificationSimpleAction)block
{
    if (__notificationWindow == nil)
    {
        __notificationWindow = [[MPNotificationWindow alloc] initWithFrame:notificationRect()];
//        __notificationWindow.y = 20;
        __notificationWindow.hidden = NO;
    }

    MPNotificationView * notification = [[MPNotificationView alloc] initWithFrame:__notificationWindow.bounds];
    notification.textLabel.text = text;
    notification.detailTextLabel.text = detail;
    notification.imageView.image = image;
    notification.duration = duration;
    notification.tapBlock = block;

    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:notification
                                                                         action:@selector(handleTap:)];
    notification.tapGestureRecognizer = gr;
    [notification addGestureRecognizer:gr];

    [__notificationWindow.notificationQueue addObject:notification];

    if (__notificationWindow.currentNotification == nil)
    {
        [self showNextNotification];
    }

    return notification;
}


//自己加的fhkj
+ (MPNotificationView *) notifyWithText:(NSString*)text
                                 detail:(NSString*)detail
                               imageurl:(NSString*)imageurl
                               duration:(NSTimeInterval)duration
                          andTouchBlock:(MPNotificationSimpleAction)block{

    if (__notificationWindow == nil)
    {
        __notificationWindow = [[MPNotificationWindow alloc] initWithFrame:notificationRect()];
        __notificationWindow.hidden = NO;
    }

    MPNotificationView * notification = [[MPNotificationView alloc] initWithFrame:__notificationWindow.bounds];

    notification.textLabel.text = text;

    notification.detailTextLabel.text = detail;



    //[notification.imageView sd_setImageWithURL:[NSURL URLWithString:imageurl]];
    [notification.imageView sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:[UIImage imageNamed:@"_DefaultUser"]];
    notification.duration = duration;
    notification.tapBlock = block;

    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:notification
                                                                         action:@selector(handleTap:)];
    notification.tapGestureRecognizer = gr;
    [notification addGestureRecognizer:gr];

    [__notificationWindow.notificationQueue addObject:notification];

    if (__notificationWindow.currentNotification == nil)
    {
        [self showNextNotification];
    }

    return notification;

}
//[UIColor colorWithRed:245.0/255.0 green:94.0/255.0 blue:78.0/255.0 alpha:1.0f]
//部分文字高亮
+ (MPNotificationView *) notifyWithText:(NSString*)text
                                 detail:(NSString*)detail
                               imageurl:(NSString*)imageurl
                              LigthText:(NSString*)light
                               duration:(NSTimeInterval)duration
                          andTouchBlock:(MPNotificationSimpleAction)block{

    if (__notificationWindow == nil)
    {
        __notificationWindow = [[MPNotificationWindow alloc] initWithFrame:notificationRect()];
        __notificationWindow.hidden = NO;
    }

    MPNotificationView * notification = [[MPNotificationView alloc] initWithFrame:__notificationWindow.bounds];

    notification.textLabel.text = text;
    notification.detailTextLabel.text = detail;

    if (light != nil) {
        if ([detail rangeOfString:light].location != NSNotFound) {
            NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:detail];
            [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245.0/255.0 green:94.0/255.0 blue:78.0/255.0 alpha:1.0f] range:[detail rangeOfString:light]];
            [notification.detailTextLabel setAttributedText:attriString];
        }
    }

    
    [notification.imageView sd_setImageWithURL:imageurl.url placeholderImage:[imageurl isEqualToString:@"Group"] ? [UIImage imageNamed:@"GroupChat_Default"] : [UIImage imageNamed:@"_DefaultUser"]];
    notification.duration = duration;
    notification.tapBlock = block;

    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:notification
                                                                         action:@selector(handleTap:)];
    notification.tapGestureRecognizer = gr;
    [notification addGestureRecognizer:gr];

    [__notificationWindow.notificationQueue addObject:notification];

    if (__notificationWindow.currentNotification == nil)
    {
        [self showNextNotification];
    }

    return notification;

}







- (void) handleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    if (_tapBlock != nil)
    {
        _tapBlock(self);
    }

    //    if ([_delegate respondsToSelector:@selector(tapReceivedForNotificationView:)])
    //    {
    //        [_delegate didTapOnNotificationView:self];
    //    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kMPNotificationViewTapReceivedNotification
                                                        object:self];

    [NSObject cancelPreviousPerformRequestsWithTarget:[self class]
                                             selector:@selector(showNextNotification)
                                               object:nil];

    [MPNotificationView showNextNotification];
}

+ (void) showNextNotification
{
    UIView *viewToRotateOut = nil;
    UIImage *screenshot = [self screenImageWithRect:__notificationWindow.frame];

    if (__notificationWindow.currentNotification)
    {
        viewToRotateOut = __notificationWindow.currentNotification;
    }
    else
    {
        viewToRotateOut = [[UIImageView alloc] initWithFrame:__notificationWindow.bounds];
        ((UIImageView *)viewToRotateOut).image = screenshot;
        [__notificationWindow addSubview:viewToRotateOut];
        __notificationWindow.hidden = NO;
    }

    UIView *viewToRotateIn = nil;

    if ([__notificationWindow.notificationQueue count] > 0)
    {
        viewToRotateIn = __notificationWindow.notificationQueue[0];
    }
    else
    {
        viewToRotateIn = [[UIImageView alloc] initWithFrame:__notificationWindow.bounds];
        ((UIImageView *)viewToRotateIn).image = screenshot;
    }

    viewToRotateIn.layer.anchorPointZ = 11.547f;
    viewToRotateIn.layer.doubleSided = NO;
    viewToRotateIn.layer.zPosition = 2;

    CATransform3D viewInStartTransform = CATransform3DMakeRotation(RADIANS(-120), 1.0, 0.0, 0.0);
    viewInStartTransform.m34 = -1.0 / 200.0;

    viewToRotateOut.layer.anchorPointZ = 11.547f;
    viewToRotateOut.layer.doubleSided = NO;
    viewToRotateOut.layer.zPosition = 2;

    CATransform3D viewOutEndTransform = CATransform3DMakeRotation(RADIANS(120), 1.0, 0.0, 0.0);
    viewOutEndTransform.m34 = -1.0 / 200.0;

    [__notificationWindow addSubview:viewToRotateIn];
    __notificationWindow.backgroundColor = [UIColor blackColor];

    viewToRotateIn.layer.transform = viewInStartTransform;

    if ([viewToRotateIn isKindOfClass:[MPNotificationView class]] )
    {
        UIImageView *bgImage = [[UIImageView alloc] initWithFrame:__notificationWindow.bounds];
        bgImage.image = screenshot;
        [viewToRotateIn addSubview:bgImage];
        [viewToRotateIn sendSubviewToBack:bgImage];
        __notificationWindow.currentNotification = viewToRotateIn;
    }

    [UIView animateWithDuration:0.382
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         viewToRotateIn.layer.transform = CATransform3DIdentity;
                         viewToRotateOut.layer.transform = viewOutEndTransform;
                     }
                     completion:^(BOOL finished) {
                         [viewToRotateOut removeFromSuperview];
                         [__notificationWindow.notificationQueue removeObject:viewToRotateOut];
                         if ([viewToRotateIn isKindOfClass:[MPNotificationView class]])
                         {
                             MPNotificationView *notification = (MPNotificationView*)viewToRotateIn;
                             [self performSelector:@selector(showNextNotification)
                                        withObject:nil
                                        afterDelay:notification.duration];

                             __notificationWindow.currentNotification = notification;
                             [__notificationWindow.notificationQueue removeObject:notification];
                         }
                         else
                         {
                             [viewToRotateIn removeFromSuperview];
                             __notificationWindow.hidden = YES;
                             __notificationWindow.currentNotification = nil;
                         }

                         __notificationWindow.backgroundColor = [UIColor clearColor];
                     }];
}

+ (UIImage *) screenImageWithRect:(CGRect)rect
{
    CALayer *layer = [[UIApplication sharedApplication] keyWindow].layer;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, scale);

    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    rect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale
                      , rect.size.width * scale, rect.size.height * scale);

    CGImageRef imageRef = CGImageCreateWithImageInRect([screenshot CGImage], rect);
    UIImage *croppedScreenshot = [UIImage imageWithCGImage:imageRef
                                                     scale:screenshot.scale
                                               orientation:screenshot.imageOrientation];
    CGImageRelease(imageRef);

    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIImageOrientation imageOrientation = UIImageOrientationUp;

    switch (orientation)
    {
        case UIDeviceOrientationPortraitUpsideDown:
            imageOrientation = UIImageOrientationDown;
            break;
        case UIDeviceOrientationLandscapeRight:
            imageOrientation = UIImageOrientationRight;
            break;
        case UIDeviceOrientationLandscapeLeft:
            imageOrientation = UIImageOrientationLeft;
            break;
        default:
            break;
    }

    return [[UIImage alloc] initWithCGImage:croppedScreenshot.CGImage
                                      scale:croppedScreenshot.scale
                                orientation:imageOrientation];
}

@end




#pragma mark -
#pragma mark Implementation

@implementation OBGradientView

@dynamic gradientLayer;
@dynamic colors, locations, startPoint, endPoint, type;


// Make the view's layer a CAGradientLayer instance
+ (Class)layerClass
{
    return [CAGradientLayer class];
}



// Convenience property access to the layer help omit typecasts
- (CAGradientLayer *)gradientLayer
{
    return (CAGradientLayer *)self.layer;
}



#pragma mark -
#pragma mark Gradient-related properties

- (NSArray *)colors
{
    NSArray *cgColors = self.gradientLayer.colors;
    if (cgColors == nil) {
        return nil;
    }

    // Convert CGColorRefs to UIColor objects
    NSMutableArray *uiColors = [NSMutableArray arrayWithCapacity:[cgColors count]];
    for (id cgColor in cgColors) {
        [uiColors addObject:[UIColor colorWithCGColor:(CGColorRef)cgColor]];
    }
    return [NSArray arrayWithArray:uiColors];
}


// The colors property accepts an array of CGColorRefs or UIColor objects (or mixes between the two).
// UIColors are converted to CGColor before forwarding the values to the layer.
- (void)setColors:(NSArray *)newColors
{
    NSMutableArray *newCGColors = nil;

    if (newColors != nil) {
        newCGColors = [NSMutableArray arrayWithCapacity:[newColors count]];
        for (id color in newColors) {
            // If the array contains a UIColor, convert it to CGColor.
            // Leave all other types untouched.
            if ([color isKindOfClass:[UIColor class]]) {
                [newCGColors addObject:(id)[color CGColor]];
            } else {
                [newCGColors addObject:color];
            }
        }
    }

    self.gradientLayer.colors = newCGColors;
}


- (NSArray *)locations
{
    return self.gradientLayer.locations;
}

- (void)setLocations:(NSArray *)newLocations
{
    self.gradientLayer.locations = newLocations;
}

- (CGPoint)startPoint
{
    return self.gradientLayer.startPoint;
}

- (void)setStartPoint:(CGPoint)newStartPoint
{
    self.gradientLayer.startPoint = newStartPoint;
}

- (CGPoint)endPoint
{
    return self.gradientLayer.endPoint;
}

- (void)setEndPoint:(CGPoint)newEndPoint
{
    self.gradientLayer.endPoint = newEndPoint;
}

- (NSString *)type
{
    return self.gradientLayer.type;
}

- (void) setType:(NSString *)newType
{
    self.gradientLayer.type = newType;
}

@end
