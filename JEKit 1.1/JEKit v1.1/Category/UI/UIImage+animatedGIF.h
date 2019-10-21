#import <UIKit/UIKit.h>


@interface UIImage (animatedGIF)

+ (UIImage *)je_animatedImageWithAnimatedGIFData:(NSData *)theData;

+ (UIImage *)je_animatedImageWithAnimatedGIFURL:(NSURL *)theURL;

@end
