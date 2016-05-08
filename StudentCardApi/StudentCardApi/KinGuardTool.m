//
//  KinGuardTool.m
//  StudentCardApi
//
//  Created by Rainer on 16/4/3.
//  Copyright © 2016年 JJS-iMac. All rights reserved.
//

#import "KinGuardTool.h"
#import <CommonCrypto/CommonHMAC.h>
#import "HostDefines.h"
#import "KinGuartApi.h"
#import "KinNetworking.h"

@implementation KinGuardTool

//判断空值
+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

//hash算法
+ (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [[plaintext stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    
    return HMAC;
}

//rc4加密
+ (NSString *)encryptString:(NSString *)stringToEncrypt withKey:(NSString *)key
{
    int i = 0;
    int j = 0;
    unsigned char s[256];
    
    for (int a = 0; a < 256; a++)
    {
        s[a] = a;
    }
    
    for (int b = 0; b < 256; b++)
    {
        j = (j + s[b] + [key characterAtIndex:(b % key.length)]) % 256;
        
        unsigned char tempVar; 
        tempVar = s[b];
        s[b] = s[j];
        s[j] = tempVar;
        
    }
    i = j = 0;
    
    NSMutableString *rfunc = [[NSMutableString alloc] init];
    int iStringLength = [stringToEncrypt length];
    unsigned char k;
    unsigned char t;
    
    for (int c = 0; c < iStringLength; c++){
        
        i = (i + 1) % 256;
        j = (j + s[i]) % 256;
        
        unsigned char tempVar;
        tempVar = s[i];
        s[i] = s[j];
        s[j] = tempVar;
        
        unsigned char KSA = s[(s[i] + s[j]) % 256];
        
        k = abs (KSA);
        t = [stringToEncrypt characterAtIndex:c];
        [rfunc appendFormat:@"%02x", (unsigned char)(k ^ t)];
    }
    return rfunc;
}

//存储登录信息
+ (void)storeLoginInfo:(NSString *)mobile withPwd:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:mobile forKey:KinLoginMobile];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:KinLoginPwd];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//存储登录token信息
+ (void)storeLoginToken:(NSString *)loginToken
{
    [[NSUserDefaults standardUserDefaults] setObject:loginToken forKey:KinLoginToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//清除登录信息
+ (void)removeLoginInfo
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KinLoginMobile];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KinLoginPwd];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KinLoginToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//获取登录信息
+ (NSDictionary *)getLoginInfo
{
    NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:KinLoginMobile];
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:KinLoginPwd];
    
    NSDictionary *result = @{KinLoginMobile:mobile,KinLoginPwd:pwd};
    return result;
}

//获取本地登录token值
+ (NSString *)getLocalLoginToken
{
    NSString *loginToken = [[NSUserDefaults standardUserDefaults] objectForKey:KinLoginToken];
    return loginToken;
}

//判断是否是登录状态
+ (BOOL)isLogined
{
    NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:KinLoginMobile];
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:KinLoginPwd];
    
    if (![self isBlankString:mobile] && ![self isBlankString:pwd]) {
        return YES;
    }
    return NO;
}

// 在sdk内部调用 不暴露接口  登录之后获取token  失效之后获取token
#pragma mark - 获取token
+ (void)getLoginToken:(CompletionBlock)completion
{
    NSDictionary *loginInfo = [self getLoginInfo];
    NSString *mobile = [loginInfo objectForKey:KinLoginMobile];
    NSString *password = [loginInfo objectForKey:KinLoginPwd];
    
    NSString *keyValueString = [NSString stringWithFormat:@"acc=%@&funname=%@&pwd=%@",mobile,@"KinGuard_GetLoginToken",password];
    
    //rc4加密值
    NSString *rc4string = [KinGuardTool encryptString:keyValueString withKey:[KinGuartApi sharedKinGuard].appSecret];
    
    //hash加密值
    NSString *mobileHash = [KinGuardTool hmac:keyValueString withKey:[KinGuartApi sharedKinGuard].appSecret];
    
    NSDictionary *body = @{@"hash":mobileHash,@"key":[KinGuartApi sharedKinGuard].appKey,@"cipher":rc4string,@"version":@"1"};
    
    [[KinNetworking sharedInstance] requestDataFromWSWithParams:body forPath:KinGuardTokenApi finished:^(NSDictionary *data) {
        NSLog(@"%@",data);
        
        if (![self isBlankString:[data objectForKey:@"logintoken"]]) {
            //获取到登录token后存储在本地
            [self storeLoginToken:[data objectForKey:@"logintoken"]];
            completion(YES);
        }else{
            //失败了重新获取
            [self getLoginToken:completion];
            completion(NO);
        }
        
    } failed:^(NSString *error) {
        NSLog(@"%@",error);
        completion(NO);
        //失败了重新获取
        [self getLoginToken:completion];
    }];
}

+ (NSDictionary *)returnParamers:(NSString *)keyAndValueString
{
    //rc4加密值
    NSString *rc4String = [KinGuardTool encryptString:keyAndValueString withKey:[KinGuartApi sharedKinGuard].appSecret];
    
    //hash加密值
    NSString *hashString = [KinGuardTool hmac:keyAndValueString withKey:[KinGuartApi sharedKinGuard].appSecret];
    
    NSString *token = [KinGuardTool getLocalLoginToken];
    NSDictionary *body = @{@"_sign":hashString,@"_tk":token,@"cipher":rc4String,@"version":@"1"};
    
    return body;
}

@end
