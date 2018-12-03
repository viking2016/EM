//
//  ESSStringPickerTableViewCell.m
//  ElevatorMaintenanceAssistant
//
//  Created by 刘树龙 on 17/3/17.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co., Ltd. All rights reserved.
//

#import "ESSStringPickerTableViewCell.h"

NSString *const EMAStringPickerTableViewCellName = @"ESSStringPickerTableViewCell";

@implementation ESSStringPickerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.stringPicker showActionSheetPicker];
    }
}

#pragma mark - Public method
- (void)setLabelText:(NSString *)labelText
     detailLabelText:(NSString *)detailLabelText
                 URL:(NSString *)URLStr
                 key:(NSString *)key
       valueSelected:(void (^)(NSString *value, id response))valueSelected {
    NSString *lastChar = [labelText substringFromIndex:labelText.length - 1];
    if ([lastChar isEqualToString:@"*"]) {
        NSMutableAttributedString * tempString = [[NSMutableAttributedString alloc] initWithString: labelText];
        [tempString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(labelText.length - 1, 1)];
        self.lb.attributedText = tempString;
    }else {
        self.lb.text = labelText;
    }
    self.detailLb.text = detailLabelText;
    [self createPickerViewWithURL:URLStr key:key];
    self.valueSelected = valueSelected;
}

- (void)setLabelText:(NSString *)labelText
     detailLabelText:(NSString *)detailLabelText
             strings:(NSArray *)strings
       valueSelected:(void (^)(NSString *, id response))valueSelected {
    NSString *lastChar = [labelText substringFromIndex:labelText.length - 1];
    if ([lastChar isEqualToString:@"*"]) {
        NSMutableAttributedString * tempString = [[NSMutableAttributedString alloc] initWithString: labelText];
        [tempString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(labelText.length - 1, 1)];
        self.lb.attributedText = tempString;
    }else {
        self.lb.text = labelText;
    }
    self.detailLb.text = detailLabelText;
    [self createPickerViewWithStrings:strings];
    self.valueSelected = valueSelected;
}

#pragma mark - Private method
- (void)createPickerViewWithURL:(NSString *)URLStr
                            key:(NSString *)key{
    
    [NetworkingTool GET:URLStr parameters:nil success:^(NSDictionary * _Nonnull responseObject) {
        
        NSMutableArray *mArr = [NSMutableArray new];
        for (NSDictionary *dic in responseObject) {
            [mArr addObject:dic[key]];
        }
        ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            self.detailLb.text = selectedValue;
            self.valueSelected(selectedValue, responseObject);
        };
        ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
            
        };
        
        self.stringPicker = [[ActionSheetStringPicker alloc] initWithTitle:self.lb.text rows:mArr initialSelection:0 doneBlock:done cancelBlock:cancel origin:self];
    }];
}

- (void)createPickerViewWithStrings:(NSArray *)strings {
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.detailLb.textColor = HexColor(@"#333333");
        self.detailLb.text = selectedValue;
        self.valueSelected(selectedValue, nil);
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        
    };
    
    NSMutableString *titleStr = [self.lb.text mutableCopy];
    NSRange lastRange = NSMakeRange(titleStr.length - 1, 1);
    NSString *lastChar = [titleStr substringWithRange:lastRange];
    if ([lastChar isEqualToString:@"*"]) {
        [titleStr replaceCharactersInRange:lastRange withString:@""];
    }
    
    self.stringPicker = [[ActionSheetStringPicker alloc] initWithTitle:titleStr rows:strings initialSelection:0 doneBlock:done cancelBlock:cancel origin:self];
}

@end
