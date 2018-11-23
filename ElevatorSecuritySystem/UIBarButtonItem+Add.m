//
//  UIBarButtonItem+Add.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/9/18.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "UIBarButtonItem+Add.h"

@implementation UIBarButtonItem (Add)

+ (instancetype)itemWithTitle:(NSString *)title image:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.size = CGSizeMake(button.size.width, button.size.height + 10);

    return [[self alloc] initWithCustomView:button];
}
@end
