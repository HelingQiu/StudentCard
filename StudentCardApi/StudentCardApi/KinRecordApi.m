//
//  KinRecordApi.m
//  StudentCardApi
//
//  Created by Rainer on 16/4/4.
//  Copyright © 2016年 JJS-iMac. All rights reserved.
//

#import "KinRecordApi.h"
#import "KinNetworking.h"
#import "HostDefines.h"
#import "KinGuardTool.h"
#import "KinGuartApi.h"

@implementation KinRecordApi
+ (KinRecordApi *)sharedKinRecordApi
{
    static KinRecordApi *sharedKinDevice = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedKinDevice = [[self alloc] init];
    });
    return sharedKinDevice;
}

/**
 *  监听申请
 */
- (void)applicationMonitorWithDeviceId:(NSString *)deviceId andFinished:(KSFinishedBlock)finished failed:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self applicationMonitorWithDeviceId:deviceId andFinished:finished failed:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&pid=%@",@"KinGuard_StartRecord",deviceId];
            NSDictionary *params = [KinGuardTool returnParamers:keyValueString];
            [[[KinNetworking alloc] init] requestDataFromWSWithParams:params forPath:KinRecordDevCent finished:finished failed:failed];
            
        }
    }else{
        failed(@"您尚未登录，请登录");
    }
}

/**
 *  录音信息
 */
- (void)recordInfomationWithDeviceId:(NSString *)deviceId andFinished:(KSFinishedBlock)finished failed:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self recordInfomationWithDeviceId:deviceId andFinished:finished failed:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&pid=%@",@"KinGuard_RecordSource",deviceId];
            NSDictionary *params = [KinGuardTool returnParamers:keyValueString];
            [[[KinNetworking alloc] init] requestDataFromWSWithParams:params forPath:KinRecordDevCent finished:finished failed:failed];
            
        }
    }else{
        failed(@"您尚未登录，请登录");
    }
}

/**
 *  录音下载
 */
- (void)downloadRecordWithDeviceId:(NSString *)deviceId token:(NSString *)token
                       andFileName:(NSString *)fileName andProgress:(KSDownloadProgress)progress finished:(KSFinishedBlock)finished failed:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self downloadRecordWithDeviceId:deviceId token:token andFileName:fileName  andProgress:progress finished:finished failed:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&pid=%@&token=%@",@"KinGuard_DownRecord",deviceId,token];
            NSDictionary *params = [KinGuardTool returnParamers:keyValueString];
            [[[KinNetworking alloc] init] downloadFileFromPath:KinDownloadAudioFile withParams:params andFileName:fileName progress:progress finished:finished failed:failed];
        }
    }else{
        failed(@"您尚未登录，请登录");
    }
}

//上传聊天信息
- (void)uploadChatMessageToAcc:(NSString *)acc chatContent:(NSString *)message finished:(KSFinishedBlock)finished failed:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self uploadChatMessageToAcc:acc chatContent:message finished:finished failed:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"chatcontent=%@&funname=%@&toacc=%@",message,@"KinGuard_UploadChat",acc];
            NSDictionary *params = [KinGuardTool returnParamers:keyValueString];
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:params forPath:KinChatMessage finished:^(NSDictionary *data) {
                //token失效时
                if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"state:"] integerValue] == 401) {
                    [KinGuardTool getLoginToken:^(BOOL finish) {
                        if (YES) {
                            //获取token成功后重新调用本方法
                            [self uploadChatMessageToAcc:acc chatContent:message finished:finished failed:failed];
                        }
                    }];
                }else{
                    finished(data);
                }
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
    }
}

//获取聊天信息
- (void)getMessageToAcc:(NSString *)acc fromDate:(NSString *)fromDate toDate:(NSString *)toDate finished:(KSFinishedBlock)finished failed:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self getMessageToAcc:acc fromDate:fromDate toDate:toDate finished:finished failed:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"fromdate=%@&funname=%@&toacc=%@&todate=%@",fromDate,@"KinGuard_UploadChat",acc,toDate];
            NSDictionary *params = [KinGuardTool returnParamers:keyValueString];
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:params forPath:KinChatMessage finished:^(NSDictionary *data) {
                //token失效时
                if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"state:"] integerValue] == 401) {
                    [KinGuardTool getLoginToken:^(BOOL finish) {
                        if (YES) {
                            //获取token成功后重新调用本方法
                            [self getMessageToAcc:acc fromDate:fromDate toDate:toDate finished:finished failed:failed];
                        }
                    }];
                }else{
                    finished(data);
                }
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
    }
}

//群聊信息上传
- (void)uploadMessageToPid:(NSString *)pid chatContent:(NSString *)chatcontent finished:(KSFinishedBlock)finished failed:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self uploadMessageToPid:pid chatContent:chatcontent finished:finished failed:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"chatcontent=%@&funname=%@&pid=%@",chatcontent,@"KinGuard_GetChatListInPid",pid];
            NSDictionary *params = [KinGuardTool returnParamers:keyValueString];
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:params forPath:KinChatMessage finished:^(NSDictionary *data) {
                //token失效时
                if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"state:"] integerValue] == 401) {
                    [KinGuardTool getLoginToken:^(BOOL finish) {
                        if (YES) {
                            //获取token成功后重新调用本方法
                            [self uploadMessageToPid:pid chatContent:chatcontent finished:finished failed:failed];
                        }
                    }];
                }else{
                    finished(data);
                }
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
    }
}

//获取群聊信息
- (void)getChatMessage:(NSString *)pid chatContent:(NSString *)chatcontent fromDate:(NSString *)fromDate toDate:(NSString *)toDate finished:(KSFinishedBlock)finished failed:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self getChatMessage:pid chatContent:chatcontent fromDate:fromDate toDate:toDate finished:finished failed:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"chatcontent=%@&fromdate=%@&funname=%@&pid=%@&todate=%@",chatcontent,fromDate,@"KinGuard_GetChatListInPid",pid,toDate];
            NSDictionary *params = [KinGuardTool returnParamers:keyValueString];
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:params forPath:KinChatMessage finished:^(NSDictionary *data) {
                //token失效时
                if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"state:"] integerValue] == 401) {
                    [KinGuardTool getLoginToken:^(BOOL finish) {
                        if (YES) {
                            //获取token成功后重新调用本方法
                            [self getChatMessage:pid chatContent:chatcontent fromDate:fromDate toDate:toDate finished:finished failed:failed];
                        }
                    }];
                }else{
                    finished(data);
                }
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
    }
}

@end
