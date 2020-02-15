
#import "JEScrollView.h"

@implementation JEScrollView

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    if(!self.dragging){
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event{
    if(!self.dragging){
        [[self nextResponder]touchesEnded:touches withEvent:event];
    }
    [super touchesEnded:touches withEvent:event];
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view{
    return YES;
}

//父视图是否可以将消息传递给子视图，yes是将事件传递给子视图，则不滚动，no是不传递则继续滚动
//- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
//{
//    if ([view isKindOfClass:[UIButton class]])
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//    
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    CGPoint point = [gestureRecognizer locationInView:self];
//    
//    // 首先判断otherGestureRecognizer是不是系统pop手势
//    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
//        
//        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
//            if (point.x < 50) {
//                self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
//                return YES;
//            }
//        }
//    }
//    
//    return NO;
//}


@end
