
#import <UIKit/UIKit.h>
#import "JETextView.h"
#import "JETextField.h"
#import "JEBaseVC.h"

typedef void(^ResultStringBlock)(NSString *res);

@interface JESingleTextVC : JEBaseVC

@property (nonatomic,strong) ResultStringBlock ResCall;

@property (nonatomic,strong) JETextView *TextV_;
@property (nonatomic,strong) JETextField *Tf_;

/// TextView
+ (JESingleTextVC *)Title:(NSString*)title text:(NSString*)text placeHolder:(NSString*)place limit:(NSUInteger)limit textHeight:(NSUInteger)textH call:(ResultStringBlock)call;

///  TextField
+ (JESingleTextVC *)Title:(NSString*)title TfText:(NSString*)text placeHolder:(NSString*)place limit:(NSUInteger)limit call:(ResultStringBlock)call;

@end
