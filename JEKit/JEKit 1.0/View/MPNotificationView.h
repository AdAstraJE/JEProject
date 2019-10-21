//
//  MPNotificationView.h
//  Moped
//
//  Created by Engin Kurutepe on 1/2/13.
//  Copyright (c) 2013 Moped Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


extern NSString *kMPNotificationViewTapReceivedNotification;

typedef void (^MPNotificationSimpleAction)(id);
@protocol MPNotificationViewDelegate;

@interface MPNotificationView : UIView

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) id<MPNotificationViewDelegate> delegate;

@property (nonatomic) NSTimeInterval duration;

+ (MPNotificationView *) notifyWithText:(NSString*)text
                                 detail:(NSString*)detail
                                  image:(UIImage*)image
                            andDuration:(NSTimeInterval)duration;

+ (MPNotificationView *) notifyWithText:(NSString*)text
                                 detail:(NSString*)detail
                            andDuration:(NSTimeInterval)duration;

+ (MPNotificationView *) notifyWithText:(NSString*)text
                              andDetail:(NSString*)detail;

+ (MPNotificationView *) notifyWithText:(NSString*)text
                                 detail:(NSString*)detail
                                  image:(UIImage*)image
                               duration:(NSTimeInterval)duration
                          andTouchBlock:(MPNotificationSimpleAction)block;

+ (MPNotificationView *) notifyWithText:(NSString*)text
                                 detail:(NSString*)detail
                               imageurl:(NSString*)imageurl
                               duration:(NSTimeInterval)duration
                          andTouchBlock:(MPNotificationSimpleAction)block;

+ (MPNotificationView *) notifyWithText:(NSString*)text
                                 detail:(NSString*)detail
                               imageurl:(NSString*)imageurl
                              LigthText:(NSString*)light
                               duration:(NSTimeInterval)duration
                          andTouchBlock:(MPNotificationSimpleAction)block;

+ (MPNotificationView *) notifyWithText:(NSString*)text
                                 detail:(NSString*)detail
                               duration:(NSTimeInterval)duration
                          andTouchBlock:(MPNotificationSimpleAction)block;

+ (MPNotificationView *) notifyWithText:(NSString*)text
                                 detail:(NSString*)detail
                          andTouchBlock:(MPNotificationSimpleAction)block;

@end

@protocol MPNotificationViewDelegate <NSObject>

@optional
- (void)didTapOnNotificationView:(MPNotificationView *)notificationView;

@end


@interface OBGradientView : UIView {
}

// Returns the view's layer. Useful if you want to access CAGradientLayer-specific properties
// because you can omit the typecast.
@property (nonatomic, readonly) CAGradientLayer *gradientLayer;

// Gradient-related properties are forwarded to layer.
// colors also accepts array of UIColor objects (in addition to array of CGColorRefs).
@property (nonatomic, retain) NSArray *colors;
@property (nonatomic, retain) NSArray *locations;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic, copy) NSString *type;

@end

