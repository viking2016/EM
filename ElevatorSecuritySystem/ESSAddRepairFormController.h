//
//  ESSAddRepairFormController.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/6/28.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESSRepairModel.h"

@interface ESSAddRepairFormController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ESSRepairModel *model;

@end
