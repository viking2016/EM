//
//  ESSMaintenanceItemsController.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/11/28.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESSMaintenanceTaskListModel.h"
@interface ESSMaintenanceItemsController : UIViewController

@property (copy, nonatomic) NSString *taskID;
@property (strong, nonatomic) ESSMaintenanceTaskListModel *maintenanceModel;
- (instancetype)initWithTaskId:(NSString *)taskID maintenanceModel:(ESSMaintenanceTaskListModel *)maintenanceModel;

@end
