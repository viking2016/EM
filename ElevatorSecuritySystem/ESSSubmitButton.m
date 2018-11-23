//
//  ZXSubmitButton.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/11/28.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import "ESSSubmitButton.h"

@implementation ESSSubmitButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setBackgroundImage:[UIImage imageNamed:@"btnBg_submit_normal"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"btnBg_submit_highlighted"] forState:UIControlStateHighlighted];
    }
    return self;
}

+ (instancetype)buttonWithTitle:(NSString *)title selecter:(SEL)action y:(CGFloat)y{
    ESSSubmitButton *btn = [ESSSubmitButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(15, y, SCREEN_WIDTH - 30, 50)];
    [btn setBackgroundImage:[UIImage imageNamed:@"btnBg_submit_normal"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btnBg_submit_highlighted"] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = SYSFONT;
    [btn addTarget:[btn viewController] action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (instancetype)buttonWithTitle:(NSString *)title selecter:(SEL)action {
    ESSSubmitButton *btn = [ESSSubmitButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(15, SCREEN_HEIGHT - 50 - 15 - 64, SCREEN_WIDTH - 30, 50)];
    [btn setBackgroundImage:[UIImage imageNamed:@"btnBg_submit_normal"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btnBg_submit_highlighted"] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = SYSFONT;
    [btn addTarget:[btn viewController] action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


@end
