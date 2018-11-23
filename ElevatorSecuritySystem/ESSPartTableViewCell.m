//
//  ESSPartTableViewCell.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/4.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSPartTableViewCell.h"
#import "ESSSubPartTableViewCell.h"

#import "ESSPartReplacementFormController.h"

@implementation ESSPartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 13;
    self.bgView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgView.layer.shadowRadius = 6;
    self.bgView.layer.shadowOpacity = 0.4f;

    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSSubPartTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSSubPartTableViewCell class])];
    self.tableViewHeightConstraint.constant = 30;
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

- (void)setPartReplacemen:(NSMutableArray<ESSPartReplacemenModel *> *)PartReplacemen {
    if (_PartReplacemen != PartReplacemen) {
        _PartReplacemen = PartReplacemen;
    }
    
    self.lb.font = [UIFont systemFontOfSize:13];
    self.lb.textColor = HexColor(@"999999");
    
    self.bgView.layer.cornerRadius = 0;
    self.bgView.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgView.layer.shadowRadius = 0;
    self.bgView.layer.shadowOpacity = 0;
    
    self.addPartBtn.hidden = YES;
    self.topConstraint.constant = 9;
    self.btnHeightConstraint.constant = 0;
    self.btnLeadingConstraint.constant = 6;
    self.btnTrailingConstraint.constant = 6;
    self.tableViewHeightConstraint.constant = 30 + 30 * self.PartReplacemen.count;
    
    [self.tableView reloadData];
}

- (IBAction)AddPartClicked:(UIButton *)sender {
    ESSPartReplacementFormController *vc = [ESSPartReplacementFormController new];
    vc.submited = ^(NSMutableArray<ESSPartReplacemenModel *> *PartReplacemen) {
        self.PartReplacemen = PartReplacemen;
        self.tableViewHeightConstraint.constant = 30 + 30 * self.PartReplacemen.count;
        [self.tableView reloadData];
        self.dataArrived(self.PartReplacemen);
    };
    vc.PartReplacemen = self.PartReplacemen;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.PartReplacemen.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ESSSubPartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSSubPartTableViewCell class])];
    ESSPartReplacemenModel *model = self.PartReplacemen[indexPath.row];
    cell.modelLb.text = model.Model;
    cell.numberLb.text = model.Number;
    cell.unitPriceLb.text = model.UnitPrice;
    float totalAmount = 0;
    for (ESSPartReplacemenModel *model in self.PartReplacemen) {
        totalAmount += [model.Total floatValue];
    }
    self.totalLb.text = [NSString stringWithFormat:@"总金额：%.2f元",totalAmount];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ESSSubPartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSSubPartTableViewCell class])];
    cell.backgroundColor = HexColor(@"EEEEEE");
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

@end
