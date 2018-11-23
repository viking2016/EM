//
//  ESSPartReplacementFormTableViewCell.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/5.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSPartReplacementFormTableViewCell.h"

@implementation ESSPartReplacementFormTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.partsTf addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.brandTf addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.modelTf addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.numberTf addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.unitPriceTf addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setModel:(ESSPartReplacemenModel *)model {
    if (_model != model) {
        _model = model;
    }
    self.partsTf.text = self.model.Parts;
    self.brandTf.text = self.model.Brand;
    self.modelTf.text = self.model.Model;
    self.numberTf.text = self.model.Number;
    self.unitPriceTf.text = self.model.UnitPrice;
}

- (IBAction)deleteBtnClicked:(UIButton *)sender {
    self.deleteBtnClicked();
}

- (void)textFieldTextChanged:(UITextField *)textField {
    if (textField == self.partsTf) {
        self.model.Parts = textField.text;
    }
    else if(textField == self.brandTf) {
        self.model.Brand = textField.text;
    }
    else if(textField == self.modelTf) {
        self.model.Model = textField.text;
    }
    else if(textField == self.numberTf) {
        self.model.Number = textField.text;
        float total = [textField.text floatValue] * [self.unitPriceTf.text floatValue];
        self.model.Total = [NSString stringWithFormat:@"%.2f",total];
    }
    else if(textField == self.unitPriceTf) {
        self.model.UnitPrice = textField.text;
        float total = [textField.text floatValue] * [self.numberTf.text floatValue];
        self.model.Total = [NSString stringWithFormat:@"%.2f",total];
    }
    self.textFieldTextChanged(self.model);
}

@end
