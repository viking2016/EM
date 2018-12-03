//
//  ESSLiftChartController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/5/11.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSLiftChartController.h"
#import <PNChart.h>
#import <ActionSheetPicker.h>

@interface ESSLiftChartController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewWidth;

@property (weak, nonatomic) IBOutlet UIView *runCountChart;
@property (weak, nonatomic) IBOutlet UIView *openCountChart;
@property (weak, nonatomic) IBOutlet UIView *faultCountChart;
@property (nonatomic,strong) NSMutableArray *runCountArr;
@property (nonatomic,strong) NSMutableArray *openCountArr;
@property (nonatomic,strong) NSMutableArray *faultCountArr;
@property (nonatomic,strong) NSMutableArray *ChatXArray;

 
@property (nonatomic,strong)PNLineChart * runChart;
@property (nonatomic,strong)PNLineChart * openChart;
@property (nonatomic,strong)PNLineChart * faultChart;

@property (nonatomic,strong)PNLineChartData * data01;
@property (nonatomic,strong)PNLineChartData * data02;
@property (nonatomic,strong)PNLineChartData * data03;




@property (weak, nonatomic) IBOutlet UITextField *runTypeTF;
@property (weak, nonatomic) IBOutlet UITextField *runDateTF;
@property (weak, nonatomic) IBOutlet UITextField *openTypeTF;
@property (weak, nonatomic) IBOutlet UITextField *openDateTF;
@property (weak, nonatomic) IBOutlet UITextField *faultTypeTF;
@property (weak, nonatomic) IBOutlet UITextField *faultDateTF;

@property (strong, nonatomic) NSDate *runDate;
@property (strong, nonatomic) NSDate *openDate;
@property (strong, nonatomic) NSDate *faultDate;



@end

@implementation ESSLiftChartController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initChart];
    
    self.navigationItem.title = @"实时数据";
    self.runTypeTF.delegate = self;
    self.runDateTF.delegate = self;
    self.openTypeTF.delegate = self;
    self.openDateTF.delegate = self;
    self.faultTypeTF.delegate = self;
    self.faultDateTF.delegate = self;
    
    self.runTypeTF.tag = 20;
    self.runDateTF.tag = 21;
    self.openTypeTF.tag = 22;
    self.openDateTF.tag = 23;
    self.faultTypeTF.tag = 24;
    self.faultDateTF.tag = 25;
    
    self.runTypeTF.inputView = [UIView new];
    self.runDateTF.inputView = [UIView new];
    self.openTypeTF.inputView = [UIView new];
    self.openDateTF.inputView = [UIView new];
    self.faultTypeTF.inputView = [UIView new];
    self.faultDateTF.inputView = [UIView new];
}

