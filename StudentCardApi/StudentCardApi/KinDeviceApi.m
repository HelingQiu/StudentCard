//
//  KinDeviceApi.m
//  StudentCardApi
//
//  Created by Rainer on 16/4/3.
//  Copyright © 2016年 JJS-iMac. All rights reserved.
//

#import "KinDeviceApi.h"
#import "KinGuardTool.h"
#import "KinGuartApi.h"
#import "KinNetworking.h"
#import "HostDefines.h"

@implementation KinDeviceApi

+ (KinDeviceApi *)sharedKinDevice
{
    static KinDeviceApi *sharedKinDevice = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedKinDevice = [[self alloc] init];
    });
    return sharedKinDevice;
}

- (NSDictionary *)returnParamers:(NSString *)keyAndValueString
{
    //rc4加密值
    NSString *rc4String = [KinGuardTool encryptString:keyAndValueString withKey:[KinGuartApi sharedKinGuard].appSecret];
    
    //hash加密值
    NSString *hashString = [KinGuardTool hmac:keyAndValueString withKey:[KinGuartApi sharedKinGuard].appSecret];
    
    NSString *token = [KinGuardTool getLocalLoginToken];
    NSDictionary *body = @{@"_sign":hashString,@"_tk":token,@"cipher":rc4String,@"version":@"1"};
    
    return body;
}

//通过二维码绑定设备
- (void)bindDeviceByQRCode:(NSString *)qrcode success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self bindDeviceByQRCode:qrcode success:successed fail:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&qrcode=%@",@"KinGuard_BindDeviceByQR",qrcode];
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuradDeviceApi finished:^(NSDictionary *data) {
                
                if ([[data objectForKey:@"state"] integerValue] == 0) {
                    successed(data);
                }else{
                    if ([[data objectForKey:@"state"] integerValue] == 2) {
                        //关注 （被别人绑定之后）
                        successed(data);
//                        [self bindFollowByQRCode:qrcode withSmscode:@"" success:^(NSDictionary *data) {
//                            if ([[data objectForKey:@"state"] integerValue] == 0) {
//                                [self bindDeviceByQRCode:qrcode success:successed fail:failed];
//                            }else if ([[data objectForKey:@"state"] integerValue] == 1){
//                                successed(data);
//                            }else if ([[data objectForKey:@"state"] integerValue] == 5){
//                                successed(data);
//                            }else{
//                                failed([data objectForKey:@"desc"]);
//                            }
//                        } fail:^(NSString *error) {
//                            failed(@"关注失败");
//                        }];
                    }else{
                        failed([data objectForKey:@"desc"]);
                    }
                }
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
        
    }else{
        failed(@"您尚未登录，请登录");
    }
    
}

//通过设备id绑定
- (void)bindDeviceByPid:(NSString *)pid withKey:(NSString *)akey success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    //获取token成功后重新调用本方法
                    [self bindDeviceByPid:pid withKey:akey success:successed fail:failed];
                }
            }];
        }else{
            NSString *keyValueString = [NSString stringWithFormat:@"akey=%@&funname=%@&pid=%@",akey,@"KinGuard_BindDeviceById",pid];
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuradDeviceApi finished:^(NSDictionary *data) {
                if ([[data objectForKey:@"state"] integerValue] == 0) {
                    successed(data);
                }else{
                    if ([[data objectForKey:@"state"] integerValue] == 2) {
                        //关注 （被别人绑定之后）
                        successed(data);
//                        [self bindFollowByPid:pid withKey:akey withSmscode:@"" success:^(NSDictionary *data) {
//                            if ([[data objectForKey:@"state"] integerValue] == 0) {
//                                [self bindDeviceByPid:pid withKey:akey success:successed fail:failed];
//                            }else if ([[data objectForKey:@"state"] integerValue] == 1){
//                                successed(data);
//                            }else if ([[data objectForKey:@"state"] integerValue] == 5){
//                                successed(data);
//                            }else{
//                                failed([data objectForKey:@"desc"]);
//                            }
//                        } fail:^(NSString *error) {
//                            failed(@"关注失败");
//                        }];
                        
                    }else{
                        failed([data objectForKey:@"desc"]);
                    }
                }
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
    }else{
        failed(@"您尚未登录，请登录");
    }
}

