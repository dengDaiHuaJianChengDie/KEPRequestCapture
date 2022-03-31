//
//  RCRequestDetailViewController.h
//  Keep
//
//  Created by weidianwen on 2022/1/7.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "RCBaseViewController.h"
#import "RCRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCRequestDetailViewController : RCBaseViewController

@property (nonatomic, strong) RCRequestModel *request;
@property (nonatomic, strong) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
