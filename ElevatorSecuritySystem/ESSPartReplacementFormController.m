//
//  ESSPartReplacementFormController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/5.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSPartReplacementFormController.h"
#import "ESSPartReplacementFormTableViewCell.h"
#import "ESSSubmitButton.h"

@interface ESSPartReplacementFormController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLb;
@property (strong, nonatomic) ESSSubmitButton *submitBtn;

@end

@implementation ESSPartReplacementFormController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"零部件更换清单";
    
    UIBarButtonItem *item = [UIBarButtonItem itemWithTitle:@"添加一组" image:nil highImage:@"" target:self action:@selector(barButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = item;
    
    if (!self.PartReplacemen) {
        self.PartReplacemen = [@[[ESSPartReplacemenModel new]] mutableCopy];
    }
    float totalAmount = 0;
    for (ESSPartReplacemenModel *model in self.PartReplacemen) {
        totalAmount += [model.Total floatValue];
    }
    self.totalAmountLb.text = [NSString stringWithFormat:@"总金额：%.2f元",totalAmount];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSPartReplacementFormTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSPartReplacementFormTableViewCell class])];
    
    self.submitBtn = [ESSSubmitButton buttonWithTitle:@"确定" selecter:@selector(submitBtnClicked:)];
    [self.view addSubview:self.submitBtn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.PartReplacemen.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ESSPartReplacementFormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSPartReplacementFormTableViewCell class])];
    cell.model = self.PartReplacemen[indexPath.row];
    cell.deleteBtnClicked = ^{
        [self.PartReplacemen removeObjectAtIndex:indexPath.row];
        float totalAmount = 0;
        for (ESSPartReplacemenModel *model in self.PartReplacemen) {
            totalAmount += [model.Total floatValue];
        }
        self.totalAmountLb.text = [NSString stringWithFormat:@"总金额：%.2f元",totalAmount];
        if (self.PartReplacemen.count == 0) {
            [self.PartReplacemen addObject:[ESSPartReplacemenModel new]];
        }
        [self.tableView reloadData];
    };
    cell.textFieldTextChanged = ^(ESSPartReplacemenModel *model) {
        [self.PartReplacemen replaceObjectAtIndex:indexPath.row withObject:model];
        float totalAmount = 0;
        for (ESSPartReplacemenModel *model in self.PartReplacemen) {
            totalAmount += [model.Total floatValue];
        }
        self.totalAmountLb.text = [NSString stringWithFormat:@"总金额：%.2f元",totalAmount];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *uv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    UIView *line = [UILabel new];
    line.backgroundColor = HexColor(@"EBEBEB");
    [uv addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(uv.mas_centerY);
        make.left.equalTo(uv.mas_left).offset(15);
        make.right.equalTo(uv.mas_right);
        make.height.equalTo(@1);
    }];
    return uv;
}

- (void)barButtonItemClicked:(UIBarButtonItem *)item {
    [self.PartReplacemen addObject:[ESSPartReplacemenModel new]];
    [self.tableView reloadData];
}

- (void)submitBtnClicked:(ESSSubmitButton *)submitBtn {
    [self.navigationController popViewControllerAnimated:YES];
    self.submited(self.PartReplacemen);
}

@end
