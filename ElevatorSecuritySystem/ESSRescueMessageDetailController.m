//
//  ESSRescueMessageDetailController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/3/9.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSRescueMessageDetailController.h"

@interface ESSRescueMessageDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *messageTypeLb;
@property (weak, nonatomic) IBOutlet UILabel *mssageContentLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UILabel *messageLb;

@end

@implementation ESSRescueMessageDetailController


- (instancetype)initWithUserInfo:(NSDictionary *)userInfo {
    
    if (self) {
        self.userInfo = userInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.backgroundColor = MAINCOLOR;
    
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [settingButton addTarget:self action:@selector(settingButtonOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setTitle:@"刷新" forState:UIControlStateNormal];
    settingButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"nav_back_pre"] forState:UIControlStateHighlighted];

    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self setData];
}

- (void)backBtnClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setData {
    
    self.messageTypeLb.text = [NSString stringWithFormat:@"[%@]",self.userInfo[@"InfoType"]]; 
    self.mssageContentLb.text = self.userInfo[@"Title"];;
    self.messageLb.text = self.userInfo[@"Content"];
    
}

- (void)settingButtonOnClicked {
    [self setData];
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
