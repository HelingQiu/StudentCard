//
//  KinLocationApi.m
//  StudentCardApi
//
//  Created by Rainer on 16/4/4.
//  Copyright © 2016年 JJS-iMac. All rights reserved.
//

#import "KinLocationApi.h"
#import "KinGuardTool.h"
#import "KinGuartApi.h"
#import "KinNetworking.h"
#import "HostDefines.h"

@implementation KinLocationApi

+ (KinLocationApi *)sharedKinLocation
{
    static KinLocationApi *sharedKinLocation = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedKinLocation = [[self alloc] init];
    });
    return sharedKinLocation;
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

#pragma mark - 普通定位申请
- (void)startNormalLocation:(NSString *)pid success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self startNormalLocation:pid success:successed fail:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&pid=%@",@"KinGuard_StartLocation",pid];
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuardLocationApi finished:^(NSDictionary *data) {
                //token失效时
                if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"state:"] integerValue] == 401) {
                    [KinGuardTool getLoginToken:^(BOOL finish) {
                        if (YES) {
                            //获取token成功后重新调用本方法
                            [self startNormalLocation:pid success:successed fail:failed];
                        }
                    }];
                }else{
                    successed(data);
                }
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
        
    }else{
        failed(@"您尚未登录，请登录");
    }
}

#pragma mark - 紧急定位申请
- (void)startUrgenLocation:(NSString *)pid success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self startNormalLocation:pid success:successed fail:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&pid=%@",@"KinGuard_StartUrgenLocation",pid];
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuardLocationApi finished:^(NSDictionary *data) {
                //token失效时
                if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"state:"] integerValue] == 401) {
                    [KinGuardTool getLoginToken:^(BOOL finish) {
                        if (YES) {
                            //获取token成功后重新调用本方法
                            [self startNormalLocation:pid success:successed fail:failed];
                        }
                    }];
                }else{
                    successed(data);
                }
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
        
    }else{
        failed(@"您尚未登录，请登录");
    }
}

#pragma mark - 监听申请
- (void)startRecordLocation:(NSString *)pid success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self startNormalLocation:pid success:successed fail:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&pid=%@",@"KinGuard_StartRecordLocation",pid];
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuardLocationApi finished:^(NSDictionary *data) {
                //token失效时
                if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"state:"] integerValue] == 401) {
                    [KinGuardTool getLoginToken:^(BOOL finish) {
                        if (YES) {
                            //获取token成功后重新调用本方法
                            [self startNormalLocation:pid success:successed fail:failed];
                        }
                    }];
                }else{
                    successed(data);
                }
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
        
    }else{
        failed(@"您尚未登录，请登录");
    }
}

#pragma mark - 获取定位信息
- (void)readLocationInfo:(NSString *)pid success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self readLocationInfo:pid success:successed fail:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&pid=%@",@"KinGuard_ReadLocationInfo",pid];
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuardLocationApi finished:^(NSDictionary *data) {
                //token失效时
                if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"state:"] integerValue] == 401) {
                    [KinGuardTool getLoginToken:^(BOOL finish) {
                        if (YES) {
                            //获取token成功后重新调用本方法
                            [self readLocationInfo:pid success:successed fail:failed];
                        }
                    }];
                }else{
                    successed(data);
                }
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
        
    }else{
        failed(@"您尚未登录，请登录");
    }
}

#pragma mark - 获取历史定位信息
- (void)readPosHisInfo:(NSString *)pid withBegdt:(NSString *)beginTime withEnddt:(NSString *)endTime success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self readLocationInfo:pid success:successed fail:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"begdt=%@&enddt=%@&funname=%@&pid=%@",beginTime,endTime,@"KinGuard_ReadPosHisInfo",pid];
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuardLocationApi finished:^(NSDictionary *data) {
                //token失效时
                if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"state:"] integerValue] == 401) {
                    [KinGuardTool getLoginToken:^(BOOL finish) {
                        if (YES) {
                            //获取token成功后重新调用本方法
                            [self readLocationInfo:pid success:successed fail:failed];
                        }
                    }];
                }else{
                    successed(data);
                }
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
        
    }else{
        failed(@"您尚未登录，请登录");
    }
}

#pragma mark - 根据token值获取定位信息
- (void)getLocationByPid:(NSString *)pid withLocationToken:(NSString *)token success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self getLocationByPid:pid withLocationToken:token success:successed fail:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&pid=%@&token=%@",@"KinGuard_GetLocationByToken",pid,token];
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuardLocationApi finished:^(NSDictionary *data) {
                //token失效时
                if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"state:"] integerValue] == 401) {
                    [KinGuardTool getLoginToken:^(BOOL finish) {
                        if (YES) {
                            //获取token成功后重新调用本方法
                            [self getLocationByPid:pid withLocationToken:token success:successed fail:failed];
                        }
                    }];
                }else{
                    successed(data);
                }
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
        
    }else{
        failed(@"您尚未登录，请登录");
    }
}

#pragma mark - 设定安全区域
- (void)setSecZone:(NSString *)pid withAction:(NSString *)action withAddr:(NSString *)addr withLng:(NSString *)lng withLat:(NSString *)lat withIntime:(NSString *)intime withOuttime:(NSString *)outtime withDays:(NSString *)days withRadius:(NSString *)radius withTokenno:(NSString *)tokenno  success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self setSecZone:pid withAction:action withAddr:addr withLng:lng withLat:lat withIntime:intime withOuttime:outtime withDays:days withRadius:radius withTokenno:tokenno success:nil fail:nil];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"action=%@&addr=%@&days=%@&funname=%@&in_timestamp=%@&latitude=%@&longitude=%@&out_timestamp=%@&pid=%@&radius=%@&tokenno=%@",action,addr,days,@"KinGuard_GetLocationByToken",intime,lat,lng,pid,outtime,radius,tokenno];
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuardLocationApi finished:^(NSDictionary *data) {
                //token失效时
                if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"state:"] integerValue] == 401) {
                    [KinGuardTool getLoginToken:^(BOOL finish) {
                        if (YES) {
                            //获取token成功后重新调用本方法
                            [self setSecZone:pid withAction:action withAddr:addr withLng:lng withLat:lat withIntime:intime withOuttime:outtime withDays:days withRadius:radius withTokenno:tokenno success:nil fail:nil];
                        }
                    }];
                }else{
                    successed(data);
                }
            } failed:^(NSString *error) {
                failed(error);
            }];
        }
        
    }else{
        failed(@"您尚未登录，请登录");
    }
}

#pragma mark - 获取安全区域列表
- (void)getSecZonePid:(NSString *)pid  success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self getSecZonePid:pid success:successed fail:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&pid=%@",@"KinGuard_GetSecZone",pid];
            
            NSDictionary *body = [self returnParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuardLocationApi finished:^(NSDictionary *data) {
                //token失效时
                if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"state:"] integerValue] == 401) {
                    [KinGuardTool getLoginToken:^(BOOL finish) {
                        if (YES) {
                            //获取token成功后重新调用本方法
                            [self getSecZonePid:pid success:successed fail:failed];
                        }
                    }];
                }else{
                    successed(data);
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
