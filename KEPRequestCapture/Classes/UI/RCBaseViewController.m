//
//  RCBaseViewController.m
//  Keep
//
//  Created by weidianwen on 2022/1/6.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "RCBaseViewController.h"

@interface RCBaseViewController ()

@end

@implementation RCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIView *)showLoader:(UIView *)view {
    UIView *loaderView = [[UIView alloc] initWithFrame:view.bounds];
    loaderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = loaderView.center;
    [loaderView addSubview:indicator];
    [view addSubview:loaderView];
    [indicator startAnimating];
    [loaderView bringSubviewToFront:view];
    return loaderView;
}

- (void)hideLoader:(UIView *)loaderView {
    [loaderView removeFromSuperview];
}

@end
