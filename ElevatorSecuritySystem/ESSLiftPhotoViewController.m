//
//  ESSLiftPhotoViewController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/5/15.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSLiftPhotoViewController.h"
#import "ESSPhotoView.h"


@interface ESSLiftPhotoViewController ()

@property (nonatomic,strong) NSArray *dataSource;
@end

@implementation ESSLiftPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"图片资料";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self downloadData];
    
}

- (void)downloadData{
    
    if (!(self.LiftCode.length > 0)) {
        return;
    }
    NSDictionary *dict = @{@"LiftCode":self.LiftCode};
    [NetworkingTool GET:@"/APP/Elev_BasicInfo/GetPicInfo" parameters:dict success:^(NSDictionary * _Nonnull responseObject) {
        self.dataSource = responseObject[@"data"][@"TechPics"];
        if (_dataSource.count > 0) {
            
            ESSPhotoView *view =  [[ESSPhotoView alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 200) title:@"技术资料图片" images:self.dataSource];

            [self.view addSubview:view];
        }
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        NSDictionary *dict = [responseObject objectForKey:@"data"];
        [array addObject:dict[@"CarInteriorPhoto"]];
        [array addObject:dict[@"CarTopPhoto"]];
        [array addObject:dict[@"MachineRoomPhoto"]];
        
        ESSPhotoView *view =  [[ESSPhotoView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 200) title:@"机房、轿顶、轿内照片" images:array];
        [self.view addSubview:view];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
