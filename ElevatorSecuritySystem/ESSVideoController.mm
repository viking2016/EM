//
//  ESSVideoController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/5/17.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSVideoController.h"
#import "PlayCtrl.h"
#import "Funclib.h"

UIView *view;
int decodePort = -1;
@interface ESSVideoController ()

@property (assign,nonatomic)int loginResult;
/**
 *  设备Id
 */
@property (copy,nonatomic)NSString *deviceId;
/**
 *  初始化视频组件结果, 0 代表成功
 */
@property (assign,nonatomic)int initResult;

@property (nonatomic,strong)NSDictionary *dict;

@property (nonatomic,strong) NSString *userNameString;
//
@property (nonatomic,strong) NSString *passwordString;
//
//@property (nonatomic,strong) NSString *serverAddressString;

//NSString *userNameString = @"admin";
//NSString *passwordString = @"123456";
//NSString *serverAddressString = @"1185404";

@end

@implementation ESSVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _deviceId = @"3079696";
    [self createUI];
    
    [self getDerviceID];

}

- (void)getDerviceID{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.ElevID forKey:@"ElevID"];
   [ESSNetworkingTool GET:@"/APP/WB/Elev_Info/GetCamera" parameters:dict success:^(NSDictionary * _Nonnull responseObject) {
//       NSDictionary *dict = responseObject;
//       self.deviceId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"CameraNo"]];
//       self.userNameString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Account"]];
//       self.passwordString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Password"]];

      self.deviceId = @"1185404";
      self.userNameString = @"admin";
      self.passwordString = @"123456";

       
   }];
}

- (void)createUI{
    self.navigationItem.title=@"实时图像";
    view = videoView;
    NSArray *array_normal = @[@"开启视频",@"开启声音",@"开启麦克风",@"截图"];
    NSArray *imageArray_normal = @[@"btn_shipin_guan",@"btn_sheng_guan-0",@"btn_mai_guan-0",@"btn_jietu"];
    
    for(int i = 0;i < 4;i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((SCREEN_WIDTH - 3) / 4 * i + (i - 1), SCREEN_WIDTH / 16 * 9, (SCREEN_WIDTH - 3) / 4, (SCREEN_WIDTH - 3) / 4);
        [btn setTitle:array_normal[i] forState:UIControlStateNormal];
        [btn setTitle:array_normal[i] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:imageArray_normal[i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
        btn.tag = i + 10;
        [self.view addSubview:btn];
        
        if(i > 0){
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(((SCREEN_WIDTH - 3) / 4 * i) + (i - 1), 5, 1, (SCREEN_WIDTH - 3) / 4 - 10)];
            view.backgroundColor = [UIColor grayColor];
            [self.view addSubview:lineView];
        }
    }
}

- (void)btnEvent:(UIButton *)btn{
    NSArray *array_normal = @[@"开启视频",@"开启声音",@"开启麦克风",@"截图"];
    NSArray *array_selected = @[@"关闭视频",@"关闭声音",@"关闭麦克风",@"截图"];
    NSArray *imageArray_normal = @[@"btn_shipin_guan",@"btn_sheng_guan-0",@"btn_mai_guan-0",@"btn_jietu"];
    NSArray *imageArray_selected = @[@"btn_shipin",@"btn_shengyin",@"btn_mai",@"btn_jietu"];
    
    btn.selected =! btn.selected;
    
    if (btn.tag - 10 == 0) {
        if(self.initResult == 1){
            //已经初始化过
        }else{
            //初始化视频控件
            [SVProgressHUD show];
            [self initWithLib];
        }
    }
    switch (btn.tag - 10) {
        case 0:
        {
            if (btn.selected) {//开启视频
                
                //                NSString *userNameString = self.dict[@"ModifyUserName"];
                //                NSString *passwordString = self.dict[@"Password"];
                //                NSString *serverAddressString = self.dict[@"DeviceId"];
//                NSString *userNameString = @"admin";
//                NSString *passwordString = @"Zx123456";
//                NSString *serverAddressString = @"3079696";
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    self.loginResult = FC_Login([self.userNameString cStringUsingEncoding:NSASCIIStringEncoding],
                                                [self.passwordString cStringUsingEncoding:NSASCIIStringEncoding],
                                                [self.deviceId  cStringUsingEncoding:NSASCIIStringEncoding],
                                                81);
                    if (!(_loginResult == 0)) {
                        [SVProgressHUD showInfoWithStatus:@"连接设备失败"];
                    }
                   int result = FC_AddWatch((char *)[self.deviceId cStringUsingEncoding:NSASCIIStringEncoding], 1, 0);
                    
                    if (!(result == 0)) {
                        [SVProgressHUD showInfoWithStatus:@"连接设备失败"];
                    }
                    NSLog(@"FC_Login resutl:%d",_loginResult);
                    NSLog(@"FC_AddWatch result:%d",result);
                });
                
            }else{//关闭视频
                [self stopVideo];
                [self stopAudio];
                FC_Logout();
            }
        }
            break;
        case 1:
        {
            UIButton *talkBtn = (UIButton *) [self.view viewWithTag:12];
            if (btn.selected){//开启音频
                PC_PlaySound(decodePort);
                talkBtn.selected = NO;
                
            }else{//关闭音频
                if (decodePort == -1) {
                    return;
                }
                PC_StopSound();
                talkBtn.selected = YES;
            }
        }
            break;
        case 2:
        {
            UIButton *audioBtn = (UIButton *) [self.view viewWithTag:11];
            if (btn.selected){//开启麦克风
                int result = FC_StartTalkEx((char *)[self.deviceId cStringUsingEncoding:NSASCIIStringEncoding],true);
                NSLog(@"FC_StartTalk result:%d",result);
                audioBtn.selected = NO;
            }else{//关闭麦克风
                FC_StopTalk((char *)[self.deviceId cStringUsingEncoding:NSASCIIStringEncoding]);
                audioBtn.selected = YES;
            }
        }
            break;
        default:
        {
            if (decodePort>0) {
                PC_SnapShot(decodePort, "/users/lionel/pic.bmp");
            }
        }
            break;
    }
    
    if (btn.selected) {//更换title
        [btn setTitle:array_normal[btn.tag-10] forState:UIControlStateNormal];
        [btn setTitle:array_selected[btn.tag-10] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:imageArray_normal[btn.tag-10]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageArray_selected[btn.tag-10]] forState:UIControlStateSelected];
    }
}

