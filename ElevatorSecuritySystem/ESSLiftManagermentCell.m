//
//  ESSLiftManagermentCell.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/27.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSLiftManagermentCell.h"

@interface ESSLiftManagermentCell()

@end

@implementation ESSLiftManagermentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.progressView = [[ESSProgressView alloc] initWithFrame:CGRectMake(0, 0, 150, 12)];
    [self.contentView addSubview:_progressView];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_innerLb.mas_left);
        make.bottom.equalTo(@-15);
        make.height.equalTo(@12);
        make.width.equalTo(@150);
    }];
}

- (void)setItem:(ESSLiftManagerLiftDetailModel *)item {
//    self.innerLb.text = [item.ProjectUnit stringByAppendingString:item.InnerCode];
    self.innerLb.text = item.InnerNo;
    if (item.MCategories.length > 2) {
        self.typeBtn.hidden = NO;
        [self.typeBtn setTitle:[NSString stringWithFormat:@"%@ >",[item.MCategories substringToIndex:2]] forState:UIControlStateNormal];
    }else {
        if (item.MCategories.length == 2) {
            self.typeBtn.hidden = NO;
            [self.typeBtn setTitle:[NSString stringWithFormat:@"%@ >",[item.MCategories substringToIndex:2]] forState:UIControlStateNormal];
        }else {
            self.typeBtn.hidden = YES;
        }
        if (item.Mdate.length == 0) {
            item.Days = @"999999";
    }
        if (![item.IsAlarm boolValue]) {
            [self.faultIcon setImage:[UIImage imageNamed:@""]];
        }else{
            [self.faultIcon setImage:[UIImage imageNamed:@"icon_diantiguzhang"]];
        }
}
    NSInteger tmp = [item.Days integerValue];
    [self.progressView updateWithCurrent:tmp];
}

- (IBAction)typeBtnClicked:(UIButton *)sender {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
