//
//  KinFileApi.m
//  StudentCardApi
//
//  Created by Rainer on 16/4/4.
//  Copyright © 2016年 JJS-iMac. All rights reserved.
//

#import "KinFileApi.h"
#import "KinNetworking.h"
#import "HostDefines.h"
#import "KinGuardTool.h"
#import "KinGuartApi.h"

@implementation KinFileApi

+ (KinFileApi *)sharedKinFileApi
{
    static KinFileApi *sharedKinDevice = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedKinDevice = [[self alloc] init];
    });
    return sharedKinDevice;
}


/**
 *  文件清单
 */
- (void)requestFileListFinished:(KSFinishedBlock)finished failed:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self requestFileListFinished:finished failed:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@",@"KinGuard_RecordSource"];
            NSDictionary *params = [KinGuardTool returnParamers:keyValueString];
            [[[KinNetworking alloc] init] requestDataFromWSWithParams:params forPath:KinFileList finished:finished failed:failed];
            
        }
    }else{
        failed(@"您尚未登录，请登录");
    }
}

/**
 *  文件上传
 */
- (void)uploadFileWithDeviceId:(NSString *)deviceId andFileName:(NSString *)fileName andIsShare:(BOOL)isShare andFileData:(NSData *)fileData uploadProgress:(KSUploadProgress)ksUploadProgress  finished:(KSFinishedBlock)finished failed:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self uploadFileWithDeviceId:deviceId andFileName:fileName andIsShare:isShare andFileData:fileData uploadProgress:ksUploadProgress finished:finished failed:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&filename=%@&share=%@&tltitle=%@&Byte[]=%@",
                                        @"KinGuard_UploadFile",
                                        fileName?:@"",
                                        isShare?@"1":@"0",
                                        fileName?:@"",
                                        fileData?:@""];
            NSDictionary *params = [KinGuardTool returnParamers:keyValueString];
            [[[KinNetworking alloc] init] uploadAudioFileToPath:KinUploadFile andFileData:fileData fileName:fileName name:fileName  params:params uploadProgress:ksUploadProgress finished:finished failed:failed];
            
        }
    }else{
        failed(@"您尚未登录，请登录");
    }


}

/**
 *  文件下载
 */
- (void)downLoadFileWithFileName:(NSString *)fileName andFileToken:(NSString *)token progress:(KSUploadProgress)progress finished:(KSFinishedBlock)finished failed:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self downLoadFileWithFileName:fileName andFileToken:token progress:progress finished:finished failed:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@",@"KinGuard_RecordSource"];
            NSDictionary *params = [KinGuardTool returnParamers:keyValueString];
            [[[KinNetworking alloc] init] downloadFileFromPath:KinDownloadFile withParams:params andFileName:fileName progress:progress finished:finished failed:failed];
        }
    }else{
        failed(@"您尚未登录，请登录");
    }
}
@end
