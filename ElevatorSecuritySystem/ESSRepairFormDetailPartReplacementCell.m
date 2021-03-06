//
//  ESSRepairFormDetailPartReplacementCell.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/17.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSRepairFormDetailPartReplacementCell.h"

@implementation ESSRepairFormDetailPartReplacementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.mark.layer.borderWidth = 1;
    self.mark.layer.borderColor = HexColor(@"1aacef").CGColor;
    self.mark.layer.cornerRadius = 3;
}

- (void)setModel:(ESSPartReplacemenModel *)model {
    if (_model != model) {
        _model = model;
    }
    self.partsLb.text = self.model.PartName;
    self.brandLb.text = self.model.PartBrand;
    self.modelLb.text = [NSString stringWithFormat:@"（%@）",self.model.PartModel];
    float unitPrice = [self.model.UnitPrice floatValue];
    self.unitPriceLb.text = [NSString stringWithFormat:@"%.2f元",unitPrice];
    self.numberLb.text = [NSString stringWithFormat:@"%@个",self.model.Number];
    float total = [self.model.Total floatValue];
    self.totalLb.text = [NSString stringWithFormat:@"%.2f元",total];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
