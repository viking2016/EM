//
//  ZXSubmitButton.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/11/28.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSSubmitButton : UIButton

+ (instancetype)buttonWithTitle:(NSString *)title selecter:(SEL)action y:(CGFloat)y;

+ (instancetype)buttonWithTitle:(NSString *)title selecter:(SEL)action;

@end
