//
//  ESSMaintenanceTaskListCell.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/9/22.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESSMaintenanceTaskListModel.h"

@interface ESSMaintenanceTaskListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *codeLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UILabel *liftTypeLb;
@property (weak, nonatomic) IBOutlet UILabel *maintenanceTypeLb;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UILabel *stateLb;

- (void)decorateWithModel:(ESSMaintenanceTaskListModel *)model;

@end
