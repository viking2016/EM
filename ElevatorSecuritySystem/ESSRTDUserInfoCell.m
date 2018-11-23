//
//  ESSRTDUserInfoCell.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/30.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSRTDUserInfoCell.h"

@implementation ESSRTDUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTel:(NSString *)tel{
    _tel = tel;
}

- (IBAction)callBtnEvent:(UIButton *)sender {
    
    if (!(self.tel.length > 0)){
        [SVProgressHUD showInfoWithStatus:@"暂无手机号信息"];
        return;
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"联系负责人" message:[NSString stringWithFormat:@"tel:%@",self.tel] preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString * tel = [NSString stringWithFormat:@"tel://%@",_tel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
    }];
    [alert addAction:action];
    UIAlertAction * actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionCancle];
    [self.viewController presentViewController:alert animated:YES completion:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
