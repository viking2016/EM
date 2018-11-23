//
//  UIWindow+Add.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/5/6.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Add)

/**
 Returns the current Top Most ViewController in hierarchy.
 */
@property (nullable, nonatomic, readonly, strong) UIViewController *topMostController;

/**
 Returns the topViewController in stack of topMostController.
 */
@property (nullable, nonatomic, readonly, strong) UIViewController *currentViewController;


@end
