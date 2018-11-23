//
//  ESSLocationPickerTableViewCell.m
//  ElevatorMaintenanceAssistant
//
//  Created by 刘树龙 on 17/3/17.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co., Ltd. All rights reserved.
//

#import "ESSLocationPickerTableViewCell.h"

NSString *const EMALocationPickerTableViewCellName = @"ESSLocationPickerTableViewCell";

@implementation ESSLocationPickerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        __weak typeof(self) weakSelf = self;
        
        LocationPickerController *locationPickerController = [[LocationPickerController alloc] initWithStyle:_style valueSelected:^(NSDictionary *value) {
            weakSelf.detailLb.text = value[@"Address"];
            weakSelf.valueSelected(value);
        }];
        [self.viewController.navigationController pushViewController:locationPickerController animated:YES];
    }
}

#pragma mark - Public method

- (void)setStyle:(LocationPickerStyle)style labelText:(NSString *)labelText detailLabelText:(NSString *)detailLabelText valueSelected:(void (^)(NSDictionary *))valueSelected {
    self.lb.text = labelText;
    self.lb.font = [UIFont systemFontOfSize:14];
    self.detailLb.text = detailLabelText;
    self.detailLb.font = [UIFont systemFontOfSize:14];
    self.valueSelected = valueSelected;
    self.style = style;
}

@end
