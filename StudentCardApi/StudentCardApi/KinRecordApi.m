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
@end
