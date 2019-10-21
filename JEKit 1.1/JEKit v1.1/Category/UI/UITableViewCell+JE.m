
#import "UITableViewCell+JE.h"
#import "UIView+JE.h"

@implementation UITableViewCell (JE)

/** cell 对应的 indexpath */
- (NSIndexPath *)indexPath{
    return [self.superTableView indexPathForCell:self];
}

- (instancetype)je_loadCell:(id)mod{
    return self;
}

@end
