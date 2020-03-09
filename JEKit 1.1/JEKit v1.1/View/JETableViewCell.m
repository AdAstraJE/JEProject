
#import "JETableViewCell.h"
#import "JEKit.h"

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JETableViewCell   🔷🔷🔷🔷🔷🔷🔷🔷
@implementation JETableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectedBackgroundView = JEVe(self.bounds, [UIColor Light:kRGB(229, 229,234) dark:kRGB(44, 44, 47)], nil);
//    self.backgroundColor = [UIColor Light:UIColor.whiteColor dark:[UIColor colorWithRed:0.11 green:0.11 blue:0.12 alpha:1]];
    return self;
}

@end


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JETableViewCell1   🔷🔷🔷🔷🔷🔷🔷🔷
@implementation JETableViewCell1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.textLabel.font = JEShare.stc.titleFont;
    self.textLabel.textColor = JEShare.stc.titleColor;
    self.detailTextLabel.font = JEShare.stc.descFont;
    self.detailTextLabel.textColor = JEShare.stc.descColor;
    return self;
}

@end


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JETableViewCell3   🔷🔷🔷🔷🔷🔷🔷🔷
@implementation JETableViewCell3

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.textLabel.font = JEShare.stc.titleFont;
    self.textLabel.textColor = JEShare.stc.titleColor;
    self.detailTextLabel.font = JEShare.stc.detailFont;
    self.detailTextLabel.textColor = JEShare.stc.detailColor;
    return self;
}

@end
