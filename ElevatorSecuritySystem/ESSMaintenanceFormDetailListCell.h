//
//  ESSMaintenanceFormDetailListCell.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/9/26.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESSMaintenanceFormDetailListModel.h"

@interface ESSMaintenanceFormDetailListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UILabel *stateLb;
@property (weak, nonatomic) IBOutlet UILabel *maintenanceNoLb;
@property (weak, nonatomic) IBOutlet UILabel *maintenanceTypeLb;
@property (weak, nonatomic) IBOutlet UILabel *maintenancePersonLb;
@property (weak, nonatomic) IBOutlet UILabel *evaluateStateLb;

- (void)decorateWithModel:(ESSMaintenanceFormDetailListModel *)model;

@end
