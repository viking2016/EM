//
//  ESSTextFieldTableViewCell.m
//  ElevatorMaintenanceAssistant
//
//  Created by 刘树龙 on 17/3/8.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co., Ltd. All rights reserved.
//

#import "ESSTextFieldTableViewCell.h"

NSString *const EMATextFieldTableViewCellName = @"ESSTextFieldTableViewCell";

@interface ESSTextFieldTableViewCell()<UITextFieldDelegate>

@end

@implementation ESSTextFieldTableViewCell
#pragma mark - Public Method

- (void)awakeFromNib {
    [super awakeFromNib];

    self.tf.delegate = self;
    [self.tf addTarget:self action:@selector(textFieldChangedValue:) forControlEvents:UIControlEventEditingChanged];
//
//    UIView *aSelectedBackgroundView = [[UIView alloc] init];
//    [aSelectedBackgroundView setFrame:self.frame];
//    self.selectedBackgroundView = aSelectedBackgroundView;
    
    // 用来结局textField.text为中文，点击后向下移动的问题
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    self.tf.leftView = view;
    self.tf.leftViewMode = UITextFieldViewModeAlways;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.tf becomeFirstResponder];
    }
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    for (UIView *subview in self.contentView.superview.subviews) {
//        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
//            subview.hidden = NO;
//            CGRect frame = subview.frame;
//            frame.origin.x += self.separatorInset.left;
//            frame.size.width -= self.separatorInset.right;
//            subview.frame =frame;
//        }
//    }
//}

#pragma mark - Private Method
// textField的触发事件
- (void)textFieldChangedValue:(UITextField *)textField {
    if (textField) {
        self.textFieldTextChanged(textField.text);
    }
}

#pragma mark - Public method
- (void)setLabelText:(NSString *)labelText textFieldText:(NSString *)textFieldText placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)type textAlignment:(NSTextAlignment)alignment textFieldTextChanged:(void (^)(NSString *))textFieldTextChanged {
    NSString *lastChar = [labelText substringFromIndex:labelText.length - 1];
    if ([lastChar isEqualToString:@"*"]) {
        NSMutableAttributedString * tempString = [[NSMutableAttributedString alloc] initWithString: labelText];
        [tempString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(labelText.length - 1, 1)];
        self.lb.attributedText = tempString;
    }else {
        self.lb.text = labelText;
    }
    
    self.tf.text = textFieldText;
    self.lb.font = [UIFont systemFontOfSize:14];
    self.tf.font = [UIFont systemFontOfSize:14];
    self.tf.placeholder = placeholder;
    self.tf.keyboardType = type;
    self.textFieldTextChanged = textFieldTextChanged;
    self.tf.textAlignment = alignment;
    [self.tf setValue:rgba(169, 169, 169, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [self.tf setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
}

#pragma mark - Life Cycle

@end
