//
//  ESSTabBar.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/7.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSTabBar.h"

@implementation ESSTabBar

#pragma mark - Public Method

- (instancetype)initWithBlock:(void (^)(UIButton *))scanBtnClickBlock {
    self = [super init];
    if (self) {
        [self setShadowImage:[[UIImage alloc] init]];
        [self setBackgroundImage:[[UIImage alloc] init]];
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 74)];
        image.image = [UIImage imageNamed:@"tabBar_bg"];
        image.userInteractionEnabled = YES;
        [self addSubview:image];
    
        // 添加发布按钮
        self.scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.scanBtn setBackgroundImage:[UIImage imageNamed:@"icon_tab_saoyisao"] forState:UIControlStateNormal];
        [self.scanBtn setBackgroundImage:[UIImage imageNamed:@"icon_tab_saoyisao"] forState:UIControlStateHighlighted];
        self.scanBtn.size = self.scanBtn.currentBackgroundImage.size;
        [self.scanBtn addTarget:self action:@selector(scanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_scanBtn];
        self.block = scanBtnClickBlock;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    float x = frame.origin.x;
    float y = frame.origin.y;
    float w = frame.size.width;
    float h = 74;
    frame = CGRectMake(x, y, w, h);
    [super setFrame:frame];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize otherSize = CGSizeMake(size.width, 74);
    return otherSize;
}

- (void)scanButtonClick:(UIButton *)btn {
    if (_block) _block(btn);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 设置扫描按钮的frame
    self.scanBtn.center = CGPointMake(self.width * 0.5f, self.height * 0.5f);
    // 设置其他UITabBarButton的frame
    CGFloat buttonY = 20;
    CGFloat buttonW = self.width / 5;
    CGFloat buttonH = self.height - 25;
    NSInteger index = 0;
    for (UIView *button in self.subviews) {
        if (![button isKindOfClass:[UIControl class]] || button == self.scanBtn) continue;
        // 计算按钮的x值
        CGFloat buttonX = buttonW * ((index > 1)?(index + 1):index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        // 增加索引
        index++;
    }
}

@end
