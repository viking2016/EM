//
//  ESSMapPickerTableViewCell.m
//  ElevatorMaintenanceAssistant
//
//  Created by 刘树龙 on 17/3/17.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co., Ltd. All rights reserved.
//

#import "ESSMapPickerTableViewCell.h"

NSString *const EMAMapPickerTableViewCellName = @"ESSMapPickerTableViewCell";

@implementation ESSMapPickerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.viewController.navigationController pushViewController:_mapPickerController animated:YES];
    }
}

#pragma mark - Public method

- (void)setLabelText:(NSString *)labelText detailLabelText:(NSString *)detailLabelText valueSelected:(void (^)(RWLocation *))valueSelected {
    self.lb.text = labelText;
    self.detailLb.text = detailLabelText;
    self.detailLb.textColor = MAINCOLOR;
    [self createMapPickerController];
    self.valueSelected = valueSelected;
}

#pragma mark - Private method
- (void)createMapPickerController {
    
    __weak typeof(self) weakSelf = self;
    
    self.mapPickerController = [[MapPickerController alloc] init];
    self.mapPickerController.positionResult = ^(NSDictionary *selectedValue){
        RWLocation *tmp = [selectedValue objectForKey:@"RWLocation"];
        NSString *location = [NSString stringWithFormat:@"%@, %@",tmp.longitude,tmp.latitude];
        weakSelf.detailLb.text = location;
        if (selectedValue) {
            weakSelf.valueSelected(tmp);
        }
    };
    
//    self.mapPickerController.positionResult = ^(RWLocation *selectedValue){
//        NSString *location = [NSString stringWithFormat:@"%@, %@",selectedValue.longitude,selectedValue.latitude];
//        weakSelf.detailLb.text = location;
//        if (selectedValue) {
//            weakSelf.valueSelected(selectedValue);
//        }
//    };
}


@end