- (void)initChart{
    
    self.ChatXArray = [NSMutableArray new];
    
    NSArray *yearArr = @[@"2",@"4",@"6",@"8",@"10",@"12"];
    NSArray *monthArr = @[@"5",@"10",@"15",@"20",@"25",@"30"];
    NSArray *dayArr = @[@"4",@"8",@"12",@"16",@"18",@"20",@"24"];
    [self.ChatXArray addObject:yearArr];
    [self.ChatXArray addObject:monthArr];
    [self.ChatXArray addObject:dayArr];

    self.runChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 152)];
    [_runChart setXLabels:self.ChatXArray[0]];
    [self getYearCountWithType:@"run" andDate:_runDateTF.text andURL:@"/APP/Count/GetYearRunLayersCount"];
    
    _data01 = [PNLineChartData new];
    _data01.color = PNFreshGreen;
    _data01.itemCount = _runChart.xLabels.count;
    
    [self.runCountChart addSubview:_runChart];

    _runChart.showSmoothLines = YES;
    _runChart.showCoordinateAxis = YES;
    _runChart.showYGridLines = YES;
    
    
    self.openChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 152)];
    [_openChart setXLabels:self.ChatXArray[0]];
    [self getYearCountWithType:@"open" andDate:_openDateTF.text andURL:@"/APP/Count/GetYearOpenDoorCount"];

    self.data02 = [PNLineChartData new];
    _data02.color = PNFreshGreen;
    _data02.itemCount = _openChart.xLabels.count;
    
    [self.openCountChart addSubview:_openChart];

    _openChart.showSmoothLines = YES;
    _openChart.showCoordinateAxis = YES;
    _openChart.showYGridLines = YES;

    
    _faultChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 152)];
    [_faultChart setXLabels:self.ChatXArray[0]];
    [self getYearCountWithType:@"fault" andDate:_faultDateTF.text andURL:@"/APP/Count/GetYearFaultCount"];

   self.data03 = [PNLineChartData new];
    _data03.color = PNFreshGreen;
    _data03.itemCount = _faultChart.xLabels.count;
    
    
    [self.faultCountChart addSubview:_faultChart];

    _faultChart.showSmoothLines = YES;
    _faultChart.showCoordinateAxis = YES;
    _faultChart.showYGridLines = YES;
    

    // 用来结局textField.text为中文，点击后向下移动的问题
    UIView *view_run = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    self.runTypeTF.leftView = view_run;
    self.runTypeTF.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *view_open = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    self.openTypeTF.leftView = view_open;
    self.openTypeTF.leftViewMode = UITextFieldViewModeAlways;
    UIView *view_fault = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    self.faultTypeTF.leftView = view_fault;
    self.faultTypeTF.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark --textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ((textField.tag == 20) | (textField.tag == 22) | (textField.tag == 24)){
        [ActionSheetStringPicker showPickerWithTitle:@"请选择类型"
                                                rows:@[@"年",@"月",@"日"]
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               textField.text = selectedValue;
                                               NSLog(@"textField.tag :  %ld,selectedValue :%@",textField.tag,selectedValue);
                                              //*******
                                               NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                               switch (textField.tag) {
                                                   case 21:
                                                   {
                                                       if ([_runTypeTF.text isEqualToString:@"年"]) {
                                                           [dateFormatter setDateFormat:@"yyyy"];
                                                           _runDateTF.text = [dateFormatter stringFromDate:self.runDate];
                                                           [self.runChart setXLabels:self.ChatXArray[0]];
                                                           [self getYearCountWithType:@"run" andDate:_runDateTF.text andURL:@"/APP/Count/GetYearRunLayersCount"];
                                                       }else if ([_runTypeTF.text isEqualToString:@"月"]){
                                                           [dateFormatter setDateFormat:@"yyyy-MM"];
                                                           _runDateTF.text = [dateFormatter stringFromDate:self.runDate];
                                                           [self.runChart setXLabels:self.ChatXArray[1]];

                                                           [self getMonthCountWithType:@"run" andDate:_runDateTF.text andURL:@"/APP/Count/GetMonthRunLayersCount"];
                                                       }else{
                                                           [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                                           _runDateTF.text = [dateFormatter stringFromDate:self.runDate];
                                                           [self.runChart setXLabels:self.ChatXArray[2]];

                                                           [self getDayCountWithType:@"run" andDate:_runDateTF.text andURL:@"/APP/Count/GetDayRunLayersCount"];
                                                       }
                                                   }
                                                       break;
                                                   case 23:
                                                   {
                                                       if ([_openTypeTF.text isEqualToString:@"年"]) {
                                                           [dateFormatter setDateFormat:@"yyyy"];
                                                           _openDateTF.text = [dateFormatter stringFromDate:self.openDate];
                                                           [self.openChart setXLabels:self.ChatXArray[0]];

                                                           [self getYearCountWithType:@"open" andDate:_openDateTF.text andURL:@"/APP/Count/GetYearOpenDoorCount"];
                                                           
                                                       }else if ([_openTypeTF.text isEqualToString:@"月"]){
                                                           [dateFormatter setDateFormat:@"yyyy-MM"];
                                                           _openDateTF.text = [dateFormatter stringFromDate:self.openDate];
                                                           [self.openChart setXLabels:self.ChatXArray[1]];

                                                           [self getMonthCountWithType:@"open" andDate:_openDateTF.text andURL:@"/APP/Count/GetMonthOpenDoorCount"];
                                                           
                                                       }else{
                                                           [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                                           textField.text = [dateFormatter stringFromDate:self.openDate];
                                                           [self.openChart setXLabels:self.ChatXArray[2]];

                                                           [self getDayCountWithType:@"open" andDate:_openDateTF.text andURL:@"/APP/Count/GetDayOpenDoorCount"];
                                                       }
                                                   }
                                                       break;
                                                   case 25:
                                                   {
                                                       if ([_faultTypeTF.text isEqualToString:@"年"]) {
                                                           [dateFormatter setDateFormat:@"yyyy"];
                                                           _faultTypeTF.text = [dateFormatter stringFromDate:self.faultDate];
                                                           [self.faultChart setXLabels:self.ChatXArray[0]];
                                                           
                                                           [self getYearCountWithType:@"fault" andDate:_faultTypeTF.text andURL:@"/APP/Count/GetYearFaultCount"];
                                                           
                                                       }else if ([_faultTypeTF.text isEqualToString:@"月"]){
                                                           [dateFormatter setDateFormat:@"yyyy-MM"];
                                                           _faultTypeTF.text = [dateFormatter stringFromDate:self.faultDate];
                                                           [self.faultChart setXLabels:self.ChatXArray[1]];
                                                           
                                                           [self getMonthCountWithType:@"fault" andDate:_faultTypeTF.text andURL:@"/APP/Count/GetMonthFaultCount"];
                                                           
                                                       }else{
                                                           [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                                           _faultTypeTF.text = [dateFormatter stringFromDate:self.faultDate];
                                                           [self.faultChart setXLabels:self.ChatXArray[2]];
                                                           
                                                           [self getDayCountWithType:@"fault" andDate:_faultTypeTF.text andURL:@"/APP/Count/GetDayFaultCount"];
                                                       }
                                                   }
                                                       break;
                                                   default:{
                                                       
                                                   }
                                                       break;
                                               }
                                               //*******
                                               [textField resignFirstResponder];
                                               //请求数据
                                           }
                                         cancelBlock:^(ActionSheetStringPicker *picker) {
                                             [textField resignFirstResponder];
                                         }
                                              origin:textField];
    }else if ((textField.tag == 21) | (textField.tag == 23) | (textField.tag == 25) ){
        [ActionSheetDatePicker showPickerWithTitle:@"请选择时间" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            switch (textField.tag) {
                case 21:
                {
                    self.runDate = selectedDate;
                    if ([_runTypeTF.text isEqualToString:@"年"]) {
                        [dateFormatter setDateFormat:@"yyyy"];
                        textField.text = [dateFormatter stringFromDate:selectedDate];
                        [self getYearCountWithType:@"run" andDate:textField.text andURL:@"/APP/Count/GetYearRunLayersCount"];
                    }else if ([_runTypeTF.text isEqualToString:@"月"]){
                        [dateFormatter setDateFormat:@"yyyy-MM"];
                        textField.text = [dateFormatter stringFromDate:selectedDate];
                        [self getMonthCountWithType:@"run" andDate:textField.text andURL:@"/APP/Count/GetMonthRunLayersCount"];
                    }else{
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        textField.text = [dateFormatter stringFromDate:selectedDate];
                        [self getDayCountWithType:@"run" andDate:textField.text andURL:@"/APP/Count/GetDayRunLayersCount"];
                    }
                }
                    break;
                case 23:
                {
                    self.openDate = selectedDate;

                    if ([_openTypeTF.text isEqualToString:@"年"]) {
                        [dateFormatter setDateFormat:@"yyyy"];
                        textField.text = [dateFormatter stringFromDate:selectedDate];
                        [self getYearCountWithType:@"open" andDate:textField.text andURL:@"/APP/Count/GetYearOpenDoorCount"];

                    }else if ([_openTypeTF.text isEqualToString:@"月"]){
                        [dateFormatter setDateFormat:@"yyyy-MM"];
                        textField.text = [dateFormatter stringFromDate:selectedDate];
                        [self getMonthCountWithType:@"open" andDate:textField.text andURL:@"/APP/Count/GetMonthOpenDoorCount"];

                    }else{
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        textField.text = [dateFormatter stringFromDate:selectedDate];
                        [self getDayCountWithType:@"open" andDate:textField.text andURL:@"/APP/Count/GetDayOpenDoorCount"];
                    }
                }
                    break;
                case 25:
                {
                    self.faultDate = selectedDate;
                    if ([_faultTypeTF.text isEqualToString:@"年"]) {
                        [dateFormatter setDateFormat:@"yyyy"];
                        textField.text = [dateFormatter stringFromDate:selectedDate];
                        [self getYearCountWithType:@"fault" andDate:textField.text andURL:@"/APP/Count/GetYearFaultCount"];
                        
                    }else if ([_faultTypeTF.text isEqualToString:@"月"]){
                        [dateFormatter setDateFormat:@"yyyy-MM"];
                        textField.text = [dateFormatter stringFromDate:selectedDate];
                        [self getMonthCountWithType:@"fault" andDate:textField.text andURL:@"/APP/Count/GetMonthFaultCount"];
                        
                    }else if ([_faultTypeTF.text isEqualToString:@"日"]){
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        textField.text = [dateFormatter stringFromDate:selectedDate];
                        [self getDayCountWithType:@"fault" andDate:textField.text andURL:@"/APP/Count/GetDayFaultCount"];
                    }  
                }
                    break;
                default:{
                    
                }
                    break;
            }
            [textField resignFirstResponder];
        } cancelBlock:^(ActionSheetDatePicker *picker) {
            [textField resignFirstResponder];
        } origin:textField];
    }
}

