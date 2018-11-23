//
//  ESSRTDWeiBaoComInfoCell.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/30.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSRTDWeiBaoComInfoCell.h"

@implementation ESSRTDWeiBaoComInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMPersonTel:(NSString *)MPersonTel{
    _MPersonTel = MPersonTel;
}

- (void)setEPersonTel:(NSString *)EPersonTel{
    _EPersonTel = EPersonTel;
}

- (void)setMPrincipalTel:(NSString *)MPrincipalTel{
    _MPrincipalTel = MPrincipalTel;
}

- (IBAction)MPersonTelBtnEvent:(UIButton *)sender {
    if (!(self.MPersonTel.length > 0)){
        [SVProgressHUD showInfoWithStatus:@"暂无手机号信息"];
        return;
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"联系机械维保人" message:[NSString stringWithFormat:@"tel:%@",self.MPersonTel] preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString * tel = [NSString stringWithFormat:@"tel://%@",_MPersonTel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
    }];
    [alert addAction:action];
    UIAlertAction * actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionCancle];
    [self.viewController presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)EPersonTelBtnEvent:(UIButton *)sender {
    if (!(self.EPersonTel.length > 0)){
        [SVProgressHUD showInfoWithStatus:@"暂无手机号信息"];
        return;
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"联系电气维保人" message:[NSString stringWithFormat:@"tel:%@",self.EPersonTel] preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString * tel = [NSString stringWithFormat:@"tel://%@",_EPersonTel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
    }];
    [alert addAction:action];
    UIAlertAction * actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionCancle];
    [self.viewController presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)MPrincipalTelBtnEvent:(UIButton *)sender {
    if (!(self.MPrincipalTel.length > 0)){
        [SVProgressHUD showInfoWithStatus:@"暂无手机号信息"];
        return;
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"联系维保负责人" message:[NSString stringWithFormat:@"tel:%@",self.MPrincipalTel] preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString * tel = [NSString stringWithFormat:@"tel://%@",_MPrincipalTel];
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
