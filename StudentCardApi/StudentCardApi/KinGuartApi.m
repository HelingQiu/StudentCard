//
//  testApi.m
//  StudentCardApi
//
//  Created by RuanSTao on 16/4/1.
//  Copyright © 2016年 JJS-iMac. All rights reserved.
//

#import "KinGuartApi.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "KinNetworking.h"
#import "KinGuardTool.h"
#import "HostDefines.h"


@implementation KinGuartApi

+ (KinGuartApi *)sharedKinGuard
{
    static KinGuartApi *sharedKinGuard = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedKinGuard = [[self alloc] init];
    });
    return sharedKinGuard;
}

- (NSDictionary *)returnParamer:(NSString *)keyAndValueString
{
    //rc4加密值
    NSString *rc4string = [KinGuardTool encryptString:keyAndValueString withKey:self.appSecret];
    
    //hash加密值
    NSString *mobileHash = [KinGuardTool hmac:keyAndValueString withKey:self.appSecret];
    
    NSDictionary *body = @{@"hash":mobileHash,@"key":self.appKey,@"cipher":rc4string,@"version":@"1"};
    return body;
}

//注册
- (void)registerAppAccountMobile:(NSString *)mobile withPassword:(NSString *)password withSmscode:(NSString *)smscode success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&mobile=%@&password=%@&smscode=%@",@"KinGuard_Register",mobile,password,smscode];
    
    NSDictionary *body = [self returnParamer:keyValueString];
    
    [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuardAccountApi finished:^(NSDictionary *data) {
        if ([[data objectForKey:@"state"] integerValue] == 0) {
            successed(data);
        }else{
            NSString *error = nil;
            NSInteger state = [[data objectForKey:@"state"] integerValue];
            if (state == 1) {
                error = @"解密出错";
            }else if (state == 2) {
                error = @"手机号参数缺失";
            }else if (state == 3) {
                error = @"密码参数缺失";
            }else if (state == 4) {
                error = @"短信验证码错误或短信验证码已过期失效";
            }else if (state == 5) {
                error = @"该手机号已注册";
            }else if (state == 6) {
                error = @"appkey 和 appsecret 错误";
            }else if (state == 7) {
                error = @"手机号需短信验证";
            }else if (state == 8) {
                error = @"账号格式错误";
            }else if (state == 9) {
                error = @"其他原因造成的注册失败";
            }
            failed(error);
        }
    } failed:^(NSString *error) {
        failed(error);
    }];
    
}

//密码设置
- (void)setNewPasswordMobile:(NSString *)mobile withPassword:(NSString *)password withSmscode:(NSString *)smscode success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&mobile=%@&newpassword=%@&smscode=%@",@"KinGuard_PasswordReset",mobile,password,smscode];
    
    NSDictionary *body = [self returnParamer:keyValueString];
    
    [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuardAccountApi finished:^(NSDictionary *data) {
        if ([[data objectForKey:@"state"] integerValue] == 0) {
            successed(data);
        }else{
            failed([data objectForKey:@"desc"]);
        }
    } failed:^(NSString *error) {
        failed(error);
    }];
}

//密码报失
- (void)reportLostPasswordMobile:(NSString *)mobile success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&mobile=%@",@"KinGuard_LostPassword",mobile];
    
    NSDictionary *body = [self returnParamer:keyValueString];
    
    [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuardAccountApi finished:^(NSDictionary *data) {
        if ([[data objectForKey:@"state"] integerValue] == 0) {
            successed(data);
        }else{
            failed([data objectForKey:@"desc"]);
        }
    } failed:^(NSString *error) {
        failed(error);
    }];
}

//修改密码
- (void)revisePasswordMobile:(NSString *)mobile withOldPwd:(NSString *)oldpwd withNewPwd:(NSString *)newpwd success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&mobile=%@&newpwd=%@&oldpwd=%@",@"KinGuard_RevisePassword",mobile,newpwd,oldpwd];
    
    NSDictionary *body = [self returnParamer:keyValueString];
    
    [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuardAccountApi finished:^(NSDictionary *data) {
        if ([[data objectForKey:@"state"] integerValue] == 0) {
            successed(data);
        }else{
            failed([data objectForKey:@"desc"]);
        }
    } failed:^(NSString *error) {
        failed(error);
    }];
}

