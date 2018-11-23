//
//  LocationPickerController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/7/25.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import "LocationPickerController.h"

static NSString *const getProvince = @"/APP/ProvinceCityArea/GetProvince";// 获取省列表接口

static NSString *const getCity = @"/APP/ProvinceCityArea/GetCity";// 获取市列表接口

static NSString *const getCounty = @"/APP/ProvinceCityArea/GetCounty";// 获取区列表接口

static NSString *const getStreet = @"/APP/ProvinceCityArea/GetStreet";// 获取街道列表接口

typedef NS_ENUM(NSUInteger, LocationLevel) {
    ProvinceLevel,
    CityLevel,
    CountyLevel,
    StreetLevel,
};

@interface LocationPickerController ()

@property (assign, nonatomic) LocationLevel locationLevel;
@property (copy, nonatomic) NSString *url;
@property (strong, nonatomic) NSMutableDictionary *item;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *locationInfos;
@property (strong, nonatomic) NSMutableDictionary *resultDic;

@end

@implementation LocationPickerController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithStyle:(LocationPickerStyle)style valueSelected:(LocationPickerBlock)valueSelected {
    self = [super init];
    self.valueSelected = valueSelected;
    self.style = style;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    if (!_resultDic) {
        _resultDic = [[NSMutableDictionary alloc] init];
    }
}

- (NSMutableDictionary *)resultDic {
    if (!_resultDic) {
        _resultDic = [[NSMutableDictionary alloc] init];
    }
    return _resultDic;
}

- (NSMutableArray *)locationInfos {
    if (!_locationInfos) {
        _locationInfos = [[NSMutableArray alloc] init];
    }
    return _locationInfos;
}

- (NSMutableDictionary *)item {
    if (!_item) {
        _item = [[NSMutableDictionary alloc] init];
    }
    return _item;
}

- (NSString *)url {
    if (!_url) {
        _url = getProvince;
    }
    return _url;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        [ESSNetworkingTool GET:self.url parameters:self.item success:^(NSDictionary * _Nonnull responseObject) {
            _dataSource = responseObject[@"datas"];
            [self.tableView reloadData];
        }];
    }
    return _dataSource;
}

- (void)getDataSourceWithLocationLevel:(LocationLevel)level andURL:(NSString *)url andIndexPath:(NSIndexPath *)indexPath andKey:(NSString *)key {
    
    [self.locationInfos addObject:_dataSource[indexPath.row][@"Name"]];

    LocationPickerController *picker = [[LocationPickerController alloc] initWithStyle:_style valueSelected:nil];
    picker.resultDic = _resultDic;
    picker.locationInfos = _locationInfos;
    picker.locationLevel = level;
    picker.url = url;
    [picker.item setValue:_dataSource[indexPath.row][@"Code"] forKey:key];
    
    [ESSNetworkingTool GET:picker.url parameters:picker.item success:^(NSDictionary * _Nonnull responseObject) {
        picker.dataSource = responseObject[@"datas"];
        
        if (!picker.dataSource.count) {// 返回控制器
            [self popToParentController];
        }else {// 前进到下一控制器
            [self.navigationController pushViewController:picker animated:YES];
        }
    }];
}

- (void)popToParentController {
    [_resultDic setValue:[self.locationInfos componentsJoinedByString:@""] forKey:@"Address"];
    NSArray *viewControllers = self.navigationController.viewControllers;
    NSInteger index = viewControllers.count - self.locationLevel - 2;
    LocationPickerController *vc = viewControllers[index + 1];
    vc.valueSelected(_resultDic);
    [self.navigationController popToViewController:viewControllers[index] animated:YES];
}

#pragma mark tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = _dataSource[indexPath.row][@"Name"];
    return cell;
}

#pragma mark tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (self.locationLevel) {
        case ProvinceLevel:
        {
            [self.resultDic setValue:_dataSource[indexPath.row][@"Code"] forKey:@"Province"];
            [self getDataSourceWithLocationLevel:CityLevel andURL:getCity andIndexPath:indexPath andKey:@"ProvinceCode"];

            if ((LocationPickerStyle)ProvinceLevel == _style) {
                [self popToParentController];
            }
        }
            break;
        case CityLevel:
        {
            [self.resultDic setValue:_dataSource[indexPath.row][@"Code"] forKey:@"City"];
            [self getDataSourceWithLocationLevel:CountyLevel andURL:getCounty andIndexPath:indexPath andKey:@"CityCode"];
            if ((LocationPickerStyle)CityLevel == _style) {
                [self popToParentController];
            }
        }
            break;
        case CountyLevel:
        {
            [self.resultDic setValue:_dataSource[indexPath.row][@"Code"] forKey:@"County"];
            [self getDataSourceWithLocationLevel:StreetLevel andURL:getStreet andIndexPath:indexPath andKey:@"CountyCode"];

            if ((LocationPickerStyle)CountyLevel == _style) {
                [self popToParentController];
            }
        }
            break;
        case StreetLevel:
        {
            [self.locationInfos addObject:_dataSource[indexPath.row][@"Name"]];
            [_resultDic setValue:_dataSource[indexPath.row][@"Code"] forKey:@"Street"];
            [self popToParentController];
        }
            break;
        default:
            break;
    }
}

- (void)dealloc {
    [self.locationInfos removeLastObject];
}
@end
