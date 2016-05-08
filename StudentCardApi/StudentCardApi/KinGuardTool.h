//
//  KinGuardTool.h
//  StudentCardApi
//
//  Created by Rainer on 16/4/3.
//  Copyright © 2016年 JJS-iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeDefines.h"

@interface KinGuardTool : NSObject

//判断空值
+ (BOOL)isBlankString:(NSString *)string;

//hash算法
+ (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key;

//rc4加密
+ (NSString *)encryptString:(NSString *)stringToEncrypt withKey:(NSString *)key;

//存储登录信息
+ (void)storeLoginInfo:(NSString *)mobile withPwd:(NSString *)password;

//存储登录token信息
+ (void)storeLoginToken:(NSString *)loginToken;

//清除登录信息 包括token值
+ (void)removeLoginInfo;

//获取登录信息
+ (NSDictionary *)getLoginInfo;

//获取本地登录token值
+ (NSString *)getLocalLoginToken;

//判断是否是登录状态
+ (BOOL)isLogined;

// 在sdk内部调用 不暴露接口  登录之后获取token  失效之后获取token(从接口获取)
#pragma mark - 获取token
+ (void)getLoginToken:(CompletionBlock)completion;

+ (NSDictionary *)returnParamers:(NSString *)keyAndValueString;
@end
