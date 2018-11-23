//
//  ESSTextViewTableViewCell.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/2.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSTextViewTableViewCell.h"

@implementation ESSTextViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.textView.layer.borderColor = rgb(208, 208, 208).CGColor;
    self.textView.layer.borderWidth = 0.5f;
    
    self.textView.placeholderTextColor = HexColor(@"999999");
    self.textView.delegate = self;
}

- (void)setLbText:(NSString *)lbText {
    NSString *lastChar = [lbText substringFromIndex:lbText.length - 1];
    if ([lastChar isEqualToString:@"*"]) {
        NSMutableAttributedString * tempString = [[NSMutableAttributedString alloc] initWithString: lbText];
        [tempString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(lbText.length - 1, 1)];
        self.lb.attributedText = tempString;
    }else {
        self.lb.text = lbText;
    }
}

- (NSString *)tvText {
    return self.textView.text;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.textViewTextChanged(textView.text);
}

@end
