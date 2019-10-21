
#import <UIKit/UIKit.h>
#import "JETextView.h"
#import "JETextField.h"
#import "JEBaseVC.h"

typedef void(^ResultStringBlock)(NSString *Res);

@interface JESingleTextVC : JEBaseVC

@property (nonatomic,strong) ResultStringBlock ResCall;

@property (nonatomic,strong) JETextView *TextV_;
@property (nonatomic,strong) JETextField *Tf_;


/** Push一个编辑的TextView */
+ (JESingleTextVC *)Title:(NSString*)title text:(NSString*)text placeHolder:(NSString*)place limit:(NSUInteger)limit textHeight:(NSUInteger)textH call:(ResultStringBlock)call;

/** Push一个编辑的 TextField */
+ (JESingleTextVC *)Title:(NSString*)title TfText:(NSString*)text placeHolder:(NSString*)place limit:(NSUInteger)limit call:(ResultStringBlock)call;

/** Push一个选择性别的 */
+ (JESingleTextVC *)Title:(NSString*)title sex:(NSString*)sex call:(ResultStringBlock)call;

@end