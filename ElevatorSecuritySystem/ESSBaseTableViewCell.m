//
//  ESSBaseTableViewCell.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/6/29.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSBaseTableViewCell.h"

@implementation ESSBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setLbText:(NSString *)lbText {
    NSString *lastChar = [lbText substringFromIndex:lbText.length - 1];
    if ([lastChar isEqualToString:@"*"]) {
        NSMutableAttributedString * tempString = [[NSMutableAttributedString alloc] initWithString: lbText];
        [tempString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(lbText.length - 1, 1)];
        self.lb.attributedText = tempString;
    }else {
        self.lb.text = lbText;
    }
}

- (void)setDetailLbText:(NSString *)detailLbText {
    self.detailLb.textColor = HexColor(@"#333333");
    self.detailLb.text = detailLbText;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
