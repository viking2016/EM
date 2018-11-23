//
//  ESSMaintenanceItemsCell.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/11/29.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import "ESSMaintenanceItemsCell.h"

@interface ESSMaintenanceItemsCell()

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *detailView;

@end

@implementation ESSMaintenanceItemsCell
#pragma mark Public method
- (void)setMainLbText:(NSString *)text date:(NSString *)date detailLbText:(NSString *)detailText result:(NSString *)result valueSelected:(void (^)(NSString *))valueSelected {
    if ([result isEqualToString:@"正常"]) {
        self.normalBtn.selected = YES;
        self.otherBtn.selected = NO;
        [self.otherBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
    }else if ([result isEqualToString:@"异常"]) {
        self.normalBtn.selected = NO;
        self.otherBtn.selected = YES;
        [self.otherBtn setTitle:result forState:UIControlStateSelected];
        [self.otherBtn setImage:[UIImage imageNamed:@"icon_red_yichang"] forState:UIControlStateSelected];
        [self.otherBtn setTitleColor:RGBA(235, 54, 54, 1) forState:UIControlStateSelected];
        [self.otherBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
    }else if([result isEqualToString:@"可调整"]) {
        self.normalBtn.selected = NO;
        self.otherBtn.selected = YES;
        [self.otherBtn setTitle:result forState:UIControlStateSelected];
        [self.otherBtn setImage:[UIImage imageNamed:@"icon_yy_ketiao"] forState:UIControlStateSelected];
        [self.otherBtn setTitleColor:RGBA(255, 163, 2, 1) forState:UIControlStateSelected];
        [self.otherBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
    }else if ([result isEqualToString:@"无此项"]) {
        self.normalBtn.selected = NO;
        self.otherBtn.selected = YES;
        [self.otherBtn setTitle:result forState:UIControlStateSelected];
        [self.otherBtn setImage:[UIImage imageNamed:@"icon_an_wu"] forState:UIControlStateSelected];
        [self.otherBtn setTitleColor:RGBA(137, 153, 163, 1) forState:UIControlStateSelected];
        [self.otherBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
    }else {
        self.normalBtn.selected = NO;
        self.otherBtn.selected = NO;
    }
    self.mainLb.text = text;
    self.dateLb.text = date;
    self.detailLb.text = detailText;
    self.valueSelected = valueSelected;
}

#pragma mark Private method
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.normalBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [self.otherBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
    
    [self.contentView insertSubview:self.mainView aboveSubview:self.detailView];
}

- (IBAction)normalBtnClick:(UIButton *)sender {
    if (!sender.isSelected) {
        sender.selected = !sender.selected;
        self.otherBtn.selected = !sender.selected;
        self.valueSelected(@"正常");
    }
}

- (IBAction)otherBtnClick:(UIButton *)sender {
    UIAlertController *alertContrller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [self addAlertActionToAlertController:alertContrller WithTitle:@"异常" AndSender:sender];
    [self addAlertActionToAlertController:alertContrller WithTitle:@"可调整" AndSender:sender];
    [self addAlertActionToAlertController:alertContrller WithTitle:@"无此项" AndSender:sender];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertContrller addAction:cancelAction];
    
    [self.viewController presentViewController:alertContrller animated:YES completion:nil];
}

- (void)addAlertActionToAlertController:(UIAlertController *)alertController WithTitle:(NSString *)title AndSender:(UIButton *)sender {
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.valueSelected(action.title);
        if (!sender.isSelected) {
        }
    }];
    [alertController addAction:action];
}

@end