- (void)initWithLib{
    //设置登录步骤 step 3 of 5:初始化，设置回调函数
    
    
    FC_init();
    FC_SetMsgRspCallBack(FC_MsgRspCallBack);
    
    //播放视频步骤 step 3 of 9:初始化，设置回调函数
    PC_Init();
    int result =  FC_SetMediaRecvCallBack(FC_MediaRspCallBack);
    if (result == 0) {
        self.initResult = 1;
    }
}

- (void)stopVideo{
    
    if (decodePort == -1) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //if you addwatch, need stop to recv real stream
        FC_StopWatch((char *)[self.deviceId cStringUsingEncoding:NSASCIIStringEncoding]);
        //
        //if you begin replay, need stop to recv replay stream
        FC_ControlReplay((char *)[self.deviceId cStringUsingEncoding:NSASCIIStringEncoding], ACTION_STOP, 0);
        //
        //if you begin play, need stop
        PC_Stop(decodePort);
        PC_FreeProt(decodePort);
        decodePort = -1;
        //
    }
                   );
}

- (void)stopAudio {
    if (decodePort == -1) {
        return;
    }
    
    PC_StopSound();
}

#pragma mark - funclib call back
int FC_MsgRspCallBack(unsigned int nMsgType, char* pData, unsigned int nDataLen)
{
    TPS_NotifyInfo *pNotify = NULL;
    @autoreleasepool {
        switch (nMsgType) {
            case TPS_MSG_NOTIFY_LOGIN_OK:
            {
                //设置登录步骤 step 5 of 5:返回登录成功
                NSLog(@"TPS_MSG_NOTIFY_LOGIN_OK");
            }
                break;
            case TPS_MSG_RSP_OSS_REPLAY_PARAM:
            case TPS_MSG_RSP_REPLAY_DEV_FILE:
            {
                TPS_ReplayDevFileRsp *ReplayRsp = (TPS_ReplayDevFileRsp*)pData;
                if (ReplayRsp->nResult == 0)
                {
                    if (ReplayRsp->nActionType == ACTION_PLAY) {
                        if (ReplayRsp->bHaveVideo)
                        {
                            if (decodePort != -1) {
                                PC_Stop(decodePort);
                                PC_FreeProt(decodePort);
                                decodePort = -1;
                            }
                            
                            //播放视频步骤 step 5 of 9:申请解码端口
                            decodePort = PC_GetProt();
                            if (decodePort < 0) {
                                NSLog(@"PC_GetProt fail! decode port = %d",decodePort);
                            }
                            
                            TPS_VIDEO_PARAM  oVideoParam;
                            memset(&oVideoParam, 0, sizeof(TPS_VIDEO_PARAM));
                            oVideoParam.bitrate = ReplayRsp->videoParam.bitrate;
                            strcpy(oVideoParam.config, ReplayRsp->videoParam.vol_data);
                            oVideoParam.config_len = ReplayRsp->videoParam.vol_length;
                            oVideoParam.framerate = ReplayRsp->videoParam.framerate;
                            oVideoParam.height = ReplayRsp->videoParam.height;
                            strcpy(oVideoParam.video_encoder, ReplayRsp->videoParam.codec);
                            oVideoParam.width = ReplayRsp->videoParam.width;
                            
                            PC_OpenStream(decodePort, (char*) &oVideoParam, sizeof(TPS_VIDEO_PARAM), false, 30);
                            
                            if (ReplayRsp->bHaveAudio)
                            {
                                TPS_AUDIO_PARAM  oAudioParam;
                                memset(&oAudioParam, 0, sizeof(TPS_AUDIO_PARAM));
                                strcpy(oAudioParam.audio_encoder, ReplayRsp->audioParam.codec);
                                oAudioParam.bitrate = ReplayRsp->audioParam.bitrate;
                                oAudioParam.channels = ReplayRsp->audioParam.channels;
                                oAudioParam.framerate = 8;
                                oAudioParam.samplebitswitdh = ReplayRsp->audioParam.bitspersample;
                                oAudioParam.samplerate = ReplayRsp->audioParam.samplerate;
                                PC_OpenStream(decodePort, (char*) &oAudioParam, sizeof(TPS_AUDIO_PARAM), true, 30);
                            }
                            
                            PC_SetDecCallBack(decodePort, PC_DecodeCallBack, NULL);
                            PC_Play(decodePort,view);
                        }
                    }
                    else
                        NSLog(@"ReplayRsp->nActionType=%d", ReplayRsp->nActionType);
                }
                else
                {
                    
                }
                
            }
                break;
            case TPS_MSG_RSP_ADDWATCH:
            {
                TPS_AddWachtRsp * addWatchRep = (TPS_AddWachtRsp *)pData;
                
                //注意，接收到播放响应消息的时候，必须判断下当前返回的这个设备id是否有正在播放，如果有必须先停止播放后再去重新创建播放器。
                //因为设备在播放过程中有可能被修改了媒体参数，或者进行了重连，这个时候设备都会重新将参数返回上来
                //所以外层在播放过程中也可能接收到一次或多次TPS_MSG_RSP_ADDWATCH消息
                if (decodePort != -1) {
                    PC_Stop(decodePort);
                    PC_FreeProt(decodePort);
                    decodePort = -1;
                }
                //播放视频步骤 step 5 of 9:申请解码端口
                decodePort = PC_GetProt();
                if (decodePort < 0) {
                    NSLog(@"PC_GetProt fail! decode port = %d",decodePort);
                }
                //播放视频步骤 step 6 of 9:初始化解码参数，
                if (addWatchRep->nMediaType != 0x0100
                    && addWatchRep->videoParam.width > 0
                    && addWatchRep->videoParam.height > 0
                    && addWatchRep->videoParam.framerate > 0) {
                    
                    PC_OpenStream(decodePort, (char*) &addWatchRep->videoParam, sizeof(TPS_VIDEO_PARAM), false, 30);
                    PC_SetDecCallBack(decodePort, PC_DecodeCallBack, NULL);
                }
                //音频
                if (addWatchRep->nMediaType != 0x0001
                    && addWatchRep->audioParam.samplebitswitdh > 0
                    && addWatchRep->audioParam.samplerate > 0) {
                    PC_OpenStream(decodePort, (char*) &addWatchRep->audioParam, sizeof(TPS_AUDIO_PARAM), true, 30);
                }
                //播放视频步骤 step 7 of 9:设置你要显示视频的UIView，视频将显示在这个UIView上面
                PC_Play(decodePort,view);
            }
                break;
            case TPS_MSG_RSP_START_ALERTOR_BIND:
            {
                pNotify = (TPS_NotifyInfo*)pData;
                printf("recv TPS_MSG_RSP_START_ALERTOR_BIND message, result=%d \n", pNotify->nResult);
            }
                break;
            case TPS_MSG_RSP_STOP_ALERTOR_BIND:
            {
                pNotify = (TPS_NotifyInfo*)pData;
                printf("recv TPS_MSG_RSP_STOP_ALERTOR_BIND message, result=%d \n", pNotify->nResult);
            }
                break;
            case TPS_MSG_RSP_GET_ALERTOR_LIST_FAILED:
            {
                pNotify = (TPS_NotifyInfo*)pData;
                printf("recv TPS_MSG_RSP_GET_ALERTOR_LIST_FAILED message, result=%d \n", pNotify->nResult);
            }
                break;
            case TPS_MSG_RSP_GET_ALERTOR_LIST_OK:
            {
                printf("recv TPS_MSG_RSP_GET_ALERTOR_LIST_OK message xml=%s \n", pData);
            }
                break;
            case TPS_MSG_RSP_DEL_ALERTOR_BIND:
            {
                pNotify = (TPS_NotifyInfo*)pData;
                printf("recv TPS_MSG_RSP_DEL_ALERTOR_BIND message result=%d \n", pNotify->nResult);
            }
                break;
            case TPS_MSG_RSP_SECURITY_SET:
            {
                pNotify = (TPS_NotifyInfo*)pData;
                printf("recv TPS_MSG_RSP_SECURITY_SET message result=%d \n", pNotify->nResult);
            }
                break;
            case TPS_MSG_RSP_SECURITY_GET_FAILED:
            {
                pNotify = (TPS_NotifyInfo*)pData;
                printf("recv TPS_MSG_RSP_SECURITY_GET_FAILED message result=%d \n", pNotify->nResult);
            }
                break;
            case TPS_MSG_RSP_SECURITY_GET_OK:
            {
                printf("recv TPS_MSG_RSP_SECURITY_GET_OK message xml=%s \n", pData);
            }
                break;
            case TPS_MSG_RSP_ALERTOR_ALIAS_SET:
            {
                pNotify = (TPS_NotifyInfo*)pData;
                printf("recv TPS_MSG_RSP_ALERTOR_ALIAS_SET message result=%d \n", pNotify->nResult);
            }
                break;
            case TPS_MSG_RSP_ALERTOR_PTZ_SET:
            {
                pNotify = (TPS_NotifyInfo*)pData;
                printf(" recv TPS_MSG_RSP_ALERTOR_PTZ_SET message result=%d \n", pNotify->nResult);
            }
                break;
            case TPS_MSG_NOTIFY_ALERTOR_ALM:
            {
                printf("recv TPS_MSG_NOTIFY_ALERTOR_ALM message xml=%s \n", pData);
            }
                break;
            case TPS_MSG_RSP_ALARM_CONFIRM:
            {
                pNotify = (TPS_NotifyInfo*)pData;
                printf(" recv TPS_MSG_RSP_ALARM_CONFIRM message result=%d \n", pNotify->nResult);
            }
                break;
            case TPS_MSG_BEGIN_DOWNLOAD_OSS_OBJECT:
                printf("recv TPS_MSG_BEGIN_DOWNLOAD_OSS_OBJECT message \n");
                break;
            case TPS_MSG_DOWNLOAD_OSS_OBJECT_SIZE:
                printf("recv TPS_MSG_DOWNLOAD_OSS_OBJECT_SIZE message size=%d \n", nDataLen);
                break;
            case TPS_MSG_END_DOWNLOAD_OSS_OBJECT:
                printf("recv TPS_MSG_END_DOWNLOAD_OSS_OBJECT message \n");
                break;
            case TPS_MSG_DOWNLOAD_OSS_OBJECT_FAILED:
                printf("recv TPS_MSG_DOWNLOAD_OSS_OBJECT_FAILED message \n");
                break;
        }
    }
    return 0;
}