//获取短信验证码
- (void)catchSmsCodeWithMobile:(NSString *)mobile withSmstype:(NSString *)smstype success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&mobile=%@&smstype=%@",@"KinGuard_CatchSmsCode",mobile,smstype];
    
    NSDictionary *body = [self returnParamer:keyValueString];
    
    [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuardAccountApi finished:^(NSDictionary *data) {
        if ([[data objectForKey:@"state"] integerValue] == 0) {
            successed(data);
        }else{
            failed([data objectForKey:@"desc"]);
        }
    } failed:^(NSString *error) {
        failed(error);
    }];
}

//账户注册短信认证
- (void)regSmsCheckWithMobile:(NSString *)mobile withSmsCode:(NSString *)smscode success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&mobile=%@&smscode=%@",@"KinGuard_RegSmsCheck",mobile,smscode];
    
    NSDictionary *body = [self returnParamer:keyValueString];
    
    [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuardAccountApi finished:^(NSDictionary *data) {
        if ([[data objectForKey:@"state"] integerValue] == 0) {
            successed(data);
        }else{
            failed([data objectForKey:@"desc"]);
        }
    } failed:^(NSString *error) {
        failed(error);
    }];
}

#pragma mark - 需要登录
- (NSDictionary *)returnLoginParamers:(NSString *)keyAndValueString
{
    //rc4加密值
    NSString *rc4String = [KinGuardTool encryptString:keyAndValueString withKey:[KinGuartApi sharedKinGuard].appSecret];
    
    //hash加密值
    NSString *hashString = [KinGuardTool hmac:keyAndValueString withKey:[KinGuartApi sharedKinGuard].appSecret];
    
    NSString *token = [KinGuardTool getLocalLoginToken];
    NSDictionary *body = @{@"_sign":hashString,@"_tk":token,@"cipher":rc4String,@"version":@"1"};
    
    return body;
}

