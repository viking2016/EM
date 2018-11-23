//
//  ESSNavigationController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/7.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSNavigationController.h"

@interface ESSNavigationController ()

@end

@implementation ESSNavigationController

#pragma mark - Public Method

/**
 * 可以在这个方法中拦截所有push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 如果push进来的不是第一个控制器
    if (!self.childViewControllers.count){
        
    }else {
        self.navigationBar.hidden = NO;
        
        // 添加返回按钮
        UIBarButtonItem *itemReturn = [UIBarButtonItem itemWithTitle:@"      " image:@"nav_back" highImage:@"nav_back_pre" target:self action:@selector(popViewControllerAnimated:)];
        
        if ([viewController isKindOfClass:[NSClassFromString(@"ESSSearchController") class]]) {
            viewController.navigationItem.hidesBackButton = YES;
        }else {
            viewController.navigationItem.leftBarButtonItem = itemReturn;
        }
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - Private Method

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
    self.navigationBar.barStyle = UIBaselineAdjustmentNone;
    self.navigationBar.barTintColor = MAINCOLOR;
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    self.interactivePopGestureRecognizer.delegate = (id)self;
}

@end