#pragma mark - playctrl call back
int FC_MediaRspCallBack(char* pDevId, unsigned int nMediaType, unsigned char* pFrameData, unsigned int nDataLen,TPS_EXT_DATA *pExtData)
{
    @autoreleasepool {
        
        if (pDevId == NULL || pFrameData == NULL || nDataLen == 0) {
            NSLog(@"FC_MediaRspCallBack param error!");
            return -1;
        }
        
        if (nMediaType == 0 && decodePort >0) { //STREAM_TYPE_VIDEO
            //播放视频步骤 step 8 of 9:把视频数据传给解码器
            PC_InputVideoData(decodePort, (char*)pFrameData, nDataLen, pExtData->bIsKey, pExtData->timestamp);
            
        }else if(nMediaType == 1 && decodePort>0){  //STREAM_TYPE_AUDIO
            
            PC_InputAudioData(decodePort, (char *)pFrameData, nDataLen, pExtData->timestamp);
            
        }else if(nMediaType == 2){
            
        }
    }
    [SVProgressHUD dismiss];
    return 0;
}

#pragma mark - decode call back
//播放视频步骤 step 9 of 9:解码回调，yuv或者rgb数据
int PC_DecodeCallBack(int nPort, char *pDecData, int nSize, FRAME_INFO *pFrameInfo, void *pUser){
    return 0;
}

- (void)dealloc{
    //释放视频组件
    PC_FreeAll();
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
