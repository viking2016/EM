//
//  ESSEvalutionCell.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/18.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESSRepairModel.h"

@interface ESSEvalutionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serviceAttitudeLb;
@property (weak, nonatomic) IBOutlet UILabel *technicalLevelLb;
@property (weak, nonatomic) IBOutlet UILabel *evaluatorPersonLb;
@property (weak, nonatomic) IBOutlet UILabel *evaluateDate;
@property (weak, nonatomic) IBOutlet UILabel *evaluateRemark;
@property (weak, nonatomic) IBOutlet UIImageView *signImgView;
@property (weak, nonatomic) IBOutlet UIImageView *repairFormImgView;
@property (strong, nonatomic) ESSRepairModel *model;

@end
