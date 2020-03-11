
#import "UITableViewCell+JE.h"
#import "UIView+JE.h"

@implementation UITableViewCell (JE)

- (NSIndexPath *)indexPath{
    return [self.superTableView indexPathForCell:self];
}

- (instancetype)je_loadCell:(id)mod{
    return self;
}

@end
