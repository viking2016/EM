//
//  ESSLiftInfoCollectionController.m
//  ElevatorMaintenanceAssistant
//
//  Created by 刘树龙 on 17/3/8.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co., Ltd. All rights reserved.
//

#import "ESSLiftInfoCollectionController.h"

#import "ESSTextFieldTableViewCell.h"
#import "ESSMapPickerTableViewCell.h"
#import "ESSStringPickerTableViewCell.h"
#import "ESSDatePickerTableViewCell.h"

#import "EMAElevatorInfoCollectionModel.h"

@interface ESSLiftInfoCollectionController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ESSSubmitButton *submitBtn;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) EMAElevatorInfoCollectionModel *model;

@end

@implementation ESSLiftInfoCollectionController

#pragma mark - Public Method

- (instancetype)initWithRegCode:(NSString *)regCode {
    self = [super init];
    if (self) {
        self.regCode = regCode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.model = [[EMAElevatorInfoCollectionModel alloc] init];
    [self.navigationItem setTitle:@"新增电梯"];
    
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithTitle:@"返回" image:@"nav_back" highImage:@"nav_back_pre" target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.view = _tableView;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:EMATextFieldTableViewCellName bundle:nil] forCellReuseIdentifier:EMATextFieldTableViewCellName];
    [self.tableView registerNib:[UINib nibWithNibName:EMAMapPickerTableViewCellName bundle:nil] forCellReuseIdentifier:EMAMapPickerTableViewCellName];
    [self.tableView registerNib:[UINib nibWithNibName:EMAStringPickerTableViewCellName bundle:nil] forCellReuseIdentifier:EMAStringPickerTableViewCellName];
    [self.tableView registerNib:[UINib nibWithNibName:EMADatePickerTableViewCellName bundle:nil] forCellReuseIdentifier:EMADatePickerTableViewCellName];

    UIView *uv = [UIView new];
    uv.frame = CGRectMake(0, 0, SCREEN_WIDTH, 74);
    self.tableView.tableFooterView = uv;
    self.submitBtn = [ESSSubmitButton buttonWithTitle:@"确认添加" selecter:@selector(submitBtnClick:)  y:10];
    [uv addSubview:_submitBtn];
}

- (void)back {
    __block BOOL hasValue;
    __block int i = 0;
    NSDictionary *tmpDic = [self.model mj_keyValues];
    [[tmpDic allValues] enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.length) {
            i++;
            if (i > 1) {
                hasValue = YES;
                *stop = YES;
            }
        }
    }];
    if (hasValue) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"如果确认返回，操作的数据将会消失！" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:confirm];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Private Method
- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[@"项目名称",@"注册代码",@"地图标注",@"电梯类型",@"使用单位内部编号",@"上次半月维保日期",@"上次年检日期"];
    }
    return _dataArr;
}

- (void)submitBtnClick:(UIButton *)btn {
    NSDictionary *tmpDic = [self.model mj_keyValues];
    if (tmpDic.count == 9) {
        NSMutableDictionary *paras = [NSMutableDictionary new];
        NSString *strJson = [tmpDic mj_JSONString];
        [paras setValue:strJson forKey:@"ElevJson"];
        
        [SVProgressHUD show];
        [ESSNetworkingTool POST:@"/APP/WB/Elev_Info/Save" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"新增成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getHomeData" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }else {
        [SVProgressHUD showInfoWithStatus:@"您有未填的信息！请检查"];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            ESSStringPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EMAStringPickerTableViewCellName forIndexPath:indexPath];
            [cell setLabelText:_dataArr[indexPath.row]
               detailLabelText:_model.Name
                           URL:@"/APP/WB/Elev_Info/GetProject"
                           key:@"Name"
                 valueSelected:^(NSString *value, id response) {
                     for (NSDictionary *dic in response) {
                         if (dic[@"Name"] == value) {
                             _model.Name = dic[@"Name"];
                             _model.ProjectID = dic[@"Code"];
                             break;
                         }
                     }
            }];
            return cell;
        }
            break;
        case 1:
        {
            ESSTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EMATextFieldTableViewCellName forIndexPath:indexPath];
            cell.tf.userInteractionEnabled = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.model.RegNo = self.regCode;
            [cell setLabelText:self.dataArr[indexPath.row] textFieldText:self.regCode placeholder:nil keyboardType:UIKeyboardTypeDefault textAlignment:NSTextAlignmentRight textFieldTextChanged:^(NSString *value) {
            }];
            return cell;
        }
            break;
        case 2:
        {
            ESSMapPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EMAMapPickerTableViewCellName forIndexPath:indexPath];
            __block ESSMapPickerTableViewCell *blockSelf = cell;
            [cell setLabelText:_dataArr[indexPath.row] detailLabelText:@"点击标注位置" valueSelected:^(RWLocation *value) {
                _model.Lng = value.longitude;
                _model.Lat = value.latitude;
                blockSelf.detailLb.text = @"重新标注选点";
            }];
            return cell;
        }
            break;
        case 3://电梯类型 选择
        {
            ESSStringPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EMAStringPickerTableViewCellName forIndexPath:indexPath];
            [cell setLabelText:_dataArr[indexPath.row]
               detailLabelText:_model.ElevType URL:@"/APP/WB/Elev_Info/GetElevType"
                           key:@"Name"
                 valueSelected:^(NSString *value, id response) {
                _model.ElevType = value;
            }];
            return cell;
        }
            break;
        case 4:
        {
            ESSTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EMATextFieldTableViewCellName forIndexPath:indexPath];
            [cell setLabelText:self.dataArr[indexPath.row] textFieldText:_model.InnerNo placeholder:nil keyboardType:UIKeyboardTypeDefault textAlignment:NSTextAlignmentRight textFieldTextChanged:^(NSString *value) {
                _model.InnerNo = value;
            }];
            return cell;
        }
            break;
        case 5:
        {
            ESSDatePickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EMADatePickerTableViewCellName forIndexPath:indexPath];
            [cell setLabelText:_dataArr[indexPath.row] detailLabelText:_model.NextMMDate pickerDateFormate:UIDatePickerModeDate showDateFormate:@"yyyy-MM-dd" valueSelected:^(NSString *value) {
                _model.NextMMDate = value;
            }];
            return cell;
        }
            break;
        default:
        {
            ESSDatePickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EMADatePickerTableViewCellName forIndexPath:indexPath];
            [cell setLabelText:_dataArr[indexPath.row] detailLabelText:_model.NextAnnualDate pickerDateFormate:UIDatePickerModeDate showDateFormate:@"yyyy-MM-dd" valueSelected:^(NSString *value) {
                _model.NextAnnualDate = value;
            }];
            return cell;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
