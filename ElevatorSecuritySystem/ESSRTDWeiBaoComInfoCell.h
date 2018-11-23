//
//  ESSRTDWeiBaoComInfoCell.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/30.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSRTDWeiBaoComInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *MUnitLab;

@property (weak, nonatomic) IBOutlet UILabel *MPersonNameLb;
@property (weak, nonatomic) IBOutlet UILabel *MPersonPhoneLb;

@property (weak, nonatomic) IBOutlet UILabel *EPersonNameLb;
@property (weak, nonatomic) IBOutlet UILabel *EPersonPhoneLb;
@property (weak, nonatomic) IBOutlet UILabel *MPrincipalNameLb;
@property (weak, nonatomic) IBOutlet UILabel *MPrincipalPhoneLb;



//只控制隐藏显示
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn_1;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn_2;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn_3;


@property (copy, nonatomic) NSString *MPersonTel;
@property (copy, nonatomic) NSString *EPersonTel;
@property (copy, nonatomic) NSString *MPrincipalTel;

@end