//关注号绑定(二维码)
- (void)bindFollowByQRCode:(NSString *)qrcode withSmscode:(NSString *)smscode success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    //获取token成功后重新调用本方法
                    [self bindFollowByQRCode:qrcode withSmscode:smscode success:successed fail:failed];
                }
            }];
        }else{
//            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&qrcode=%@",@"KinGuard_FollowRequestByQR",qrcode];
//            if (smscode != nil) {
              NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&qrcode=%@&smscode=%@",@"KinGuard_FollowRequestByQR",qrcode,smscode];
//            }
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuradDeviceApi finished:^(NSDictionary *data) {
                if ([[data objectForKey:@"state"] integerValue] == 0) {
                    successed(data);
                }else if ([[data objectForKey:@"state"] integerValue] == 5){
//                    NSString *scode = [data objectForKey:@"smscode"];
//                    [self bindFollowByQRCode:qrcode withSmscode:scode success:successed fail:failed];
                    successed(data);
                }else if ([[data objectForKey:@"state"] integerValue] == 1){
                    successed(data);
                }else{
                    failed([data objectForKey:@"desc"]);
                }
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
    }else{
        failed(@"您尚未登录，请登录");
    }
}

//关注号绑定(设备 ID 号)
- (void)bindFollowByPid:(NSString *)pid withKey:(NSString *)akey withSmscode:(NSString *)smscode success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    //获取token成功后重新调用本方法
                    [self bindFollowByPid:pid withKey:akey withSmscode:smscode success:successed fail:failed];
                }
            }];
        }else{
//            NSString *keyValueString = [NSString stringWithFormat:@"akey=%@&funname=%@&pid=%@",akey,@"KinGuard_FollowRequestById",pid];
//            if (smscode != nil) {
            NSString *keyValueString= keyValueString = [NSString stringWithFormat:@"akey=%@&funname=%@&pid=%@&smscode=%@",akey,@"KinGuard_FollowRequestById",pid,smscode];
//            }
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuradDeviceApi finished:^(NSDictionary *data) {
                if ([[data objectForKey:@"state"] integerValue] == 0) {
                    successed(data);
                }else if ([[data objectForKey:@"state"] integerValue] == 5){
                    NSString *scode = [data objectForKey:@"smscode"];
                    [self bindFollowByPid:pid withKey:akey withSmscode:scode success:successed fail:failed];
                }else if ([[data objectForKey:@"state"] integerValue] == 1){
                    successed(data);
                }else{
                    failed([data objectForKey:@"desc"]);
                }
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
    }else{
        failed(@"您尚未登录，请登录");
    }
}

//设备解绑(通过设备id)
- (void)unBindDeviceByPid:(NSString *)pid withKey:(NSString *)akey withMainacc:(NSString *)mainacc success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    //获取token成功后重新调用本方法
                    [self unBindDeviceByPid:pid withKey:akey withMainacc:mainacc success:successed fail:failed];
                }
            }];
        }else{
            NSString *keyValueString = [NSString stringWithFormat:@"akey=%@&funname=%@&mainacc=%@&pid=%@",akey,@"KinGuard_UnBindDeviceById",mainacc,pid];
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuradDeviceApi finished:^(NSDictionary *data) {
                successed(data);
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
    }else{
        failed(@"您尚未登录，请登录");
    }
}

//设备解绑(通过二维码)
- (void)unBindDeviceByQrcode:(NSString *)qrcode withMainacc:(NSString *)mainacc success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    //获取token成功后重新调用本方法
                    [self unBindDeviceByQrcode:qrcode withMainacc:mainacc success:successed fail:failed];
                }
            }];
        }else{
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&mainacc=%@",@"KinGuard_UnBindDeviceByQR",mainacc];
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuradDeviceApi finished:^(NSDictionary *data) {
                successed(data);
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
    }else{
        failed(@"您尚未登录，请登录");
    }
}

#pragma mark - 关系设定
//关系设定
- (void)setRelationshipWithPid:(NSString *)pid withRelationship:(NSString *)relationship success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    //获取token成功后重新调用本方法
                    [self setRelationshipWithPid:pid withRelationship:relationship success:successed fail:failed];
                }
            }];
        }else{
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&pid=%@&relationship=%@",@"KinGuard_SetRelationship",pid,relationship];
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuradDeviceApi finished:^(NSDictionary *data) {
                successed(data);
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
    }else{
        failed(@"您尚未登录，请登录");
    }
}

