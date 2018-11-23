//
//  ESSRepairFormDetailTopCell.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/13.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESSRepairModel.h"

@interface ESSRepairFormDetailTopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *repairNoLb;
@property (weak, nonatomic) IBOutlet UILabel *liftCodeLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UILabel *repairPersonLb;
@property (weak, nonatomic) IBOutlet UILabel *repairDateLb;
@property (weak, nonatomic) IBOutlet UILabel *stateLb;
@property (weak, nonatomic) IBOutlet UILabel *servicePersonLb;
@property (weak, nonatomic) IBOutlet UILabel *callTypeLb;
@property (weak, nonatomic) IBOutlet UILabel *remarkLb;
@property (strong, nonatomic) ESSRepairModel *model;

@end
