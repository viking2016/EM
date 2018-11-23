//
//  ESSInformationListCell.h
//  ElevatorMaintenanceAssistant
//
//  Created by 刘树龙 on 17/3/3.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const ESSInformationListCellName;

@interface ESSInformationListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;

@end
