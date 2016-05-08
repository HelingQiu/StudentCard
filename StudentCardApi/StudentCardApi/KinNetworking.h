//
//  KSModel.h
//  TaiPoFun
//
//  Created by Rainer on 4/1/16.
//  Copyright (c) 2016 KineticSpace Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "TypeDefines.h"

/**
 *  It's for  AFNetworking 1.x, Just adapter iOS 7.0 and higher
 *
 *  @since 1.0.0
 */
@interface KinNetworking : NSObject

+ (id)sharedInstance;
+ (void)startMonitoringNetwork;
+ (BOOL)isNetworkReachable;
//Network Request Method(default is POST)
@property (nonatomic , copy) NSString *httpMethod;

//post
- (void)requestDataFromWSWithParams:(NSDictionary *)params forPath:(NSString *)path finished:(KSFinishedBlock)finished failed:(KSFailedBlock)failed;

/**
 *  GET
 *
 *  @param params   参数
 *  @param url      请求地址
 *  @param isJson   是否是json格式
 *  @param finished 请求完成
 *  @param failed   请求失败
 */
- (void)getDataFromParams:(NSDictionary *)params
                   forUrl:(NSString *)url
                   isJson:(BOOL)isJson
                 finished:(KSFinishedBlock)finished
                   failed:(KSFailedBlock)failed;

#pragma mark - Download method

- (void)downloadFileFromPath:(NSString *)path
                  withParams:(NSDictionary *)params
                 andFileName:(NSString *)fileName
                    progress:(KSUploadProgress)progress
                    finished:(KSFinishedBlock)finished
                      failed:(KSFailedBlock)failed;


#pragma mark - Upload method

/**
 *  upload audio method
 *
 *  @param path             service path
 *  @param fileData         data
 *  @param fileName         file name
 *  @param name             name
 *  @param mimeType         type
 *  @param params           parms
 *  @param ksUploadProgress progress
 *  @param finished         finish report
 *  @param failed           fail report
 */
- (void)uploadAudioFileToPath:(NSString *)path
                  andFileData:(NSData *)fileData
                     fileName:(NSString *)fileName
                         name:(NSString *)name
//                mimeType:(NSString *)mimeType
                       params:(NSDictionary *)params
               uploadProgress:(KSUploadProgress)ksUploadProgress
                     finished:(KSFinishedBlock)finished
                       failed:(KSFailedBlock)failed;
/**
 *  upload photo method
 */
- (void)uploadPhotoFile:(NSData *)fileData
                   path:(NSString *)path
              photoName:(NSString *)photoName
               fileName:(NSString *)fileName
                 params:(NSDictionary *)params
         uploadProgress:(KSUploadProgress)uploadProgress
               finished:(KSFinishedBlock)finished failed:(KSFailedBlock)failed;

/**
 *  upload file
 */
- (void)uploadFileToPath:(NSString *)path
             andFileData:(NSData *)fileData
                fileName:(NSString *)fileName
                    name:(NSString *)name
                mimeType:(NSString *)mimeType
                  params:(NSDictionary *)params
          uploadProgress:(KSUploadProgress)ksUploadProgress
                finished:(KSFinishedBlock)finished
                  failed:(KSFailedBlock)failed;
@end