#pragma mark -- network
- (void)getYearCountWithType:(NSString *)type andDate:(NSString *)date andURL:(NSString *)url{
    if (!(self.LiftCode.length > 0)) {
        return;
    }
    NSDictionary *dict = @{@"LiftCode":self.LiftCode,@"Year":date};
    
    NSLog(@"请求一次url:%@  dict%@",url,dict);
    [NetworkingTool GET:url parameters:dict success:^(NSDictionary * _Nonnull responseObject) {
        NSLog(@"responseObject ：%@",responseObject);
        if ([[responseObject objectForKey:@"isOk"] boolValue]){
            self.runCountArr = [NSMutableArray new];
            for (NSDictionary *dict in [responseObject objectForKey:@"datas"]){
                [self.runCountArr addObject:dict[@"Value"]];
            }
            
            if ([type isEqualToString:@"run"]) {
                NSArray * data01Array = [self.runCountArr copy];
                _data01.getData = ^(NSUInteger index) {
                    CGFloat yValue = [data01Array[index] floatValue];
                    return [PNLineChartDataItem dataItemWithY:yValue];
                };
                _runChart.chartData = @[_data01];
                [_runChart strokeChart];
                NSLog(@"运行次数");
                
            }else if ([type isEqualToString:@"open"]){
                NSArray * data02Array = [self.runCountArr copy];
                _data02.getData = ^(NSUInteger index) {
                    CGFloat yValue = [data02Array[index] floatValue];
                    return [PNLineChartDataItem dataItemWithY:yValue];
                };
                
                _openChart.chartData = @[_data02];
                [_openChart strokeChart];
                NSLog(@"开关次数");
            }else{
                NSArray * data03Array = [self.runCountArr copy];
                _data03.getData = ^(NSUInteger index) {
                    CGFloat yValue = [data03Array[index] floatValue];
                    return [PNLineChartDataItem dataItemWithY:yValue];
                };
                
                _faultChart.chartData = @[_data03];
                [_faultChart strokeChart];
                NSLog(@"故障次数");
            }
        }
    }];
}

