//
//  ESSRepairFormDetailPartReplacementCell.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/17.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESSRepairModel.h"

@interface ESSRepairFormDetailPartReplacementCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mark;
@property (weak, nonatomic) IBOutlet UILabel *partsLb;
@property (weak, nonatomic) IBOutlet UILabel *brandLb;
@property (weak, nonatomic) IBOutlet UILabel *modelLb;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *numberLb;
@property (weak, nonatomic) IBOutlet UILabel *totalLb;
@property (strong, nonatomic) ESSPartReplacemenModel *model;

@end