#pragma mark - 宝贝信息

//宝贝列表
- (void)deviceListSuccess:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    //获取token成功后重新调用本方法
                    [self deviceListSuccess:successed fail:failed];
                }
            }];
        }else{
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@",@"KinGuard_DeviceList"];
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuradDeviceApi finished:^(NSDictionary *data) {
                successed(data);
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
    }else{
        failed(@"您尚未登录，请登录");
    }
}

//宝贝信息
- (void)deviceInfoPid:(NSString *)pid success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    //获取token成功后重新调用本方法
                    [self deviceInfoPid:pid success:successed fail:failed];
                }
            }];
        }else{
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&pid=%@",@"KinGuard_DeviceInfo",pid];
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuradDeviceApi finished:^(NSDictionary *data) {
                successed(data);
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
    }else{
        failed(@"您尚未登录，请登录");
    }
}

//修改宝贝信息
- (void)updateDeviceInfoPid:(NSString *)pid withAssetname:(NSString *)asset_name withSex:(NSString *)sex success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    //获取token成功后重新调用本方法
                    [self updateDeviceInfoPid:pid withAssetname:asset_name withSex:sex success:successed fail:failed];
                }
            }];
        }else{
            NSString *keyValueString = [NSString stringWithFormat:@"asset_name=%@&funname=%@&pid=%@&sex=%@",asset_name,@"KinGuard_UpdateDeviceInfo",pid,sex];
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuradDeviceApi finished:^(NSDictionary *data) {
                successed(data);
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
    }else{
        failed(@"您尚未登录，请登录");
    }
}

//监护人绑定信息
- (void)deviceBindInfoPid:(NSString *)pid success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    //获取token成功后重新调用本方法
                    [self deviceBindInfoPid:pid success:successed fail:failed];
                }
            }];
        }else{
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&pid=%@",@"KinGuard_DeviceBindInfo",pid];
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuradDeviceApi finished:^(NSDictionary *data) {
                successed(data);
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
    }else{
        failed(@"您尚未登录，请登录");
    }
}

//记步数
- (void)startStepsPid:(NSString *)pid success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    //获取token成功后重新调用本方法
                    [self startStepsPid:pid success:successed fail:failed];
                }
            }];
        }else{
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&pid=%@",@"KinGuard_StatSteps",pid];
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuradDeviceApi finished:^(NSDictionary *data) {
                successed(data);
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
    }else{
        failed(@"您尚未登录，请登录");
    }
}

#pragma mark - 绑定推送
//绑定百度推送
- (void)bindBaiduPushWithUserid:(NSString *)userid withChannelid:(NSString *)channelid withAppid:(NSString *)appid success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    //获取token成功后重新调用本方法
                    [self bindBaiduPushWithUserid:userid withChannelid:channelid withAppid:appid success:successed fail:failed];
                }
            }];
        }else{
            NSString *keyValueString = [NSString stringWithFormat:@"appid=%@&channelid=%@&funname=%@&userid=%@",appid,channelid,@"KinGuard_BindBaiduPush",userid];
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuradDeviceApi finished:^(NSDictionary *data) {
                if ([[data objectForKey:@"state"] integerValue] == 0) {
                    successed(data);
                }else{
                    failed([data objectForKey:@"desc"]);
                }
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
    }else{
        failed(@"您尚未登录，请登录");
    }
}

//绑定极光推送
- (void)bindJpushWithRegisterid:(NSString *)registerid success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    //获取token成功后重新调用本方法
                    [self bindJpushWithRegisterid:registerid success:successed fail:failed];
                }
            }];
        }else{
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&registerid=%@",@"KinGuard_BindJPush",registerid];
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuradDeviceApi finished:^(NSDictionary *data) {
                if ([[data objectForKey:@"state"] integerValue] == 0) {
                    successed(data);
                }else{
                    failed([data objectForKey:@"desc"]);
                }
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
    }else{
        failed(@"您尚未登录，请登录");
    }
}

@end
