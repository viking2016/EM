//
//  ESSPageControlCell.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/23.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSPageControlCell.h"

@interface ESSPageControlCell()

@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
@property (weak, nonatomic) IBOutlet UILabel *lb;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation ESSPageControlCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setLbTest:(NSString *)lbTest {
    self.lb.text = lbTest;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.lb.textColor = HexColor(@"1aacef");
        self.backgroundColor = [UIColor whiteColor];
        self.topImgView.backgroundColor = HexColor(@"1aacef");
        self.iconView.image = self.selectImg;
    }
    else {
        self.lb.textColor = HexColor(@"666666");
        self.backgroundColor = HexColor(@"efeeee");
        self.topImgView.backgroundColor = HexColor(@"efeeee");
        self.iconView.image = self.unselectImg;
    }
}
@end