//更新用户信息
- (void)updateUserInfoWithMobile:(NSString *)mobile withAddr:(NSString *)addr withIddno:(NSString *)iddno withAccName:(NSString *)accname withAlias:(NSString *)alias withSex:(NSString *)sex withBirthdate:(NSString *)birthdate success:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self updateUserInfoWithMobile:mobile withAddr:addr withIddno:iddno withAccName:accname withAlias:alias withSex:sex withBirthdate:birthdate success:successed fail:failed];
                }
            }];
        }else{
            NSString *keyValueString = [NSString stringWithFormat:@"acc_name=%@&addr=%@&alias=%@&birthdate=%@&funname=%@&mobile=%@&iddno=%@&sex=%@",accname,addr,alias,birthdate,@"KinGuard_UpdateUserInfo",mobile,iddno,sex];
            
            NSDictionary *body = [self returnLoginParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuardUserInfoApi finished:^(NSDictionary *data) {
                //token失效时
                if ([[data objectForKey:@"state:"] integerValue] == 401) {
                    [KinGuardTool getLoginToken:^(BOOL finish) {
                        if (YES) {
                            //获取token成功后重新调用本方法
                            [self updateUserInfoWithMobile:mobile withAddr:addr withIddno:iddno withAccName:accname withAlias:alias withSex:sex withBirthdate:birthdate success:successed fail:failed];
                        }
                    }];
                }else{
                    if ([[data objectForKey:@"state"] integerValue] == 0) {
                        successed(data);
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

//获取用户信息
- (void)getUserInfoSuccess:(KSFinishedBlock)successed fail:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self getUserInfoSuccess:successed fail:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@",@"KinGuard_GetUserInfo"];
            
            NSDictionary *body = [self returnLoginParamers:keyValueString];
            
            [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuardUserInfoApi finished:^(NSDictionary *data) {
                //token失效时
                if ([[data objectForKey:@"state:"] integerValue] == 401) {
                    [KinGuardTool getLoginToken:^(BOOL finish) {
                        if (YES) {
                            //获取token成功后重新调用本方法
                            [self getUserInfoSuccess:successed fail:failed];
                        }
                    }];
                }else{
                    if ([[data objectForKey:@"state"] integerValue] == 0) {
                        successed(data);
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

/**
 *  用户头像上传
 *
 *  @return
 */
- (void)uploadHeadPortraitByPid:(NSString *)pid withImageData:( NSData * _Nonnull )imageData uploadProgress:(KSUploadProgress _Nonnull)ksUploadProgress  finished:(KSFinishedBlock _Nonnull)finished failed:(KSFailedBlock _Nonnull)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self uploadHeadPortraitByPid:pid withImageData:imageData uploadProgress:ksUploadProgress finished:finished failed:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&pid=%@",@"KinGuard_UploadPhoto",pid];
            NSDictionary *params = [self returnLoginParamers:keyValueString];
            
            NSString *urlstring = [NSString stringWithFormat:@"%@?_sign=%@&_tk=%@&cipher=%@&version=1",KinGuardUploadPhotoApi,[params objectForKey:@"_sign"],[params objectForKey:@"_tk"],[params objectForKey:@"cipher"]];
            
            [[[KinNetworking alloc] init] uploadPhotoFile:imageData path:urlstring photoName:@"KinHeadPortrait" fileName:@"KinHeadPortrait.png" params:nil uploadProgress:ksUploadProgress finished:finished failed:failed];
            
        }
    }else{
        failed(@"您尚未登录，请登录");
    }
    
}

- (void)downloadHeadPortraitByPid:(NSString *)pid andProgress:(KSUploadProgress)progress finished:(KSFinishedBlock)finished failed:(KSFailedBlock)failed
{
    //判断是否登录
    if ([KinGuardTool isLogined]) {
        //判断本地token是否为空
        if ([KinGuardTool isBlankString:[KinGuardTool getLocalLoginToken]]) {
            [KinGuardTool getLoginToken:^(BOOL finish) {
                if (YES) {
                    [self downloadHeadPortraitByPid:(NSString *)pid andProgress:progress finished:finished failed:failed];
                }
            }];
        }else{
            //token不为空
            NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&pid =%@",@"KinGuard_DownloadPhotoFile",pid];
            NSDictionary *params = [self returnLoginParamers:keyValueString];
            
            NSString *urlstring = [NSString stringWithFormat:@"%@?_sign=%@&_tk=%@&cipher=%@&version=1",KinGuardUploadPhotoApi,[params objectForKey:@"_sign"],[params objectForKey:@"_tk"],[params objectForKey:@"cipher"]];
            
            [[[KinNetworking alloc] init] downloadFileFromPath:urlstring withParams:nil andFileName:@"HeadPortrait.png" progress:progress finished:finished failed:failed];
        }
    }else{
        failed(@"您尚未登录，请登录");
    }
}


#pragma mark - 登录操作
//登录
- (void)loginWithMobile:(NSString * _Nonnull)mobile withPassword:(NSString * _Nonnull)password success:(KSFinishedBlock _Nonnull)successed fail:(KSFailedBlock _Nonnull)failed
{
    NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&mobile=%@&password=%@",@"KinGuard_Login",mobile,password];
    
    NSDictionary *body = [self returnParamer:keyValueString];
    
    [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuardLoginApi finished:^(NSDictionary *data) {
        
        if ([[data objectForKey:@"state"] integerValue] == 0) {
//            //获取登录token值
//            [KinGuardTool getLoginToken:^(BOOL finish) {
//                
//            }];
            
            //登录成功之后需要存储用户名和密码
            [KinGuardTool storeLoginInfo:mobile withPwd:password];
            if (![KinGuardTool isBlankString:[data objectForKey:@"logintoken"]]) {
                //获取到登录token后存储在本地
                [KinGuardTool storeLoginToken:[data objectForKey:@"logintoken"]];
            }
            successed(data);
        }else{
            failed([data objectForKey:@"desp"]);
        }
        
    } failed:^(NSString *error) {
        failed(error);
    }];
}

//退出登录
- (void)loginOutWithMobile:(NSString * _Nonnull)mobile success:(KSFinishedBlock _Nonnull)successed fail:(KSFailedBlock _Nonnull)failed
{
    NSString *keyValueString = [NSString stringWithFormat:@"funname=%@&mobile=%@",@"KinGuard_LoginOut",mobile];
    
    NSDictionary *body = [self returnParamer:keyValueString];
    
    [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuardLoginApi finished:^(NSDictionary *data) {
        
        if ([[data objectForKey:@"state"] integerValue] == 0) {
            successed(data);
            //退出成功后需要清除用户名和密码 和token值
            [KinGuardTool removeLoginInfo];
        }else{
            failed([data objectForKey:@"desc"]);
        }
        
    } failed:^(NSString *error) {
        failed(error);
    }];
}

@end
