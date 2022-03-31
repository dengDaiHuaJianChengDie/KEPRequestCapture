//
//  RCActionableTableViewCell.m
//  Keep
//
//  Created by weidianwen on 2022/1/7.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "RCActionableTableViewCell.h"
#import <Masonry/Masonry.h>
#import "RCColors.h"

@implementation RCActionableTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.actionLabel];
    
    [self.actionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(60);
    }];
}

- (UILabel *)actionLabel {
    if (!_actionLabel) {
        _actionLabel = [[UILabel alloc] init];
        _actionLabel.font = [UIFont boldSystemFontOfSize:20];
        _actionLabel.textColor = [RCColors colorWithHexString:@"#58BFBF"];
        _actionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _actionLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
