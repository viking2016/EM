//
//  ESSDetailAddressCell.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/8/31.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSDetailAddressCell.h"

NSString *const ESSDetailAddressCellName = @"ESSDetailAddressCell";

@interface ESSDetailAddressCell ()<UITextFieldDelegate>


@end

@implementation ESSDetailAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.leftTF.delegate = self;
    self.rightTF.delegate = self;
    [self.leftTF addTarget:self action:@selector(textFieldChangedValue:) forControlEvents:UIControlEventEditingChanged];
    
    [self.rightTF addTarget:self action:@selector(textFieldChangedValue:) forControlEvents:UIControlEventEditingChanged];

    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    self.leftTF.leftView = view;
    self.leftTF.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *viewRight = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    
    self.rightTF.leftView = viewRight;
    self.rightTF.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


// textField的触发事件
- (void)textFieldChangedValue:(UITextField *)textField {
    if (textField) {
        self.detailTextFieldTextChanged(_leftTF.text, _rightTF.text);
    }
}
#pragma mark - Public method
- (void)setLabelText:(NSString *)labelText leftTextFieldText:(NSString *)leftTextFieldText rightTextFieldText:(NSString *)rightTextFieldText detailTextFieldTextChanged:(void (^)(NSString *, NSString *))detailTextFieldTextChanged{
    
//    self.lb.text = labelText;
    self.leftTF.text = leftTextFieldText;
    self.rightTF.text = rightTextFieldText;
    self.leftTF.font = [UIFont systemFontOfSize:14];
    self.rightTF.font = [UIFont systemFontOfSize:14];
    
    self.detailTextFieldTextChanged  = detailTextFieldTextChanged;
    
//    self.tf.textAlignment = alignment;
    
    
    
}



@end
