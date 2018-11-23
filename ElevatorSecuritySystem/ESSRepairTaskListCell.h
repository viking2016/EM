//
//  ESSRepairTaskListCell.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/6/27.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESSRepairModel.h"

@interface ESSRepairTaskListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *uv_Top;
@property (weak, nonatomic) IBOutlet UIView *uv_Bottom;
@property (weak, nonatomic) IBOutlet UILabel *lb_RepairNo;
@property (weak, nonatomic) IBOutlet UILabel *lb_RepairDate;
@property (weak, nonatomic) IBOutlet UILabel *lb_LiftCode;
@property (weak, nonatomic) IBOutlet UILabel *lb_LiftType;
@property (weak, nonatomic) IBOutlet UILabel *lb_Address;
@property (weak, nonatomic) IBOutlet UILabel *lb_RepairPerson;
@property (weak, nonatomic) IBOutlet UILabel *lb_Remark;
@property (weak, nonatomic) IBOutlet UIButton *btn_Tel;
@property (weak, nonatomic) IBOutlet UIButton *btn_Revise;
@property (weak, nonatomic) IBOutlet UIButton *btn_Delete;
@property (weak, nonatomic) IBOutlet UIButton *btn_Detail;
@property (weak, nonatomic) IBOutlet UIButton *btn_Start;
@property (strong, nonatomic) ESSRepairModel *model;
@property (copy, nonatomic) void(^deleted)(void);

@end
