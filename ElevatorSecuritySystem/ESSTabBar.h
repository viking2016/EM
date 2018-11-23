//
//  ESSTabBar.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/7.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSTabBar : UITabBar

@property (nonatomic, strong) UIButton *scanBtn;

@property (copy, nonatomic) void(^block)(UIButton *);

- (instancetype)initWithBlock:(void(^)(UIButton *scanBtn))scanBtnClickBlock;

@end