- (void)getMonthCountWithType:(NSString *)type andDate:(NSString *)date andURL:(NSString *)url{
    if (!(self.LiftCode.length > 0)) {
        return;
    }
    NSDictionary *dict = @{@"LiftCode":self.LiftCode,@"Month":date};
    [NetworkingTool GET:url parameters:dict success:^(NSDictionary * _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"isOk"] boolValue]){
            self.openCountArr = [NSMutableArray new];
            for (NSDictionary *dict in [responseObject objectForKey:@"datas"]){
                [self.openCountArr addObject:dict[@"Value"]];
            }
            if ([type isEqualToString:@"run"]) {
                NSArray * data01Array = [self.runCountArr copy];
                [_runChart setXLabels:self.ChatXArray[1]];

                _data01.getData = ^(NSUInteger index) {
                    CGFloat yValue = [data01Array[index] floatValue];
                    return [PNLineChartDataItem dataItemWithY:yValue];
                };
                _runChart.chartData = @[_data01];
                [_runChart strokeChart];
                
            }else if ([type isEqualToString:@"open"]){
                NSArray * data02Array = [self.runCountArr copy];
                [_openChart setXLabels:self.ChatXArray[1]];
                _data02.getData = ^(NSUInteger index) {
                    CGFloat yValue = [data02Array[index] floatValue];
                    return [PNLineChartDataItem dataItemWithY:yValue];
                };
                
                _openChart.chartData = @[_data02];
                [_openChart strokeChart];
                
            }else if ([type isEqualToString:@"fault"]){
                NSArray * data03Array = [self.runCountArr copy];
                [_faultChart setXLabels:self.ChatXArray[1]];
                _data03.getData = ^(NSUInteger index) {
                    CGFloat yValue = [data03Array[index] floatValue];
                    return [PNLineChartDataItem dataItemWithY:yValue];
                };
                
                _faultChart.chartData = @[_data03];
                [_faultChart strokeChart];
            }
        }
    }];
}

