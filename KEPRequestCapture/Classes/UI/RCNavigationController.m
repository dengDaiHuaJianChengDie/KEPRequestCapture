//
//  RCNavigationController.m
//  Keep
//
//  Created by weidianwen on 2022/1/6.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "RCNavigationController.h"

@interface RCNavigationController ()

@end

@implementation RCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.navigationBar.prefersLargeTitles = NO;
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *navBarAppearance = [[UINavigationBarAppearance alloc] init];
        navBarAppearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor labelColor]};
        navBarAppearance.largeTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor labelColor]};
        navBarAppearance.backgroundColor = [UIColor systemBackgroundColor];
        self.navigationBar.standardAppearance = navBarAppearance;
        self.navigationBar.scrollEdgeAppearance = navBarAppearance;
        self.navigationBar.tintColor = [UIColor systemBlueColor];
    }
}

@end
