//
//  ESSChuZhiFanKuiController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/31.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSChuZhiFanKuiController.h"
#import "SZTextView.h"
#import "ESSSelectFaultTypeController.h"
#import "ESSSelectFaultReasonController.h"
#import "ESSChuZhiFanKuiCell.h"
@interface ESSChuZhiFanKuiController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSString *faultType;
@property (nonatomic,strong) NSString *faultCode;
@property (nonatomic,strong) NSString *faultReason;
@property (nonatomic,strong) NSString *FaultAnalysis;
@property (nonatomic,strong) SZTextView *textView;


@end

@implementation ESSChuZhiFanKuiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];
}

- (instancetype)initWithRescueId:(NSString *)rescueId{
    self = [super init];
    if (self) {
        self.rescueId = rescueId;
    }
    return self;
}

- (void)createUI {
    
    self.navigationItem.title = @"处置反馈";
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(16, 20, 86, 20)];
    lab.text = @"故障类别：";
    lab.textColor = RGBA(51, 51, 51, 1);
    lab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:lab];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 60;//估算高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    UIView *footerView = [[UIView alloc]init];
    footerView.height = 180;
    _tableView.tableFooterView = footerView;

    
    UILabel *beiZhuLab = [[UILabel alloc]initWithFrame:CGRectMake(16, 29, 60, 20)];
    beiZhuLab.textColor = RGBA(51, 51, 51, 1);
    beiZhuLab.text = @"备注：";
    beiZhuLab.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:beiZhuLab];
    
    _textView = [[SZTextView alloc]initWithFrame:CGRectMake(16, 70, SCREEN_WIDTH-32, 132)];
    [footerView addSubview:_textView];
    _textView.placeholder = @"请在此输入备注...";
    _textView.layer.borderWidth = 0.5;
    _textView.layer.cornerRadius = 2;
    _textView.layer.borderColor = RGBA(242, 242, 242, 1).CGColor;
    _textView.userInteractionEnabled = YES;
    _textView.font = [UIFont systemFontOfSize:13];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(0, SCREEN_HEIGHT-39-64, SCREEN_WIDTH, 39);
    [self.view addSubview:submitBtn];
    submitBtn.backgroundColor = MAINCOLOR;
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)submitBtnClick {
    
    if (!(self.FaultAnalysis.length > 0)) {
        [SVProgressHUD showInfoWithStatus:@"请选择故障原因"];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:self.rescueId forKey:@"TaskID"];
    [parameters setValue:self.FaultAnalysis forKey:@"FaultAnalysis"];
    [parameters setValue:self.textView.text forKey:@"Result"];
    [ESSNetworkingTool POST:@"/APP/Rescue_WorkOrderTask/SubmitFeedback" parameters:parameters success:^(NSDictionary * _Nonnull responseObject) {
        
        if ([[responseObject objectForKey:@"isOk"]boolValue]) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
            self.submitCallback(@"success");

        }
    }];
}

#pragma mark -- tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"ESSChuZhiFanKuiCell";
    ESSChuZhiFanKuiCell * cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"ESSChuZhiFanKuiCell" owner:self options:nil]lastObject];
    }
    if (indexPath.row == 0) {
        
        if (!(self.faultType.length > 0)) {
            cell.contentLb.text = @"请选择";
            cell.contentLb.textColor = RGBA(153, 153, 153, 1);
        }else{
            cell.contentLb.text = self.faultType;
            cell.contentLb.textColor = RGBA(51, 51, 51, 1);
        }
    }else if(indexPath.row == 1){
        if (!(self.faultReason.length > 0)) {
            cell.contentLb.text = @"请选择";
            cell.contentLb.textColor = RGBA(153, 153, 153, 1);
        }else{
            cell.contentLb.text = self.faultReason;
            cell.contentLb.textColor = RGBA(51, 51, 51, 1);
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        ESSSelectFaultTypeController *vc = [ESSSelectFaultTypeController new];
//        vc.basicInfoID = self.model.BasicInfoID;
        vc.block = ^(NSString *str, NSString *code) {
            self.faultCode = [NSString stringWithFormat:@"%@",code];
            self.faultType = str;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1) {
//        ESSSelectFaultReasonController *vc = [ESSSelectFaultReasonController new];
//        vc.code = self.model.FailureCause;
//        vc.block = ^(NSString *str, NSString *code) {
//            self.faultReason  = str;
//            self.FaultAnalysis = code;
//            [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
//        };
//        if (self.model.FailureCause) {
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        else
//        {
//            [SVProgressHUD showInfoWithStatus:@"请选择故障原因"];
//        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
