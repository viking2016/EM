//
//  ESSMapPickerTableViewCell.h
//  ElevatorMaintenanceAssistant
//
//  Created by 刘树龙 on 17/3/17.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MapPickerController.h"

extern NSString *const EMAMapPickerTableViewCellName;

@interface ESSMapPickerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;

@property (strong, nonatomic) MapPickerController *mapPickerController;
@property (copy, nonatomic) void(^valueSelected)(RWLocation *);

- (void)setLabelText:(NSString *)labelText
     detailLabelText:(NSString *)detailLabelText
       valueSelected:(void(^)(RWLocation *value))valueSelected;

@end
