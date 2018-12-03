//
//  ESSChangePhotoController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/5/16.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSChangePhotoController.h"
#import <TZImagePickerController.h>
#import <TZImageManager.h>

@interface ESSChangePhotoController ()
<
UIActionSheetDelegate
,TZImagePickerControllerDelegate
,UINavigationControllerDelegate
,UIImagePickerControllerDelegate
,MWPhotoBrowserDelegate
>

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) NSArray *photos;

@end

@implementation ESSChangePhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.navigationItem.title = @"修改头像";
    self.view.backgroundColor = [UIColor blackColor];
    self.displayActionButton = NO;
    
    UIBarButtonItem *item = [UIBarButtonItem itemWithTitle:nil image:@"icon_diangengduo" highImage:@"icon_diangengduo" target:self action:@selector(selectPhoto)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)selectPhoto{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
    [sheet showInView:self.view];
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
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}


- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.allowCrop = YES;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [self submitPhoto:photos[0]];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

- (void)takePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)submitPhoto:(UIImage *)cropImage {
    NSDateFormatter *format = [NSDateFormatter new];
    format.dateFormat = @"yyyyMMddHHmmss";
//    NSString *key = [NSString stringWithFormat:@"%@.png",[format stringFromDate:[NSDate date]]];
    NSDictionary *images = @{@"TuPian":cropImage};
    [NetworkingTool POST:@"/APP/SYS/Sys_YongHu/SetTouXiang" parameters:nil images:images success:^(NSDictionary * _Nonnull responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonInfo" object:nil];
        NSMutableDictionary *tmp = [NSMutableDictionary new];
        [tmp setValue:responseObject forKey:@"TouXiangURL"];
        NSDictionary *defaults  =  [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:defaults];
        [dict setObject:responseObject forKey:@"TouXiangURL"];
        [[NSUserDefaults standardUserDefaults] setObject:dict  forKey:@"userInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.photos = @[[MWPhoto photoWithImage:cropImage]];
        [self reloadData];
    }];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushImagePickerController];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                            self.photos = @[[MWPhoto photoWithImage:cropImage]];
                            [self submitPhoto:cropImage];
                            [self reloadData];
                        }];
                        [self presentViewController:imagePicker animated:YES completion:nil];
                        [picker dismissViewControllerAnimated:NO completion:nil];
                    }];
                }];
            }
        }];
    }
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}

@end
