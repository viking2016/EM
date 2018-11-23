//
//  ESSPartReplacementFormController.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/5.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESSRepairModel.h"

@interface ESSPartReplacementFormController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray<ESSPartReplacemenModel *> *PartReplacemen;
@property (copy, nonatomic) void(^submited)(NSMutableArray<ESSPartReplacemenModel *> *PartReplacemen);

@end
