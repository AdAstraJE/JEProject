#import <UIKit/UIKit.h>


@interface UIImage (animatedGIF)

+ (UIImage *)animatedImageWithAnimatedGIFData:(NSData *)theData;

+ (UIImage *)animatedImageWithAnimatedGIFURL:(NSURL *)theURL;

@end
