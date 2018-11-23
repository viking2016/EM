//
//  ESSMaintenanceReadTermsController.h
//  ElevatorSystem
//
//  Created by c zq on 16/3/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESSMaintenanceTaskListModel.h"
@interface ESSMaintenanceReadTermsController : UITableViewController

@property (copy, nonatomic) NSString *taskID;
@property (strong, nonatomic) ESSMaintenanceTaskListModel *maintenanceModel;


- (instancetype)initWithTaskId:(NSString *)taskID maintenanceModel:(ESSMaintenanceTaskListModel *)maintenanceModel;

@end
