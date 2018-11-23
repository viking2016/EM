//
//  ESSRTDAlarmInfoCell.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/30.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSRTDAlarmInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *alarmInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *alarmTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *taskClassLab;
@property (weak, nonatomic) IBOutlet UILabel *faultTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *shouKunTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *xianChangMiaoShuLab;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

@property (copy, nonatomic) NSString *AlarmPhone;

@end
