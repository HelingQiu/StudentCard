//
//  HostDefines.h
//  StudentCardApi
//
//  Created by Rainer on 16/4/3.
//  Copyright © 2016年 JJS-iMac. All rights reserved.
//

#ifndef HostDefines_h
#define HostDefines_h

//服务器地址端口
#define HOST @"http://222.76.216.81:88/appsvr"

//---账户操作相关接口-----//
#define KinGuardAccountApi  HOST @"/rec/AppAccountCent"

//---用户信息设定-----//
#define KinGuardUserInfoApi HOST @"/res/UserInfoCent"

//---用户头像上传-----//
#define KinGuardUploadPhotoApi HOST @"/res/UploadPhotoFile"

//---用户头像下载-----//
#define KinGuardDownloadPhotoApi HOST @"/res/DownloadPhotoFile"

//---登录相关接口--------//
#define KinGuardLoginApi    HOST @"/res/AppLoginCent"

//---获取登录token------//
#define KinGuardTokenApi    HOST @"/res/SessionToken"

//---设备绑定-----------//
#define KinGuradDeviceApi   HOST @"/rec/DeviceReqCent"

//---定位--------------//
#define KinGuardLocationApi HOST @"/res/PosDevCent"


//--------内部存储key---//
#define KinLoginMobile @"mobile"
#define KinLoginPwd    @"password"
#define KinLoginToken  @"token"


//---录音-----------//
/**
 *  监听申请
 */
#define KinRecordDevCent   HOST @"/res/RecordDevCent"

/**
 *  录音下载
 */
#define KinDownloadAudioFile  HOST @"/res/DownloadAudioFile"


//---文件上传下载-----------//
/**
 *  文件清单
 */
#define KinFileList   HOST @"/res/FileList"

/**
 *  文件上传
 */
#define KinUploadFile   HOST @"/res/UploadFile"

/**
 *  文件下载
 */
#define KinDownloadFile   HOST @"/res/DownloadFile"

/**
 *  Description:获取聊天记录
 */
#define KinChatMessage HOST @"/res/ChatInfoCent"

#endif /* HostDefines_h */

