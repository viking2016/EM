//
//  ESSEvalutionCell.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/18.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSEvalutionCell.h"

@implementation ESSEvalutionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.signImgView.layer.borderWidth = 1;
    self.signImgView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.repairFormImgView.layer.borderWidth = 1;
    self.repairFormImgView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
}

/*
 @property (weak, nonatomic) IBOutlet UILabel *serviceAttitudeLb;
 @property (weak, nonatomic) IBOutlet UILabel *technicalLevelLb;
 @property (weak, nonatomic) IBOutlet UILabel *evaluatorPersonLb;
 @property (weak, nonatomic) IBOutlet UILabel *evaluateDate;
 @property (weak, nonatomic) IBOutlet UILabel *evaluateRemark;
 @property (weak, nonatomic) IBOutlet UIImageView *signImgView;
 @property (weak, nonatomic) IBOutlet UIImageView *repairFormImgView;
 */

- (void)setModel:(ESSRepairModel *)model {
    if (_model != model) {
        _model = model;
    }
    self.serviceAttitudeLb.text = self.model.ServiceAttitude;
    self.technicalLevelLb.text = self.model.TechnicalLevel;
    self.evaluatorPersonLb.text = self.model.EvaluatorPerson;
    self.evaluateDate.text = self.model.EvaluatorDate;
    self.evaluateRemark.text = self.model.EvaluatorRemark;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
