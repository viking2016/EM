//
//  ESSDatePickerTableViewCell.m
//  ElevatorMaintenanceAssistant
//
//  Created by 刘树龙 on 17/3/17.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co., Ltd. All rights reserved.
//

#import "ESSDatePickerTableViewCell.h"

NSString *const EMADatePickerTableViewCellName = @"ESSDatePickerTableViewCell";

@implementation ESSDatePickerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.datePicker showActionSheetPicker];
    }
}

#pragma mark - Public method
- (void)setLabelText:(NSString *)labelText detailLabelText:(NSString *)detailLabelText pickerDateFormate:(UIDatePickerMode)pickerDateFormate showDateFormate:(NSString *)showDateFormate valueSelected:(void (^)(NSString *))valueSelected {
    NSString *lastChar = [labelText substringFromIndex:labelText.length - 1];
    if ([lastChar isEqualToString:@"*"]) {
        NSMutableAttributedString * tempString = [[NSMutableAttributedString alloc] initWithString: labelText];
        [tempString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(labelText.length - 1, 1)];
        self.lb.attributedText = tempString;
    }else {
        self.lb.text = labelText;
    }
    self.detailLb.text = detailLabelText;
    [self crearePickerViewWithPickerDateFormate:pickerDateFormate showDateFormate:showDateFormate];
    self.valueSelected = valueSelected;
}

#pragma mark - Private method
- (void)crearePickerViewWithPickerDateFormate:(UIDatePickerMode)pickerDateFormate showDateFormate:(NSString *)showDateFormate{
    ActionDateDoneBlock done = ^(ActionSheetDatePicker *picker, id selectedDate, id origin){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:showDateFormate];
        NSString *date = [formatter stringFromDate:selectedDate];
        self.detailLb.text = date;
        self.valueSelected(date);
    };
    ActionDateCancelBlock cancel = ^(ActionSheetDatePicker *picker){
        
    };
    
    NSMutableString *titleStr = [self.lb.text mutableCopy];
    NSRange lastRange = NSMakeRange(titleStr.length - 1, 1);
    NSString *lastChar = [titleStr substringWithRange:lastRange];
    if ([lastChar isEqualToString:@"*"]) {
        [titleStr replaceCharactersInRange:lastRange withString:@""];
    }
    
    self.datePicker = [[ActionSheetDatePicker alloc] initWithTitle:titleStr datePickerMode:pickerDateFormate selectedDate:[NSDate date] doneBlock:done cancelBlock:cancel origin:self];
}

@end
