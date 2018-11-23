//
//  MyView.m
//  alertDemo
//
//  Created by cz q on 2018/7/7.
//  Copyright © 2018年 cz q. All rights reserved.
//

#import "ESSCustomAlertView.h"
#import "UIButton+Add.h"


@implementation ESSCustomAlertView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.successBtn.selected = YES;
    _tmpBtn = _successBtn;
    CGFloat width = SCREEN_WIDTH - 100 - 48 - 58 - 18;
    
    [self.successBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:width];
    [self.failBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:width];
}


- (IBAction)successBtnEvent:(UIButton *)sender {
    
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
    }
    else if (_tmpBtn !=nil && _tmpBtn == sender){
        sender.selected = YES;
    }
    else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
     }

    if (sender == _successBtn) {
        NSLog(@"成功");
        _result = 1;
    }else {
        NSLog(@"失败");
        _result = 0;
    }
    [self.contentLb resignFirstResponder];
    
}
- (IBAction)confirmBtnEvent:(id)sender {

    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if (_result == 1) {  
        [dict setValue:@"救援成功" forKey:@"result"];
    }else if (_result == 0){
        [dict setValue:@"救援失败" forKey:@"result"];
    }
    
    
    if (sender == _cancelBtn) {// 0  取消   1 确认
        [dict setValue:@"0" forKey:@"state"];
        _contentLb.text = nil;
    }else if (sender == _confirmBtn){
        [dict setValue:@"1" forKey:@"state"];
    }

    [dict setValue:_contentLb.text forKey:@"remark"];
    self.callBack(dict);
}


@end