- (void)getDayCountWithType:(NSString *)type andDate:(NSString *)date andURL:(NSString *)url{
    if (!(self.LiftCode.length > 0)) {
        return;
    }
    NSDictionary *dict = @{@"LiftCode":self.LiftCode,@"Date":date};
    [NetworkingTool GET:url parameters:dict success:^(NSDictionary * _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"isOk"] boolValue]){
            self.faultCountArr = [NSMutableArray new];
            for (NSDictionary *dict in [responseObject objectForKey:@"datas"]){
                [self.faultCountArr addObject:dict[@"Value"]];
            }
            
            if ([type isEqualToString:@"run"]) {
                NSArray * data01Array = [self.runCountArr copy];
                [_runChart setXLabels:self.ChatXArray[2]];
                _data01.getData = ^(NSUInteger index) {
                    CGFloat yValue = [data01Array[index] floatValue];
                    return [PNLineChartDataItem dataItemWithY:yValue];
                };
                _runChart.chartData = @[_data01];
                [_runChart strokeChart];
                
            }else if ([type isEqualToString:@"open"]){
                NSArray * data02Array = [self.runCountArr copy];
                [_openChart setXLabels:self.ChatXArray[2]];
                _data02.getData = ^(NSUInteger index) {
                    CGFloat yValue = [data02Array[index] floatValue];
                    return [PNLineChartDataItem dataItemWithY:yValue];
                };
                
                _openChart.chartData = @[_data02];
                [_openChart strokeChart];
                
            }else if ([type isEqualToString:@"fault"]){
                NSArray * data03Array = [self.runCountArr copy];
                [_faultChart setXLabels:self.ChatXArray[2]];
                _data03.getData = ^(NSUInteger index) {
                    CGFloat yValue = [data03Array[index] floatValue];
                    return [PNLineChartDataItem dataItemWithY:yValue];
                };
                
                _faultChart.chartData = @[_data03];
                [_faultChart strokeChart];
            }
        }
    }];
    
}

- (NSInteger)judgeDateType:(NSString *)dateStr{
    if([dateStr rangeOfString:@"-"].location !=NSNotFound){//月
        return 0;
    }else if([dateStr rangeOfString:@"--"].location !=NSNotFound){//日
        return 1;
    }else{//年
        return -1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
