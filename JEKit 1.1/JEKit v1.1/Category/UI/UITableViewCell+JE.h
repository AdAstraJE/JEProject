
#import <UIKit/UIKit.h>

@interface UITableViewCell (JE)

@property(nonatomic,strong,readonly) NSIndexPath *indexPath;///< cell 对应的 indexpath

/// 方便构建方法 传入模型？  返回自己
- (instancetype)je_loadCell:(id)mod;

@end


