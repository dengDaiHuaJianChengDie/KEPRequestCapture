//
//  RCRequestCell.h
//  Keep
//
//  Created by weidianwen on 2022/1/6.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCRequestCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *methodLabel;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UILabel *urlLabel;
@property (nonatomic, strong) UILabel *durationLabel;

- (void)populate:(RCRequestModel *)request;

@end

NS_ASSUME_NONNULL_END
