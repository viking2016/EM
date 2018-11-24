//
//  ESSSubmitController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/31.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSSubmitController.h"

#import "ESSPhotoCell.h"
#import "SZTextView.h"
#import <TZImagePickerController.h>
#import <TZImageManager.h>
#import <AFNetworking.h>
@interface ESSSubmitController ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) SZTextView *textView;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;


@end

@implementation ESSSubmitController

- (instancetype)initWithRescueId:(NSString *)rescueId{
    self = [super init];
    if (self) {
        self.rescueId = rescueId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"事件上报";
    self.dataArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.textView = [[SZTextView alloc]init];
    [self.view addSubview:_textView];
    _textView.placeholder = @"请在此输入事件详情...";
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.mas_equalTo(169);
    }];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    CGFloat _margin = 16;
    CGFloat  _itemWH = (SCREEN_WIDTH-62)/4;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
//    layout.minimumInteritemSpacing = _margin;
//    layout.minimumLineSpacing = _margin;
//    _collectionView.collectionViewLayout = layout;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(16, 189, SCREEN_WIDTH-32, SCREEN_HEIGHT-64-189-40) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
//    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(16);
//        make.right.equalTo(self.view.mas_right).offset(-16);
//        make.top.equalTo(self.view.mas_top).offset(189);
//        make.bottom.equalTo(self.view.mas_bottom).offset(0);
//
//    }];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

     [self.collectionView registerNib:[UINib nibWithNibName:@"ESSPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"ESSPhotoCell"];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:submitBtn];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.backgroundColor = MAINCOLOR;
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(39);
        
    }];
    
}

- (void)submitBtnClick {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (!(_textView.text.length > 0)) {
        [SVProgressHUD showInfoWithStatus:@"请输入事件详情"];
        return;
    }
    [parameters setValue:_textView.text forKey:@"Remark"];
    [parameters setValue:self.rescueId forKey:@"AlarmOrderTaskID"];

    
    NSMutableDictionary *mDic = [NSMutableDictionary new];
    NSDictionary *loginInfo = [ESSLoginTool getLoginInfo];
    NSDictionary *userInfo = [ESSLoginTool getUserInfo];
    if (userInfo) {
        NSString *token = userInfo[@"Token"];
        [parameters setObject:token forKey:@"Token"];
    }
    if (loginInfo) {
        NSString *tel = loginInfo[@"YongHuMing"];
        [parameters setObject:tel forKey:@"YongHuMing"];
    }
    
    [parameters setObject:[[UIDevice currentDevice].identifierForVendor UUIDString] forKey:@"UUID"];
    
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否提交" preferredStyle:UIAlertControllerStyleAlert];
    //项目一
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD show];
        
        NSString *mainURL = [ESSLoginTool getMainURL];
        
        [manager POST:[mainURL stringByAppendingString:@"/APP/WB/Rescue_AlarmOrderTask/EReport" ] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (int i=0;i<_dataArray.count;i++)
            {
                UIImage *image=[_dataArray objectAtIndex:i];
                NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
                NSString *fileName = [NSString stringWithFormat:@"file_%d.jpg",i];
                [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file_%d",i] fileName:fileName mimeType: @"image/jpeg"];
            }
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
            self.submitCallback(@"success");
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }];
    
    [alert addAction:action1];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    } ];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else{
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.allowCrop = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        for (UIImage *image in photos) {
            if (_dataArray.count < 9) {
                [self.dataArray addObject:image];
                [self.collectionView reloadData];
            }else{
                [SVProgressHUD showInfoWithStatus:@"最多选择9张照片"];
                return ;
            }
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    [_imagePickerVc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!(_dataArray.count < 9)) {
        return 9;
    }else {
        return _dataArray.count+1;
    }
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ESSPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ESSPhotoCell" forIndexPath:indexPath];
        if (indexPath.row == _dataArray.count) {
            cell.imageView.image = [UIImage imageNamed:@"icon_shijianshangbao_shangchuanzhaopian"];
            cell.deleteBtn.hidden=YES;
        }else{
            cell.imageView.image = self.dataArray[indexPath.row];
            cell.deleteBtn.hidden=NO;
            cell.deleteBtn.tag = indexPath.row + 100;
            [cell.deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _dataArray.count) {
        
    }else{
        [self pushImagePickerController];
    }
}


-(void)btnClick:(UIButton *)btn
{
    [_dataArray removeObjectAtIndex:btn.tag-100];
    [_collectionView reloadData];
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
