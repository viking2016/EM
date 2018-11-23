//
//  UIBarButtonItem+Add.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/9/18.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Add)

+ (instancetype _Nonnull )itemWithTitle:(nullable NSString *)title image:(nullable NSString *)image highImage:(nullable NSString *)highImage target:(nullable id)target action:(nullable SEL)action;

@end
